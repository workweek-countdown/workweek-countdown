const path = require('path')
const webpack = require('webpack')

isProduction = process.env.NODE_ENV == 'production'

const entry = ['./src/index.js']
if (!isProduction) {
  entry.unshift('webpack-dev-server/client?http://localhost:8080', 'webpack/hot/dev-server')
}

const plugins = []
if (!isProduction) {
  plugins.push(new webpack.HotModuleReplacementPlugin())
}

module.exports = {
  entry,
  output: {
    path: path.join(__dirname, 'dist'),
    filename: '[name].js'
  },
  resolve: {
    extensions: ['', '.js', '.elm']
  },
  module: {
    noParse: /\.elm$/,
    loaders: [
      {
        test: /\.sass$/,
        loaders: ['style', 'css', 'sass']
      },
      {
        test: /\.elm$/,
        exclude: ['elm-stuff', 'node_modules'],
        loaders: ['elm-webpack']
      }
    ]
  },
  plugins
}
