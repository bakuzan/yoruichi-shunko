const dotenv = require('dotenv');
dotenv.config();

const chalk = require('chalk');
const express = require('express');
const { ApolloServer } = require('apollo-server-express');

const Constants = require('./constants/index');
const typeDefs = require('./type-definitions');
const resolvers = require('./resolvers');
const context = require('./context');

const GRAPHQL_PATH = '/yri-graphql';
const app = express();
const server = new ApolloServer({
  typeDefs,
  resolvers,
  context: () => ({ ...context }),
  introspection: true,
  playground: {
    settings: {
      'editor.cursorShape': 'block',
      'editor.fontSize': 16,
      'editor.fontFamily': '"Lucida Console", Consolas, monospace',
      'editor.theme': 'light'
    }
  },
  formatError: (error) => {
    console.log(error);
    return error;
  }
});

// Overide origin if it doesn't exist
app.use(function(req, _, next) {
  req.headers.origin = req.headers.origin || req.headers.host;
  next();
});

// Start the server
const PORT =
  (process.env.NODE_ENV === Constants.environment.production
    ? process.env.PORT
    : process.env.SERVER_PORT) || 9933;

server.applyMiddleware({
  app,
  path: GRAPHQL_PATH,
  cors: {
    origin: function(origin, callback) {
      if (Constants.whitelist.test(origin)) {
        callback(null, true);
      } else {
        console.log(chalk.red(`Origin: ${origin}, not allowed by CORS`));
        callback(new Error('Not allowed by CORS'));
      }
    }
  }
});

app.listen(PORT, () => {
  console.log(
    chalk
      .hex('#993399')
      .bold(
        `Go to http://localhost:${PORT}${server.graphqlPath} to run queries!`
      )
  );
});
