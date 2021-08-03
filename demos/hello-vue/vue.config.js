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
