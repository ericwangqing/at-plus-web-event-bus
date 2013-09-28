(require, dispatcher, eventemitter2, web-messaging-adapter, local-storage-messaging-adapter, socket-adapter) <- \
define ['require', 'remote-events-dispatcher', '../node_modules/eventemitter2/lib/eventemitter2'
  'web-messaging-adapter', 'local-storage-messaging-adapter', 'socket-adapter'
]

convert-communications = ->
  # 详细设计见：http://my.ss.sysu.edu.cn/wiki/pages/viewpage.action?pageId=223215619
  if @type is not 'host' # host很多不是HTML5，不能使用localStorage
    @local-storage-messenger = local-storage-messaging-adapter.create-messenger-and-redirect-on-message @this-page, @
  if @type is 'master' # master和server通讯，但是不和host通讯，不用postMessage
    socket-adapter.redirect-socket-on @socket, @ 
  else # host和ap通过postMessage通讯
    web-messaging-adapter.redirect-on-message @this-page, @
  @

exports =
  class Remote-events
    (config)->
      @id = '' + new Date! + Math.random! 
      @name = 'remote-events of ' + config.this-page.name
      @type = config.type # master | ap | host , ap和host都是slave
      @this-page = config.this-page
      @target-page = config.target-page # 如果将来会有多个page之间通过post-message通讯，这里改为数组
      @socket = config.socket if config.type is 'master'
      @bus = new eventemitter2!
      convert-communications.call @

    on: !(event, handler)->
      @bus.on event, handler

    emit: !(event, data)->
      dispatcher.dispatch @, event, data

    send-event-via-local-storage: !(event, data)->
      @local-storage-messenger.emit event, {sender-id: @id, data: data} #

    send-event-to-target-page: !(event, data)->
      @target-page.post-message JSON.stringify {event: event, data: data}

    send-event-to-server: !(event, data)->
      throw new Error "only master can send event to server" if @type is not 'master'
      @socket.emit (dispatcher.convert-local-event-to-server-event event), data

    emit-local-event: !(event, data)->
      @.bus.emit event, data

