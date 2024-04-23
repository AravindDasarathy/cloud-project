import { PubSub } from '@google-cloud/pubsub';
import dotenv from 'dotenv';
import { GCP_CONFIGS } from './configs.js';
import logger from './logger.js';

dotenv.config();

const pubsub = new PubSub({ projectId: GCP_CONFIGS.projectId });

export const publishTopicMessage = async (data) => {
  try {
    const dataString = JSON.stringify(data);
    const dataBuffer = Buffer.from(dataString);

    const messageId = await pubsub
      .topic(GCP_CONFIGS.topicName)
      .publishMessage({ data: dataBuffer });

    logger.info({
      message: `Message ${messageId} published.`,
      data: data,
    });

  } catch (error) {
    logger.error({
      message: 'Error publishing message',
      error: error,
    });

    throw error;
  }
};
