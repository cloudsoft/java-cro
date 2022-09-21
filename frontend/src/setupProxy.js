const proxy = require("http-proxy-middleware");

module.exports = function(app) {
    app.use( proxy('/catalogue', {
                target: process.env.REACT_APP_BACKEND_URL || 'http://localhost:8082',
                changeOrigin: true,
            }
    ));
};