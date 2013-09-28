(require, dispatcher) <- define ['require', 'remote-events-dispatcher']
exports =
  redirect-socket-on: !(socket, remote-events)->
    let old-on = socket.on #这里可能还要往prototype上溯
      socket.on = (event, data)->
        remote-events.send-event-via-local-storage (dispatcher.convert-server-event-to-local-event event), data
        old-on event, data
