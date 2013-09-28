(require, dispatcher) <- define ['require', 'remote-events-dispatcher']
redirect-storage-message-to-bus-emit = !(page, remote-events)->
  page.add-event-listener 'storage', (event)->
    event-name = event.key
    {sender-id, data} = JSON.parse event.new-value
    redirect-event remote-events, event-name, data unless sender-id is remote-events.id 

redirect-event = !(remote-events, event, data)->
  if is-master-and-server-event remote-events, event
    remote-events.send-event-to-server event, data
  else
    remote-events.emit-local-event event, data

is-master-and-server-event = (remote-events, event)->
  remote-events.type is 'master' and (dispatcher.get-destination event) is 'server'

class Local-storage-messenger
  (@local-storage)->
  emit: (event, data)-> 
    if (dispatcher.is-server-event event) or (dispatcher.is-tab-event event)
      @local-storage.set-item event, JSON.stringify data
    else
      throw new Error "#{event} is neither a tab event nor a server event " 


exports =
  create-messenger-and-redirect-on-message: (page, remote-events)->
    redirect-storage-message-to-bus-emit page, remote-events
    new Local-storage-messenger page.local-storage