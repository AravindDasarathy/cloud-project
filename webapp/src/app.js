import express from 'express';
import { healthRouter, userRouter, verifyRouter } from './routes/index.js';
import logger from './logger.js';
import { v4 as uuid } from 'uuid';

const globalErrorHandler = (err, req, res, next) => {
  res.status(503);
  res.end();

  logger.error({
    id: req.id,
    message: 'Something went wrong',
    error: {
      message: err.message,
      stack: err.stack
    }
  });
};

const handleUndefinedRoutes = (req, res, next) => {
  res.status(405);
  res.end();

  logger.info({
    id: req.id,
    message: 'Invalid route',
    method: req.method,
    path: req.path
  });
};

const requestIdGenerator = (req, res, next) => {
  req.id = uuid();
  next();
};

const requestLogger = (req, res, next) => {
  logger.info({
    id: req.id,
    message: 'Incoming request',
    method: req.method,
    path: req.path,
    body: req?.body?.password ? { ...req.body, password: undefined } : req.body
  });

  next();
};

const app = express();

app.disable('x-powered-by');
app.use(express.json());
app.use(requestIdGenerator);
app.use(requestLogger);
app.use(healthRouter);
app.use(userRouter);
app.use(verifyRouter);
app.use(handleUndefinedRoutes);
app.use(globalErrorHandler);

export default app;
