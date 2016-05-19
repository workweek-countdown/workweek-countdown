const webpack = require('webpack')
const WebpackDevServer = require('webpack-dev-server')
const config = require('./webpack.config')

const compiler = webpack(config)

const server = new WebpackDevServer(compiler, {
  hot: true,
  inline: true,
  contentBase: "dist"
})

server.listen(8080, 'localhost', () => {})
