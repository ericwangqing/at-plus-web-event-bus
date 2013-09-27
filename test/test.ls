(require) <-! define
can = it
remote-events = require 'remote-events'
adapters = 
  web-messaging-adapter: require 'web-messaging-adapter'
  local-storage-messaging-adapter: require 'local-storage-messaging-adapter'
  socket-adapter: require 'socket-adapter'

describe '测试事件分发', !->
  can '正确发送host-ap事件', !->

describe '测试postMessage消息', !->

  can '在host page和@+ page之间，使用remote-events传递事件', !->
    [host-remote, ap-remote] = create-host-ap-with-remote-events-pair!

    ap-remote.on 'ap:test-host-ap-event', callback = sinon.spy!
    data = message: "Testing"
    host-remote.emit 'ap:test-host-ap-event', data
    
    callback.should.have.be.called-with data

create-host-ap-with-remote-events-pair = ->
  host = create-page 'host'
  ap = create-page 'ap'
  create-host-ap-remote-events host, ap


create-page = (name)->
  page = {
    name: name
    post-message: (message)->
      @on-message message

    on-message: (message)->
      console.log "#{name}: ", message
  }

  
create-host-ap-remote-events = (host, ap)->
  host-remote = new remote-events adapters, {
    name: host.name
    type: 'slave-host'
    this-page: host
    target-page: ap
  }

  ap-remote = new remote-events adapters, {
    name: ap.name
    type: 'slave-ap'
    this-page: ap
    target-page: host
  }

  [host-remote, ap-remote]
