import { Router } from 'express';
import bcrypt from 'bcrypt';
import logger from '../logger.js';
import { createUserDb, findUserByUsernameDb, updateUserDb, createTokenDb } from '../db.js';
import { publishTopicMessage } from '../gcp.js';
import auth from '../middlewares/auth.js';
import { ValidationError } from 'sequelize';

const userRouter = Router();

const isValidUsername = (email) => {
  const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
  return emailRegex.test(email);
};

const hasAdditionalProps = (obj, allowedKeys) =>
  Object.keys(obj).some(key => !allowedKeys.includes(key));

const ALLOWED_KEYS_POST_REQ = ['first_name', 'last_name', 'username', 'password'];
const ALLOWED_KEYS_PUT_REQ = ['first_name', 'last_name', 'password'];

const shouldNotSaveUser = (user) => hasAdditionalProps(user, ALLOWED_KEYS_POST_REQ) ||
  !user.username || user.username.length == 0 ||
  !user.password || user.password.length == 0;

const shouldNotUpdateUser = (user) => hasAdditionalProps(user, ALLOWED_KEYS_PUT_REQ) ||
  (user.first_name && user.first_name.length == 0) ||
  (user.last_name && user.last_name.length == 0) ||
  (user.password && user.password.length == 0);

const isInvalidGetReq = (req) => (req.headers['content-type'] ||
  (req.body && Object.keys(req.body).length > 0) ||
  (req.query && Object.keys(req.query).length > 0));

const getUser = async (req, res, next) => {
  try {
    if (isInvalidGetReq(req)) {
      logger.info({
        id: req.id,
        message: 'Invalid GET request',
        headers: req.headers,
        query: req.query
      });

      res.status(400);
      res.end();
      return;
    }

    const user = await findUserByUsernameDb(req.username);

    if (!user) {
      logger.info({
        id: req.id,
        message: 'User not found',
        data: {
          username: req.username
        }
      });

      res.status(404);
      res.end();
      return;
    }

    if (!user.verified) {
      logger.info({
        id: req.id,
        message: 'User not verified',
        data: {
          username: req.username
        }
      });

      res.status(403);
      res.end();
      return;
    }

    res.status(200);
    res.json(user);

    logger.info({
      id: req.id,
      message: 'User found',
      data: user
    });
  } catch (error) {
    logger.error({
      id: req.id,
      message: 'Failed to get user',
      error: {
        message: error.message,
        stack: error.stack
      }
    });

    res.status(503);
    res.end();
  }
}

const saveUser = async (req, res, next) => {
  try {
    if (shouldNotSaveUser(req.body) || (req.body.username && !isValidUsername(req.body.username))) {
      logger.info({
        id: req.id,
        message: 'Invalid POST request',
        body: req?.body?.password ? { ...req.body, password: '***' } : req.body
      });

      res.status(400);
      res.end();
      return;
    }

    req.body.password = await bcrypt.hash(req.body.password, 10);

    const savedUser = (await createUserDb(req.body)).toJSON();

    delete savedUser.password;

    logger.info({
      id: req.id,
      message: 'User created',
      data: savedUser
    });

    if (process.env.NODE_ENV !== 'test') {
      await publishTopicMessage({
        username: savedUser.username,
        first_name: savedUser.first_name,
        last_name: savedUser.last_name
      });
    }

    res.status(201).json(savedUser);

  } catch (error) {
    if (error instanceof ValidationError) {
      res.status(400);
      res.end();

      logger.info({
        id: req.id,
        message: 'Invalid POST request',
        body: req?.body?.password ? { ...req.body, password: '***' } : req.body
      });

      return;
    }

    res.status(503);
    res.end();

    logger.error({
      id: req.id,
      message: 'Failed to create user',
      error: {
        message: error.message,
        stack: error.stack
      }
    });
  }
};

const updateUser = async (req, res, next) => {
  try {
    if (shouldNotUpdateUser(req.body) || (req.username && !isValidUsername(req.username))) {
      res.status(400);
      res.end();

      logger.info({
        id: req.id,
        message: 'Invalid PUT request',
        body: req?.body?.password ? { ...req.body, password: '***' } : req.body
      });

      return;
    }

    const user = await findUserByUsernameDb(req.username);

    if (!user) {
      res.status(404);
      res.end();

      logger.info({
        id: req.id,
        message: 'User not found',
        body: req?.body?.password ? { ...req.body, password: '***' } : req.body,
        data: {
          username: req.username
        }
      });

      return;
    }

    if (!user.verified) {
      logger.info({
        id: req.id,
        message: 'User not verified',
        data: {
          username: req.username
        }
      });

      res.status(403);
      res.end();

      return;
    }

    if (req.body.password) {
      req.body.password = await bcrypt.hash(req.body.password, 10);
    }

    await updateUserDb(user, req.body);

    res.status(204);
    res.end();

    logger.info({
      id: req.id,
      message: 'User updated',
      body: req?.body?.password ? { ...req.body, password: '***' } : req.body,
      data: {
        username: req.username
      }
    });

  } catch (error) {
    console.error(error);
    if (error instanceof ValidationError) {
      res.status(400);
      res.end();

      logger.info({
        id: req.id,
        message: 'Invalid PUT request',
        body: req?.body?.password ? { ...req.body, password: '***' } : req.body
      });

      return;
    }

    res.status(503);
    res.end();

    logger.error({
      id: req.id,
      message: 'Failed to update user',
      error: {
        message: error.message,
        stack: error.stack
      }
    });
  }
};

userRouter.get('/v2/user/self', auth, getUser);
userRouter.put('/v2/user/self', auth, updateUser);
userRouter.post('/v2/user', saveUser);

export default userRouter;