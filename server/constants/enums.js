const enumArrayToObject = require("../utils").enumArrayToObject;

const RepeatPattern = Object.freeze([
  "None",
  "Daily",
  "Weekly",
  "Monthly",
  "Quarterly",
  "Yearly"
]);

module.exports = {
  RepeatPattern,
  RepeatPatterns: enumArrayToObject(RepeatPattern)
};
