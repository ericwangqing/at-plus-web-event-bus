(require, dispatcher) <- define ['require', 'remote-events-dispatcher']

exports =
  redirect-on-message: !(page, remote-events)->
    let old-on-message = page.on-message #这里可能还要往prototype上溯
      page.on-message = ->
        message = arguments[0]
        {event, data} = JSON.parse message
        if dispatcher.is-server event
          remote-events.send-event-via-local-storage event, data # 转发host去server消息
        else if dispatcher.is-from-server event
          remote-events.emit-local-event (dispatcher.convert-from-server-event-to-local-event event), data
        else  
          remote-events.emit-local-event event, data
        old-on-message.apply page, arguments
