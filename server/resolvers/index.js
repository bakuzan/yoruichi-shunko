const Op = require('sequelize').Op;
const { TodoInstance, TodoTemplate } = require('../connectors');

const TodoTemplateResolvers = require('./todo-template');
const TodoInstanceResolvers = require('./todo-instance');
const GraphqlDate = require('./graphql-date');

const getDateRangeForCalendarMode = require('../utils/date-range');
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
    },
    async calendarView(_, { mode, date }) {
      const order = [['date', 'asc']];
      const [fromDate, toDate] = getDateRangeForCalendarMode(mode, date);
      return await TodoInstance.findAll({
        where: {
          date: {
            [Op.lte]: toDate,
            [Op.gte]: fromDate
          }
        },
        order,
        include: [TodoTemplate]
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
