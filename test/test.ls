(require) <- define 
can = it
page-mock = require 'page-mock'
io-mock = require 'socket-io-mock'

describe '测试host-ap (postMessage)消息', !->

  can '在host page和@+ page之间，使用remote-events传递事件', !->
    [host, ap] = page-mock.create-host-ap-pair!
    ap.remote-events.on 'ap:test-host-ap-event', callback = sinon.spy!
    data = message: "Testing host-ap event"
    
    host.remote-events.emit 'ap:test-host-ap-event', data
    callback.should.have.be.called-with data

describe '测试server消息传递正确', !->
  can 'ap收到master中继的server消息', !->
    [master, ap] = page-mock.create-master-ap-pair!
    ap.remote-events.on 'server:test-server-event', callback = sinon.spy!
    data = message: "Testing received server event"
    
    io-mock.send-fake-server-message 'test-server-event', data
    callback.should.have.be.called-with data

  can '正确从ap向server发送消息', !->
    [master, ap] = page-mock.create-master-ap-pair!
    io-mock.set-emit-callback callback = sinon.spy!
    data = message: "Testing sent server event"
    
    ap.remote-events.emit 'server:test-server-event', data
    callback.should.have.be.called-with 'test-server-event', data

  can 'host收到master、ap中继的server消息', !->
    [master, host] = page-mock.create-master-host-pair!
    host.remote-events.on 'server:test-server-event', callback = sinon.spy!
    data = message: "Testing received server event"
    
    io-mock.send-fake-server-message 'test-server-event', data
    callback.should.have.be.called-with data

  can '正确从host向server发送消息', !->
    [master, host] = page-mock.create-master-host-pair!
    io-mock.set-emit-callback callback = sinon.spy!
    data = message: "Testing sent server event"
    
    host.remote-events.emit 'server:test-server-event', data
    callback.should.have.be.called-with 'test-server-event', data

describe '测试tab消息传递正确', !->
  can 'recievers都能够收到sender发送的消息', !->

  can 'sender不会收到自己的消息', !->


describe '测试master/slave选举正确', !->
  can '竞争出一个master，多个slave', !->

  can '任何时候只有一个master', !->

  can '心跳正确，master如果blocked or dead了，能够自行更换', ->

describe '消息队列，压力测试', !-> # 需要移到单独的压力测试文件中。


# ---------------------- 美丽的分割线，以下辅助代码 ----------------------- #

