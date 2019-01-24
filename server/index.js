const dotenv = require('dotenv');
dotenv.config();

const chalk = require('chalk');
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { ApolloServer } = require('apollo-server-express');

const Constants = require('./constants/index');
const typeDefs = require('./type-definitions');
const resolvers = require('./resolvers');
const context = require('./context');

const GRAPHQL_PATH = '/yri/graphql';
const app = express();
const server = new ApolloServer({
  graphqlPath: GRAPHQL_PATH,
  typeDefs,
  resolvers,
  context: () => ({ ...context }),
  playground: {
    settings: {
      'editor.theme': 'light'
    }
  },
  formatError: (error) => {
    console.log(error);
    return error;
  }
});

const corsOptions = {
  origin: function(origin, callback) {
    if (Constants.whitelist.test(origin)) {
      callback(null, true);
    } else {
      console.log(chalk.red(`Origin: ${origin}, not allowed by CORS`));
      callback(new Error('Not allowed by CORS'));
    }
  }
};

// Overide origin if it doesn't exist
app.use(function(req, _, next) {
  req.headers.origin = req.headers.origin || req.headers.host;
  next();
});

app.use(GRAPHQL_PATH, cors(corsOptions), bodyParser.json());

// Start the server
const PORT =
  (process.env.NODE_ENV === Constants.environment.production
    ? process.env.PORT
    : process.env.SERVER_PORT) || 9933;

server.applyMiddleware({ app });

app.listen(PORT, () => {
  console.log(
    chalk
      .hex('#993399')
      .bold(
        `Go to http://localhost:${PORT}${server.graphqlPath} to run queries!`
      )
  );
});
