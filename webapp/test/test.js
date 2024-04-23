import supertest from 'supertest';
import { expect } from 'chai';
import app from '../src/app.js';
import { createUserTokenRelation } from '../src/db.js';

import { deleteUserDb, createTokenDb, POSTGRES } from '../src/db.js';

const TEST_USER = {
  first_name: 'John',
  last_name: 'Doe',
  username: 'john.doe@email.com',
  password: 'password'
};


describe('Test suite', function() {
  it('should pass', function() {
    return true;
  });

  it.skip('should fail', function(done) {
    done(new Error('Test expected to fail'));
  });
});

const makeGetRequest = (request, username, password) =>
  request.get('/v2/user/self').auth(username, password);

const mockVerifyUser = async (request, id) => {
  const { token } = await createTokenDb(id);

  await request.get(`/verify/${token}`);
};

describe('/v2/user', function() {

  let request = null;
  let createUserId = null;

  before('setting up server', async function() {
    try {
      await POSTGRES.sync();
      createUserTokenRelation();

      request = supertest(app);
    } catch (error) {
      console.error('Error setting up server:', error);
      process.exit(1);
    }
  });

  it('should create a new user', async function() {
    const response = await request.post('/v2/user')
      .set('Content-Type', 'application/json')
      .send(TEST_USER);

    expect(response.status).to.eql(201);

    expect(response.body).to.have.property('id');

    createUserId = response.body.id;

    await mockVerifyUser(request, createUserId);

    const getResponse = await makeGetRequest(request, TEST_USER.username, TEST_USER.password);

    expect(getResponse.status).to.eql(200);

    expect(getResponse.body).to.have.property('first_name');
    expect(getResponse.body.first_name).to.eql(TEST_USER.first_name);
    expect(getResponse.body).to.have.property('last_name');
    expect(getResponse.body.last_name).to.eql(TEST_USER.last_name);
    expect(getResponse.body).to.have.property('username');
    expect(getResponse.body.username).to.eql(TEST_USER.username);
    expect(getResponse.body).to.have.property('account_created');
    expect(!isNaN(new Date(getResponse.body.account_created).getTime())).to.be.true;
    expect(getResponse.body).to.have.property('account_updated');
    expect(!isNaN(new Date(getResponse.body.account_updated).getTime())).to.be.true;
  });

  it('should update the user', async function() {
    const UPDATE_NAME = 'Jane';
    const updateResponse = await request.put('/v2/user/self')
      .set('Content-Type', 'application/json')
      .auth(TEST_USER.username, TEST_USER.password)
      .send({ first_name: UPDATE_NAME });

    expect(updateResponse.status).to.eql(204);

    const getResponse = await makeGetRequest(request, TEST_USER.username, TEST_USER.password);

    expect(getResponse.status).to.eql(200);
    expect(getResponse.body).to.have.property('first_name');
    expect(getResponse.body.first_name).to.eql(UPDATE_NAME);
    expect(getResponse.body).to.have.property('last_name');
    expect(getResponse.body.last_name).to.eql(TEST_USER.last_name);
    expect(getResponse.body).to.have.property('username');
    expect(getResponse.body.username).to.eql(TEST_USER.username);
    expect(getResponse.body).to.have.property('account_created');
    expect(!isNaN(new Date(getResponse.body.account_created).getTime())).to.be.true;
    expect(getResponse.body).to.have.property('account_updated');
    expect(!isNaN(new Date(getResponse.body.account_updated).getTime())).to.be.true;
  });

  after('db clean up', async function() {
    if (createUserId) {
      await deleteUserDb(createUserId);
    }
  });
});