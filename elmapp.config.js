const proxy = require('http-proxy-middleware');

module.exports = {
  setupProxy: function(app) {
    app.use(proxy('/yri/*', { target: 'http://localhost:9933/' }));
  }
};
