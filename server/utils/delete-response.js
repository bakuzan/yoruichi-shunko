module.exports = (id, deletedCount) => {
  if (deletedCount > 0) {
    return { success: true, errorMessages: [] };
  } else if (deletedCount === 0) {
    return {
      success: false,
      errorMessages: [`Nothing matching Id: ${id} was found.`]
    };
  } else {
    return {
      success: false,
      errorMessages: [
        'Something went wrong and the action could not be performed.'
      ]
    };
  }
};
