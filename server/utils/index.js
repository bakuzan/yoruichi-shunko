const enumArrayToObject = (arr) =>
  arr
    .slice(0)
    .reduce(
      (p, c) =>
        typeof c === 'object' ? { ...p, [c.name]: c.id } : { ...p, [c]: c },
      {}
    );

const mapArrToGraphqlString = (arr) => arr.join(' ');

const castStringToBool = (val) =>
  val === 'true' ? true : val === 'false' ? false : !!val;

function isoDate(d) {
  return new Date(d).toISOString();
}

function isoDatePlusDays(date, days) {
  const d = new Date(date);
  d.setDate(d.getDate() + days);
  return isoDate(d);
}

function isoDatePlusMonths(date, months) {
  const d = new Date(date);
  const day = d.getDate();
  const nd = getLastDateOfMonth(
    new Date(d.getFullYear(), d.getMonth() + months, 1)
  );

  if (day > nd.getDate()) {
    return isoDate(nd);
  }

  nd.setDate(day);
  return isoDate(nd);
}

function isoDatePlusYears(date, years) {
  const d = new Date(date);
  d.setFullYear(d.getFullYear() + years);
  return isoDate(d);
}

function getFirstDateOfMonth(date) {
  const d = new Date(date);
  d.setDate(1);
  return d;
}

function getLastDateOfMonth(date) {
  const d = new Date(date);
  return new Date(d.getFullYear(), d.getMonth() + 1, 0);
}

module.exports = {
  enumArrayToObject,
  mapArrToGraphqlString,
  castStringToBool,
  isoDate,
  isoDatePlusDays,
  isoDatePlusMonths,
  isoDatePlusYears,
  getFirstDateOfMonth,
  getLastDateOfMonth
};
