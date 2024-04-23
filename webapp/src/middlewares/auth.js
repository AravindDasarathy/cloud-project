import bcrypt from 'bcrypt';
import { findUserByUsernameDb } from '../db.js';
import logger from '../logger.js';

const auth = async (req, res, next) => {
  const token = req.headers['authorization'];

  if (!token.startsWith('Basic '))  {
    res.status(401);
    res.end();
    return;
  }

  const tokenValue = token.split('Basic ')[1];
  const buffer = Buffer.from(tokenValue, 'base64');
  const decodedToken = buffer.toString('utf-8');

  const [username, password] = decodedToken.split(':');

  try {
    const user = await findUserByUsernameDb(username, { withPassword: true });

    if (!user) {
      res.status(401);
      res.end();

      logger.info({
        id: req.id,
        message: 'Login failed - user not found',
        data: {
          username
        }
      });

      return;
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      res.status(401);
      res.end();

      logger.info({
        id: req.id,
        message: 'Login failed - invalid password',
        data: {
          username
        }
      });

      return;
    }
  } catch (error) {
    res.status(503);
    res.end();

    logger.error({
      id: req.id,
      message: 'Login failed',
      error: {
        message: error.message,
        stack: error.stack
      }
    });

    return;
  }

  req.username = username;
  next();
};

export default auth;