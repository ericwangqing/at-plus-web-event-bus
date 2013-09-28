(require) <- define 
exports =
  dispatch: !(remote-events, event, data)->
    if @is-host-ap event
      remote-events.send-event-to-target-page event, data

    else if @is-server event
      (if remote-events.type is 'host' then @forward-to-ap else @send-server) remote-events, event, data

    else if @is-tab event
      remote-events.send-event-via-local-storage event, data

    else # 本地消息
      remote-events.emit-local-event event, data

 
  forward-to-ap: !(remote-events, event, data)->
    remote-events.send-event-to-target-page event, data

  send-server: !(remote-events, event, data)->
    remote-events.send-event-via-local-storage event, data

  is-host-ap: (event)->
    (@get-destination event) in ['host', 'ap']

  is-server: (event)->
    (@get-destination event) is 'server'

  is-from-server: (event)->
    (@get-destination event) is 'from-server'

  is-tab: (event)->
    (@get-destination event) is 'tab'

  get-destination: (event)->
    event.split ":" .0 .trim!
  
  convert-local-event-to-server-event: (local-event)->
    local-event.split ":" .1 .trim!

  convert-server-event-to-from-server-event: (server-event)->
    'from-server:' + server-event

  convert-from-server-event-to-local-event: (from-server-event)->
    'server:' + (from-server-event.split ":" .1 .trim!)
