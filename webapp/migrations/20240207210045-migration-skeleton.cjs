'use strict';

/** @type {import('sequelize-cli').Migration} */

module.exports = {
  async up (queryInterface, { DataTypes }) {
    await queryInterface.createTable('Users',
      {
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
        account_created: {
          type: DataTypes.DATE,
          allowNull: false,
          defaultValue: DataTypes.NOW
        },
        account_updated: {
          type: DataTypes.DATE,
          allowNull: false,
          defaultValue: DataTypes.NOW
        },
        verified: {
          type: DataTypes.BOOLEAN,
          defaultValue: false
        }
      }
    );

    await queryInterface.createTable('Tokens',
    {
      userId: {
        type: DataTypes.INTEGER,
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
        allowNull: false
      }
    }
    );
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.dropTable('Users');
    await queryInterface.dropTable('Tokens');
  }
};
