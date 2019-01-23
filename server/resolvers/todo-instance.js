module.exports = {
  date(instance) {
    return new Date(instance.date).getTime();
  },
  dateStr(instance) {
    return new Date(instance.date).toISOString();
  },
  template(instance) {
    if (instance.todoTemplate) {
      return instance.todoTemplate;
    }

    return instance.getTodoTemplate().then((template) => template);
  }
};
