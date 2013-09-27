(require, web-messaging-adapter, eventemitter2) <- define ['require', 'web-messaging-adapter', '../node_modules/eventemitter2/lib/eventemitter2']
is-host-ap-event = (event)->
  # TODO
  true

is-server-message = (event)->
  # TODO
  false

class Event-bus
  (config)->
    @name = config.this-page.name
    @this-page = config.this-page
    @target-page = config.target-page
    @bus = new eventemitter2 {
      wildcard: true
      delimiter: '::'
      new-listener: false
      max-listeners: 20
    }
    web-messaging-adapter.redirect-on-message-to-bus-emit @this-page, @bus


  on: !(event, handler)->
    @bus.on event, handler

  emit: !(event, data)->
    if is-host-ap-event event
      @target-page.post-message JSON.stringify {event: event, data: data}
    else if (is-server-message event) 
      local-storage-messenger.emit event, data
    else if (is-tab-sync-message event)
      local-storage-messenger.emit event, data
    else # 本地消息
      @bus.emit event, data
