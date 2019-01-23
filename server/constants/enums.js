const enumArrayToObject = require('../utils').enumArrayToObject;

const RepeatPattern = Object.freeze([
  'None',
  'Daily',
  'Weekly',
  'Monthly',
  'Quarterly',
  'Yearly'
]);

const CalendarMode = Object.freeze(['Day', 'Week', 'Month']);

module.exports = {
  RepeatPattern,
  RepeatPatterns: enumArrayToObject(RepeatPattern),
  CalendarMode,
  CalendarModes: enumArrayToObject(CalendarMode)
};
