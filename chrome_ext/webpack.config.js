const path = require('path');

module.exports = {
  entry:  {
    popup: './src/js/popup.js',
    cookie_sync: './src/js/cookie_sync',
    background: './src/js/background.js'
  },

  output: {
    path: path.resolve(__dirname, 'src', 'dist'),
    filename: '[name].js'
  }
};
