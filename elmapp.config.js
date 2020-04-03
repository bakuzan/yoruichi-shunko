const { createProxyMiddleware } = require('http-proxy-middleware');

module.exports = {
  setupProxy: function(app) {
    app.use(
      '/graphql',
      createProxyMiddleware({
        target: 'http://localhost:9003/',
        changeOrigin: true
      })
    );
  }
};
