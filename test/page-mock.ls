(require) <- define 
remote-events = require 'remote-events'
io = require 'socket-io-mock'
eventemitter2 = require '../node_modules/eventemitter2/lib/eventemitter2'

fake-local-storage = {} # 模拟浏览器的local storage
fake-even-bus = new eventemitter2! # 用于模拟浏览器的storage事件

create-pair-pages =  (a, b) ->
  page-a = create-mock-web-page a
  page-b = create-mock-web-page b
  add-remote-events-pair page-a, page-b

get-type-by-name = (name)->
  name

create-mock-web-page = (name)->
  mock-web-page = title: name
  mock-web-messaging-api.call mock-web-page
  mock-web-storage-api.call mock-web-page

mock-web-storage-api = ->
  @add-event-listener = !(event, listener)->
    fake-even-bus.on event, listener

  @local-storage =
    set-item: !(key, value)->
      old-value = fake-local-storage[key]
      new-value = fake-local-storage[key] = value
      fake-even-bus.emit 'storage', 
        key: key
        old-value: old-value
        new-value: new-value
        url: @name

    get-item: (key)->
      fake-local-storage[key]

  @

mock-web-messaging-api = ->
  @post-message = (message)->
    @on-message message

  @on-message = (message)->
    console.log "#{name}: ", message

  @

  
add-remote-events-pair = (page-a, page-b)->
  add-remote-events page-a, page-b
  add-remote-events page-b, page-a
  [page-a, page-b]
  

add-remote-events = (this-page, target-page)->
  this-page.remote-events = new remote-events {
    name: this-page.name
    type: type = get-type-by-name this-page.title
    this-page: this-page
    target-page: target-page
    socket: if type is 'master' then io.connect! else null
  }


exports = 
  create-host-ap-pair: ->
    create-pair-pages('host', 'ap')

  create-master-ap-pair: ->
    create-pair-pages('master', 'ap')

  create-master-host-pair: ->
    [host, ap1] = create-pair-pages 'host', 'ap' 
    [master, ap2] = create-pair-pages 'master', 'ap' 
    [master, host]

  get-fake-event-bus: ->
    fake-even-bus


