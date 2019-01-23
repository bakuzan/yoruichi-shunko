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

module.exports = {
  enumArrayToObject,
  mapArrToGraphqlString,
  castStringToBool
};
