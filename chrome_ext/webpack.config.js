const path = require('path');
const webpack = require("webpack");

module.exports = {
  entry:  {
    popup: './src/js/popup.js',
    cookie_sync: './src/js/cookie_sync',
    background: './src/js/background.js'
  },

  optimization: {
    minimize: false
  },

  plugins: [
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery"
    })
  ],

  output: {
    path: path.resolve(__dirname, 'src', 'dist'),
    filename: '[name].js'
  }
};
