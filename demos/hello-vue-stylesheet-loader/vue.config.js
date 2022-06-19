const util = require('util');

module.exports = {
  chainWebpack: config => {
    config.mode('development');
    config.optimization.delete('splitChunks');
    config.entry('app').prepend('./src/polyfill.js') 
  },
  filenameHashing: false,
  productionSourceMap: false,
  configureWebpack(config){
    config.devtool= config.mode === "production" ? false : "source-map";

    // Inject stylesheet-loader into Vue-cli webpack config.
    let cssRules = config.module.rules.find((rule) => rule.test.toString() === '/\\.css$/');
    // Stylesheet-loader should at top of oneOf rules.
    cssRules.oneOf.unshift({
      test: /\.inline\.css$/,
      use: [
        {
          loader: require.resolve('stylesheet-loader')
        }
      ]
    });
    
  },
  devServer: {
    disableHostCheck: true,
      compress: true,
      // Use 'ws' instead of 'sockjs-node' on server since webpackHotDevClient is using native websocket
      transportMode: 'ws',
      logLevel: 'silent',
      clientLogLevel: 'none',
      hot: true,
      publicPath: '/',
      quiet: false,
      watchOptions: {
        ignored: /node_modules/,
        aggregateTimeout: 100,
      },
      before(app) {
        app.use((req, res, next) => {
          // set cros for all served files
          res.set('Access-Control-Allow-Origin', '*');
          next();
        });
      },

  }
}
