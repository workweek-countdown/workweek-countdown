require('./styles/weekend.sass')

const { Weekend } = require('./scripts/weekend.elm')

const root = document.querySelector('#root')
Weekend.embed(root)
