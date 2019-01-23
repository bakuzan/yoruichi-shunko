module.exports = {
  date(template) {
    return new Date(template.date).getTime();
  },
  dateStr(template) {
    return new Date(template.date).toISOString();
  },
  instances(template) {
    if (template.todoInstances) {
      return template.todoInstances;
    }

    return template.getTodoInstances().then((instances) => instances || []);
  }
};
