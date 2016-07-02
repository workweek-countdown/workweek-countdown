const defaultSettings = {
  mode: 'Counter',
  lang: 'en',
  firstStart: true,
  workingDays: ['mon', 'tue', 'wed', 'thu', 'fri'],
  startHour: 9,
  startMinute: 0,
  endHour: 18,
  endMinute: 0
}

module.exports = (app) => {
  app.ports.saveSettings.subscribe((settings) => {
    chrome.storage.sync.set({ settings })
  })

  app.ports.loadSettings.subscribe(() => {
    chrome.storage.sync.get('settings', ({ settings }) => {
      settings = Object.assign({}, defaultSettings, settings)
      app.ports.settings.send(settings)
    })
  })
}
