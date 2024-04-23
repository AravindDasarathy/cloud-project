const functions = require('@google-cloud/functions-framework');
const axios = require('axios');
const FormData = require('form-data');
const { initDb, testConnection, createTokenDb, findUserByUsernameDb } = require('./db');

const FROM_EMAIL = process.env.MAILGUN_FROM_EMAIL || '';
const TEXT = 'Thank you for creating an account with us! Please verify your email address within 2 minutes';
const SUBJECT = 'Cloud Webapp - Email Verification';

const generateText = (firstName, lastName, url) =>
  `Hello ${firstName} ${lastName},\n\n${TEXT}: ${url}\n\nRegards,\nCloud Webapp Team.`;

const isValidEmail = (email) => {
  const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
  return emailRegex.test(email);
};

const checkMailgunConfig = () => {
  if (!process.env.MAILGUN_API_KEY) {
    throw new Error('Mailgun API key is not set');
  }
  if (!process.env.MAILGUN_DOMAIN) {
    throw new Error('Mailgun domain is not set');
  }
};

const sendEmail = async (firstName, lastName, fromEmail, toEmail, subject, token) => {
  const apiKey = process.env.MAILGUN_API_KEY;
  const domain = process.env.MAILGUN_DOMAIN;
  const verificationUrl = `https://${domain}/verify/${token}`;
  const url = `https://api.mailgun.net/v3/${domain}/messages`;
  const formData = new FormData();

  formData.append('from', fromEmail);
  formData.append('to', toEmail);
  formData.append('subject', subject);
  formData.append('text', generateText(firstName, lastName, verificationUrl));

  const auth = 'Basic ' + Buffer.from(`api:${apiKey}`).toString('base64');
  try {
    const response = await axios.post(url, formData, {
      headers: {
        'Authorization': auth,
        ...formData.getHeaders()
      }
    });
    console.log('Email sent successfully', response.data);
  } catch (error) {
    console.error('Mailgun API error:', error.response ? error.response.data : error);
    throw new Error('Failed to send email');
  }
};

functions.cloudEvent('processPubSubMessage', async (cloudEvent) => {
  try {
    checkMailgunConfig();
    await initDb();
    await testConnection();

    if (!FROM_EMAIL) {
      throw new Error('From email is not set');
    }

    if (!process.env.WEBAPP_DOMAIN) {
      throw new Error('Webapp domain is not set');
    }

    const messageData = cloudEvent.data ? Buffer.from(cloudEvent.data.message.data, 'base64').toString() : '{}';
    const { username, first_name, last_name, subject } = JSON.parse(messageData);

    if (!username || !first_name || !last_name) {
      throw new Error('Missing required email parameters');
    }

    if (!isValidEmail(username)) {
      throw new Error('Invalid email address');
    }

    const userDetails = await findUserByUsernameDb(username);

    if (!userDetails) {
      throw new Error('User not found');
    }

    const tokenDetails = await createTokenDb(userDetails.id);

    await sendEmail(first_name, last_name, FROM_EMAIL, username, subject || SUBJECT, tokenDetails.token);

    console.log(`Email sent from ${FROM_EMAIL} to ${username}`);
  } catch (error) {
    console.error(`Error processing message: ${error.message}`);
  }
});
