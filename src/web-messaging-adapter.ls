(require) <- define ['require']
name: 'web-messaging-adapter'

redirect-on-message-to-bus-emit: !(page, bus)->
  let old-on-message = page.on-message #这里可能还要往prototype上溯
    page.on-message = ->
      message = arguments[0]
      {event, data} = JSON.parse message
      bus.emit event, data
      old-on-message.apply page, arguments
