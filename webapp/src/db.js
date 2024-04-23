import { Sequelize } from 'sequelize';
import logger from './logger.js';
import { DB_CONFIGS } from './configs.js';
import { UserSchema, VerificationTokenSchema, schemaOptions } from './model.js';

const sequelize = new Sequelize(DB_CONFIGS);

const model = sequelize.define('User', UserSchema, schemaOptions);
const tokenModel = sequelize.define('Token', VerificationTokenSchema);

const createUserTokenRelation = () => {
  model.hasOne(tokenModel, {
    foreignKey: 'userId',
    onDelete: 'CASCADE'
  });

  tokenModel.belongsTo(model, {
    foreignKey: 'userId'
  });
};

createUserTokenRelation();

export const initDb = async () => {
  try {
    await sequelize.sync();
  } catch (error) {
    logger.error({
      message: 'Failed to initialize database',
      error: {
        message: error.message,
        stack: error.stack
      }
    });

    process.exit(1);
  }
};

export const testConnection = async () => {
  try {
    await sequelize.authenticate();
  } catch (error) {
    logger.error({
      message: 'Failed to connect to database',
      error: {
        message: error.message,
        stack: error.stack
      }
    });

    throw error;
  }
};

export const createUserDb = async (user) => {
  try {
    return await model.create(user);
  } catch (error) {
    logger.error({
      message: 'Failed to create user',
      error: {
        message: error.message,
        stack: error.stack
      }
    });

    throw error;
  }
};

export const findUserByUsernameDb = async (username, scope) => {
  try {
    return await scope && scope.withPassword
      ? model.findOne({ where: { username }})
      : model.scope('withoutPassword').findOne({ where: { username }});
  } catch (error) {
    logger.error({
      message: 'Failed to find user by username',
      error: {
        message: error.message,
        stack: error.stack
      }
    });

    throw error;
  }
};

export const updateUserDb = async (user, updateObj) => {
  try {
    user.set(updateObj);

    return await user.save();
  } catch (error) {
    logger.error({
      message: 'Failed to update user',
      error: {
        message: error.message,
        stack: error.stack
      }
    });

    throw error;
  }
};

export const deleteUserDb = async (userId) => {
  try {
    return await model.destroy({ where: { id: userId }});
  } catch (error) {
    logger.error({
      message: 'Failed to delete user',
      error: {
        message: error.message,
        stack: error.stack
      }
    });

    throw error;
  }
};

export const findUserByIdDb = async (userId, scope) => {
  try {
    return await scope && scope.withPassword
      ? model.findByPk(userId)
      : model.scope('withoutPassword').findByPk(userId);
  } catch (error) {
    logger.error({
      message: 'Failed to find user by id',
      error: {
        message: error.message,
        stack: error.stack
      }
    });

    throw error;
  }
};

export const getTokenDb = async (token) => {
  try {
    return await tokenModel.findOne({ where: { token }});
  } catch (error) {
    logger.error({
      message: 'Failed to get token',
      error: {
        message: error.message,
        stack: error.stack
      }
    });

    throw error;
  }
};

export const createTokenDb = async (userId) => {
  try {
    return await tokenModel.create({
      userId: userId,
      expiresAt: new Date(new Date().getTime() + (2 * 60 * 1000)),
    });
  } catch (error) {
    logger.error({
      message: 'Failed to create token',
      error: {
        message: error.message,
        stack: error.stack
      }
    });

    throw error;
  }
};

export const POSTGRES = sequelize;
export { createUserTokenRelation };