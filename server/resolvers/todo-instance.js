const { RepeatPatterns } = require('../constants/enums');

module.exports = {
  isRepeated(instance) {
    if (instance.todoTemplate) {
      return instance.todoTemplate.repeatPattern !== RepeatPatterns.None;
    }

    return instance
      .getTodoTemplate()
      .then((template) => template.repeatPattern !== RepeatPatterns.None);
  },
  template(instance) {
    if (instance.todoTemplate) {
      return instance.todoTemplate;
    }

    return instance.getTodoTemplate().then((template) => template);
  }
};
