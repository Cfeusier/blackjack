app = new App()
view = new AppView(model: app)
view.$el.appendTo 'body'
app.start()
view.render()
