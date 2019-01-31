const Op = require('sequelize').Op;
const { TodoInstance, TodoTemplate } = require('../connectors');

const TodoTemplateResolvers = require('./todo-template');
const TodoInstanceResolvers = require('./todo-instance');
const CustomTypes = require('./custom-types');

const getDateRangeForCalendarMode = require('../utils/date-range');
const handleDeleteResponse = require('../utils/delete-response');
const generateTodoInstances = require('../utils/generate-instances');
const validateTodoTemplate = require('../utils/validate-todo-template');

module.exports = {
  Query: {
    todoTemplateById(_, { id }) {
      return TodoTemplate.findByPk(id);
    },
    todoTemplates() {
      return TodoTemplate.findAll({
        order: [['date', 'DESC']]
      });
    },
    todoInstances(_, { todoTemplateId }) {
      const filter = todoTemplateId
        ? {
            where: {
              todoTemplateId
            }
          }
        : {};

      return TodoInstance.findAll({
        ...filter,
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
    async todoCreate(_, { template }) {
      const validate = validateTodoTemplate(template);
      if (!validate.success) {
        return validate;
      }

      const todoInstances = generateTodoInstances(template);

      return await TodoTemplate.create(
        {
          ...template,
          todoInstances
        },
        { include: [TodoInstance] }
      )
        .then(() => ({ success: true, errorMessages: [] }))
        .catch((error) => ({ success: false, errorMessages: [error.message] }));
    },
    async todoUpdate(_, { todoTemplateId, template, isInstance }, context) {
      const validate = validateTodoTemplate(template);
      if (!validate.success) {
        return validate;
      }

      if (isInstance) {
        return await context.updateTodoInstance(template);
      } else {
        return await context.updateTodoTemplate(todoTemplateId, template);
      }
    },
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
  ...CustomTypes
};
