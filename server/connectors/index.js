const chalk = require('chalk');
const Sequelize = require('sequelize');

const Constants = require('../constants/index');
const Utils = require('../utils');
const migrate = require('../config');
const TestData = require('../config/testData');

const db = new Sequelize(Constants.appName, null, null, {
  dialect: 'sqlite',
  storage: `${process.env.DB_STORAGE_PATH}${Constants.appName}.${
    process.env.NODE_ENV
  }.sqlite`,
  operatorsAliases: false
});

const TodoTemplateModel = db.import('./todo-template');
const TodoInstanceModel = db.import('./todo-instance');

TodoTemplateModel.TodoInstance = TodoTemplateModel.hasMany(TodoInstanceModel, {
  onDelete: 'cascade'
});
TodoInstanceModel.TodoTemplate = TodoInstanceModel.belongsTo(TodoTemplateModel);

// Sync and Migrate db
// Only add test data if sync is forced
// Populate rankings
const FORCE_DB_REBUILD = Utils.castStringToBool(process.env.FORCE_DB_REBUILD);
const SEED_DB = Utils.castStringToBool(process.env.SEED_DB);

db.sync({ force: FORCE_DB_REBUILD })
  .then(() => migrate(db))
  .then(async () => {
    if (FORCE_DB_REBUILD && SEED_DB) {
      const { todoTemplate, todoInstance } = db.models;
      await todoTemplate.bulkCreate(TestData.templates);
      await todoInstance.bulkCreate(TestData.instances);
      console.log(chalk.greenBright('Seed Data Populated.'));
    }
  });

const { todoTemplate: TodoTemplate, todoInstance: TodoInstance } = db.models;

module.exports = {
  db,
  TodoTemplate,
  TodoInstance
};
