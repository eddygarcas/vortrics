App.retrospective = App.cable.subscriptions.create "RetrospectiveChannel",
  connected: ->

  disconnected: ->

  received: (data) ->
    console.log(data)
    if data.commit
      window.store.commit(data.commit,JSON.parse(data.payload))
