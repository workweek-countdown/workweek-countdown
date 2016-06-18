require('./styles/index.sass')
const getApp = require('./scripts/get-app')
const addPorts = require('./scripts/add-ports')

const app = getApp()
addPorts(app)
