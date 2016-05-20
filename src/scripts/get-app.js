const { Weekend } = require('./Weekend.elm')

let app = null

module.exports = () => {
  if (app) return app
  const root = document.querySelector('#root')
  app = Weekend.embed(root)
  return app
}
