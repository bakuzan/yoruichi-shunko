const { TodoInstance, TodoTemplate } = require('../connectors');

const TodoTemplateResolvers = require('./todo-template');
const TodoInstanceResolvers = require('./todo-instance');
const GraphqlDate = require('./graphql-date');

const handleDeleteResponse = require('../utils/delete-response');

module.exports = {
  Query: {
    todoTemplates() {
      return TodoTemplate.findAll({
        order: [['date', 'DESC']]
      });
    },
    todoInstances() {
      return TodoInstance.findAll({
        order: [['date', 'DESC']]
      });
    }
  },
  Mutation: {
    async todoTemplateRemove(_, { id }) {
      const deletedCount = await TodoTemplate.destroy({ where: { id } });
      return handleDeleteResponse(id, deletedCount);
    },
    async todoInstanceRemove(_, { id }) {
      const deletedCount = await TodoInstance.destroy({ where: { id } });
      return handleDeleteResponse(id, deletedCount);
    }
  },
  TodoTemplate: TodoTemplateResolvers,
  TodoInstance: TodoInstanceResolvers,
  Date: GraphqlDate
};
