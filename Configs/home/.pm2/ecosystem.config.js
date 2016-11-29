module.exports = {
  /**
   * Application configuration section
   * http://pm2.keymetrics.io/docs/usage/application-declaration/
   *
   * pm2 start ecosystem.config.js --env production
   */
  apps : [
    {
      name      : "WebApplication-Server",
      script    : "/opt/WebApplication-Server/server.js",
      watch     : true,
      env: {
        COMMON_VARIABLE: "true"
      },
      env_production : {
        NODE_ENV: "production"
      }
    },
  ],
}
