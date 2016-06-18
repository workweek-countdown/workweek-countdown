module.exports = (app) => {
  app.ports.saveSettings.subscribe((settings) => {
    chrome.storage.sync.set({ settings })
  })

  app.ports.loadSettings.subscribe(() => {
    chrome.storage.sync.get('settings', ({ settings }) => {
      app.ports.settings.send(settings)
    })
  })
}
