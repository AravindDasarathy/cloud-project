import { Router } from 'express';
import { findUserByIdDb, updateUserDb, getTokenDb } from '../db.js';
import logger from '../logger.js';

const verifyRouter = Router();

const isValidToken = (uuid) => {
  return /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89abAB][0-9a-f]{3}-[0-9a-f]{12}$/.test(uuid);
};

const verifyUser = async (req, res) => {
  try {
    const token = req.params.token;

    if (!token) {
      logger.info({
        id: req.id,
        message: 'Missing token',
        data: {
          token
        }
      });

      res.status(400).send({
        message: 'Verification token is required in URL'
      });

      return;
    }

    if (!isValidToken(token)) {
      logger.info({
        id: req.id,
        message: 'Invalid token',
        data: {
          token
        }
      });

      res.status(400).send({
        message: 'Invalid URL'
      });

      return;
    }

    const tokenDetails = await getTokenDb(token);

    if (!tokenDetails) {
      logger.info({
        id: req.id,
        message: 'Verification token expired or invalid',
        data: {
          token
        }
      });

      res.status(403).send({
        message: 'URL expired or invalid'
      });

      return;
    }

    if (new Date() > tokenDetails.expiresAt) {
      logger.info({
        id: req.id,
        message: 'Verification token expired',
        data: {
          tokenDetails
        }
      });

      res.status(400).send({
        message: 'URL expired'
      });

      return;
    }

    const user = await findUserByIdDb(tokenDetails.userId);

    if (!user) {
      logger.info({
        id: req.id,
        message: 'User not found',
        data: {
          tokenDetails
        }
      });

      res.status(404).send({
        message: 'User not found'
      });

      return;
    }

    if (user.verified) {
      logger.info({
        id: req.id,
        message: 'User already verified',
        data: {
          username: user.username
        }
      });

      res.status(400).send({
        message: 'Email is already verified'
      });

      return;
    }

    await updateUserDb(user, { verified: true });

    res.status(200).send({
      message: 'Email verified successfully'
    });

    logger.info({
      id: req.id,
      message: 'User verified',
      data: {
        username: user.username,
        token: token
      }
    });
  } catch (error) {
    logger.error({
      id: req.id,
      message: 'Failed to verify user',
      error: {
        message: error.message,
        stack: error.stack
      }
    });

    res.status(503);
    res.end();
  }
};


verifyRouter.get('/verify/:token', verifyUser);

export default verifyRouter;