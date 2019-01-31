const { GraphQLScalarType } = require('graphql');
const { Kind } = require('graphql/language');

module.exports = {
  Date: new GraphQLScalarType({
    name: 'Date',
    description: 'Date custom scalar type',
    parseValue(value) {
      console.log('parse > ', value);
      return new Date(value); // value from the client
    },
    serialize(value) {
      console.log('serialize > ', value);
      return value.getTime(); // value sent to the client
    },
    parseLiteral(ast) {
      if (ast.kind === Kind.INT) {
        console.log('literal > ', ast);
        return new Date(ast.value); // ast value is always in string format
      }

      return null;
    }
  })
};
