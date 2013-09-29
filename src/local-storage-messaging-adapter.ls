(require, dispatcher, config) <- define ['require', 'remote-events-dispatcher', 'config']
redirect-storage-message-to-bus-emit = !(page, remote-events)->
  page.add-event-listener 'storage', (event)->
    if is-a-event-via-local-storage event
      event-name = get-event-name event
      {sender-id, data} = JSON.parse event.new-value
      redirect-event remote-events, event-name, data unless sender-id is remote-events.id 

is-a-event-via-local-storage = (event)->
  (event.key.index-of config.local-stroage-message-prefix) is 0

get-event-name = (event)->
  event.key.substring config.local-stroage-message-prefix.length, event.key.length

redirect-event = !(remote-events, event, data)->
  if is-master-and-server-event remote-events, event
    remote-events.send-event-to-server event, data
  else 
    if dispatcher.is-from-server event # 转发给host，这里今后可以进一步改进，或许不需要所有都转发
      remote-events.send-event-to-target-page event, data  
      event = dispatcher.convert-from-server-event-to-local-event event
    remote-events.emit-local-event event, data

is-master-and-server-event = (remote-events, event)->
  remote-events.type is 'master' and (dispatcher.is-server event)

class Local-storage-messenger
  (@local-storage)->
  emit: (event, data)-> 
    if (dispatcher.is-server event) or (dispatcher.is-tab event) or (dispatcher.is-from-server event)
      @local-storage.set-item config.local-stroage-message-prefix + event, JSON.stringify data
    else
      throw new Error "#{event} is neither a tab event nor a from/server event " 


exports =
  create-messenger-and-redirect-on-message: (page, remote-events)->
    redirect-storage-message-to-bus-emit page, remote-events
    new Local-storage-messenger page.local-storage