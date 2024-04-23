const { Sequelize } = require('sequelize');
const { UserSchema, VerificationTokenSchema, schemaOptions } = require('./model');

const DB_CONFIGS = {
  dialect: 'postgres',
  database: process.env.POSTGRES_DB_NAME || 'cloud_computing',
  host: process.env.POSTGRES_HOST || '127.0.0.1',
  port: 5432,
  username: process.env.POSTGRES_USER || 'app',
  password: process.env.POSTGRES_PASSWORD || 'password'
};

const sequelize = new Sequelize(DB_CONFIGS);
const model = sequelize.define('User', UserSchema, schemaOptions);
const tokenModel = sequelize.define('Token', VerificationTokenSchema);

const initDb = async () => {
  try {
    await sequelize.sync();
  } catch (error) {
    console.error({
      message: 'Failed to initialize database',
      error: {
        message: error.message,
        stack: error.stack
      }
    });

    process.exit(1);
  }
};

const testConnection = async () => {
  try {
    await sequelize.authenticate();
  } catch (error) {
    console.error({
      message: 'Failed to connect to database',
      error: {
        message: error.message,
        stack: error.stack
      }
    });

    throw error;
  }
};

const createTokenDb = async (userId) => {
  try {
    return await tokenModel.create({
      userId: userId,
      expiresAt: new Date(new Date().getTime() + (2 * 60 * 1000)),
    });
  } catch (error) {
    console.error({
      message: 'Failed to create token',
      error: {
        message: error.message,
        stack: error.stack
      }
    });

    throw error;
  }
};

const findUserByUsernameDb = async (username, scope) => {
  try {
    return await scope && scope.withPassword
      ? model.findOne({ where: { username }})
      : model.scope('withoutPassword').findOne({ where: { username }});
  } catch (error) {
    console.error({
      message: 'Failed to find user by username',
      error: {
        message: error.message,
        stack: error.stack
      }
    });

    throw error;
  }
};

module.exports = {
  initDb,
  testConnection,
  createTokenDb,
  findUserByUsernameDb
};