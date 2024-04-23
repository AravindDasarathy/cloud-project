import winston from 'winston';
import dotenv from 'dotenv';

const { combine, timestamp, json } = winston.format;

dotenv.config();

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: combine(
    timestamp(),
    json()
  ),
  transports: [
    new winston.transports.File({
      filename: process.env.NODE_ENV == 'PROD' ? '/var/log/webapp/webapp.log' : 'webapp.log'
    })
  ]
});

if (process.env.NODE_ENV !== 'PROD') {
  logger.add(
    new winston.transports.Console()
  );
}

export default logger;