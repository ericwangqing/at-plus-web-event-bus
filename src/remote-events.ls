(require, eventemitter2) <- define ['require', '../node_modules/eventemitter2/lib/eventemitter2']
is-host-ap-event = (event)->
  (get-destination event) in ['host', 'ap']

is-server-message = (event)->
  # TODO
  false

is-tab-message = (event)->
  # TODO
  false

get-destination = (event)->
  event.split ":" .0 .trim!

class Remote-events
  (adapters, config)->
    @name = 'remote-events of ' + config.this-page.name
    @type = config.type # master | slave-ap | slave-host
    @this-page = config.this-page
    @target-page = config.target-page
    @local-storage-messenger = config.local-storage-messenger
    @bus = new eventemitter2 {
      wildcard: true
      delimiter: '::'
      new-listener: false
      max-listeners: 20
    }
    adapters.web-messaging-adapter.redirect-on-message-to-bus-emit @this-page, @bus


  on: !(event, handler)->
    @bus.on event, handler

  emit: !(event, data)->
    if is-host-ap-event event
      @target-page.post-message JSON.stringify {event: event, data: data}
    else if (is-server-message event) 
      @local-storage-messenger.emit event, data
    else if (is-tab-message event)
      @local-storage-messenger.emit event, data
    else # 本地消息
      @bus.emit event, data
