const { isoDate, isoDatePlusDays } = require('../utils');

const templates = [
  {
    name: 'go to mk',
    date: isoDate('2019-01-23'),
    repeatPattern: 'None',
    repeatFor: 0,
    repeatWeekDefinition: 1
  },
  {
    name: 'perform repeated task',
    date: isoDate('2019-01-23'),
    repeatPattern: 'Daily',
    repeatFor: 14,
    repeatWeekDefinition: 1
  },
  {
    name: 'watch tv show',
    date: isoDate('2019-01-21'),
    repeatPattern: 'Weekly',
    repeatFor: 12,
    repeatWeekDefinition: 1
  },
  {
    name: 'shave',
    date: isoDate('2018-12-30'),
    repeatPattern: 'Quarterly',
    repeatFor: 8,
    repeatWeekDefinition: 1
  }
];
const instances = [
  {
    name: 'go to mk',
    date: isoDate('2019-01-23'),
    todoTemplateId: 1
  },
  ...Array(14)
    .fill(null)
    .map((_, i) => {
      return {
        name: 'perform repeated task',
        date: isoDatePlusDays('2019-01-23', i),
        todoTemplateId: 2
      };
    }),
  ...Array(12)
    .fill(null)
    .map((_, i) => {
      return {
        name: 'watch tv show',
        date: isoDatePlusDays('2019-01-21', i * 7),
        todoTemplateId: 3
      };
    }),
  ...Array(8)
    .fill(null)
    .map((_, i) => {
      return {
        name: 'shave',
        date: isoDatePlusDays('2018-12-30', i * 7 * 13),
        todoTemplateId: 4
      };
    })
];

module.exports = {
  templates,
  instances
};
