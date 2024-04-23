# Web App

This is a node.js server which has User APIs.

## Installation

Use the node package manager (NPM) to install the web app's dependencies.

``` shell
npm install
```

## Pre-requisites
1. Node.js 20.14.0 must be installed (comes with built-in npm)
2. Postgres must be installed
3. A user must be created as part of Postgres so that the app assumes that user.
username: app, password: password, user can: login, create database

## Running the server
As everything is handled as part of the start script of npm, simply execute the following shell command to start the application:

``` shell
npm run start
```