const { CalendarModes } = require('../constants/enums');

function setTime(date, h, m, s, n) {
  const d = new Date(date);
  d.setHours(h, m, s, n);
  return d;
}

function startOfDay(d) {
  return setTime(d, 0, 0, 0, 0);
}

function endOfDay(d) {
  return setTime(d, 23, 59, 59, 999);
}

// Week Helpers
function getWeekExtreme(check, setTime) {
  return (date) => {
    const d = new Date(date);
    const day = d.getDay();
    const diff = d.getDate() - day + check(day);
    d.setDate(diff);
    return setTime(d);
  };
}

const weekBeginning = getWeekExtreme((d) => (d === 0 ? -6 : 1), startOfDay);
const weekEnding = getWeekExtreme((d) => (d === 0 ? 0 : 7), endOfDay);

// Month Helpers

function getFirstDateOfMonth(date) {
  const d = new Date(date);
  d.setDate(1);
  return d;
}

function getLastDateOfMonth(date) {
  const d = new Date(date);
  return new Date(d.getFullYear(), d.getMonth() + 1, 0);
}

module.exports = (mode, date) => {
  switch (mode) {
    case CalendarModes.Day:
      return [startOfDay(date), endOfDay(date)];

    case CalendarModes.Week:
      return [weekBeginning(date), weekEnding(date)];

    case CalendarModes.Month:
      return [getFirstDateOfMonth(date), getLastDateOfMonth(date)];
  }
};
