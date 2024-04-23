import { DataTypes } from 'sequelize';

export const UserSchema = {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  first_name: {
    type: DataTypes.STRING,
    allowNull: false
  },
  last_name: {
    type: DataTypes.STRING,
    allowNull: false
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  username: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true
  },
  verified: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  }
};

export const VerificationTokenSchema = {
  userId: {
    type: DataTypes.UUID,
    references: {
      model: 'Users',
      key: 'id'
    },
    primaryKey: true
  },
  token: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    allowNull: false,
    unique: true
  },
  expiresAt: {
    type: DataTypes.DATE,
    allowNull: false,
  }
};

export const schemaOptions = {
  scopes: {
    withoutPassword: {
      attributes: { exclude: ['password'] },
    }
  },
  createdAt: 'account_created',
  updatedAt: 'account_updated'
};