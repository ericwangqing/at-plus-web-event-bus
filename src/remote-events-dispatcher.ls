(require) <- define 
exports =
  dispatch: !(remote-events, event, data)->
    if @is-host-ap-event event
      remote-events.send-event-to-target-page event, data

    else if @is-server-event event
      (if remote-events.type is 'host' then @forward-to-ap else @send-server) remote-events, event, data

    else if @is-tab-event event
      remote-events.send-event-via-local-storage event, data

    else # 本地消息
      remote-events.emit-local-event event, data

 
  forward-to-ap: !(remote-events, event, data)->
    remote-events.send-event-to-target-page event, data

  send-server: !(remote-events, event, data)->
    remote-events.send-event-via-local-storage event, data

  is-host-ap-event: (event)->
    (@get-destination event) in ['host', 'ap']

  is-server-event: (event)->
    (@get-destination event) is 'server'

  is-tab-event: (event)->
    (@get-destination event) is 'tab'

  get-destination: (event)->
    event.split ":" .0 .trim!
  
  convert-local-event-to-server-event: (local-event)->
    local-event.split ":" .1 .trim!

  convert-server-event-to-local-event: (server-event)->
    'server:' + server-event
