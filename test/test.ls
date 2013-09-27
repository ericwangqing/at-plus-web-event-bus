(require) <-! define
can = it
event-bus = require 'event-bus'


describe '测试postMessage消息', !->

  can '正确识别完整类型消息：host-ap/test-host-ap-event', !(done)->
    host = create-page 'host'
    ap = create-page 'ap'
    [host-bus, ap-bus] = create-host-ap-buses host, ap

    ap-bus.on 'host-ap/test-host-ap-event', callback = sinon.spy!
    data = message: "Testing"
    host-bus.emit 'host-ap/test-host-ap-event', data
    
    callback.should.have.be.called-with data
    done!

create-page = (name)->
  page = {
    name: name
    post-message: (message)->
      @on-message message

    on-message: (message)->
      console.log "#{name}: ", message
  }

  
create-host-ap-buses = (host, ap)->
  host-bus = new event-bus {
    this-page: host
    target-page: ap
  }

  ap-bus = new event-bus {
    this-page: ap
    target-page: host
  }

  [host-bus, ap-bus]
