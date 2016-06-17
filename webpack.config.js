const path = require('path')
const webpack = require('webpack')

const isProduction = process.env.NODE_ENV == 'production'

module.exports = {
  entry: ['./src/index.js'],
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
  }
}
