import { Router } from 'express';
import { testConnection } from '../db.js';
import logger from '../logger.js';

const healthRouter = Router();

const isInvalidGetReq = (req) => (req.headers['content-type'] ||
  (req.body && Object.keys(req.body).length > 0) ||
  (req.query && Object.keys(req.query).length > 0));

healthRouter.use('/healthz', (req, res, next) => {
  res.set('x-content-type-options', 'nosniff');
  res.set('pragma', 'no-cache');
  res.set('cache-control', 'no-cache, no-store, must-revalidate');

  if (req.method != 'GET') {
    res.status(405);
    res.end();
    return;
  }

  next();
});

healthRouter.get('/healthz', async (req, res) => {
  if (isInvalidGetReq(req)) {
    res.status(400);
    res.end();
    return;
  }

  try {
    await testConnection();

    res.status(200);

    logger.info({
      id: req.id,
      message: 'Server healthy'
    });
  } catch (error) {
    logger.error({
      id: req.id,
      message: 'Server health check failed'
    });

    res.status(503);
  }

  res.end();
});

export default healthRouter;