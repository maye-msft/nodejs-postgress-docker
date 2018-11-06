module.exports = {
  apps : [{
    name: 'myapp',
    script: 'index.js',

    // Options reference: https://pm2.io/doc/en/runtime/reference/ecosystem-file/
    args: 'one two',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'development',
      DATABASE_URL: ''
    },
    env_production: {
      NODE_ENV: 'production',
      DATABASE_URL: '_DATABASE_URL_'
    }
  }],

  
};
