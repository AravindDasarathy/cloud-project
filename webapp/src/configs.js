import dotenv from 'dotenv';
dotenv.config();

export const APP_PORT = 8080;


export const DB_CONFIGS = {
  dialect: 'postgres',
  database: process.env.POSTGRES_DB_NAME || 'cloud_computing',
  host: process.env.POSTGRES_HOST || '127.0.0.1',
  port: 5432,
  username: process.env.POSTGRES_USER || 'app',
  password: process.env.POSTGRES_PASSWORD || 'password'
};

export const GCP_CONFIGS = {
  projectId: process.env.GCP_PROJECT_ID || 'cloud-computing-dev',
  topicName: process.env.GCP_TOPIC_NAME || 'verify-email-topic',
  subscriptionName: process.env.GCP_SUBSCRIPTION_NAME || 'verify-email-subscription'
};

export const DB_URL = `postgres://${DB_CONFIGS.username}:${DB_CONFIGS.password}@${DB_CONFIGS.host}:${DB_CONFIGS.port}/postgres`;
