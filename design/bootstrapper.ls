# bootstrapper.ls (bootstrapper @+ 初始化算法)。
# 该脚本需要require.js支持。将同时存在于@+ page和host page
define ['remote-events', 'state-manager', 'interesting-points-manager','chats-manager'], 
  (remote-events, state-manager, interesting-points-manager, chats-manager)->
    boot: !(callback)->
      create-at-plus-page if is-in-host
      # 建立好host page与@+ page，与其它tab，以及与server的通讯管道.
      # 为何异步？remote-events和state-manager都会涉及到IO，目前虽然用的都是localStorage，但今后可能变化。
      remote-events.initial !(callback)-> 
        state-manager.initial !(callback)-> 
          interesting-points-manager.initial！
          chats-manager.initial!
          callback!


# 在host page上 /App/at-plus.js
define !(require)->
  bootstrapper = require 'bootstrapper'
  remote-events = require 'remote-events'
  ipm = require 'interesting-points-manager'
  bootstrapper.boot !->
    remote-events.emit 'ap:host-page-booted'
    remote-events.on 'server:at-plus-initial-data', !(data)->
      ipm.insert-exposed-interesting-points data.interesting-points


# 在@+ page上 /App/main.js
define !(require)->
  bootstrapper = require 'bootstrapper'
  remote-events = require 'remote-events'

  waiter = new All-done-waiter done = !->
    app.start!.then ->
      # ************** 进入 durandal 操作 ************** #

  wait = waiter.add-waiting-function

  bootstrapper.boot wait !->
    remote-events.on 'ap:host-page-booted', wait!
    remote-events.emit 'host:at-plus-page-booted'


# 在host，或者@+ page其它模块中使用基础设施模块：/App/Widgets/mask.ls
define ['remote-events', 'durandal/app'], (eb)->
  class Mask
    constructor: ->
      remote-events.on 'server:location-updated', @update-location
      ...
    update-location: !(data)->
      ...
      @trigger 'location-updated' # widget事件，不受remote-events管理，durandal管理
  


# interesting-points-manager.ls
define ['remote-events', 'state-manager', 'Interesting-point-position-calculator'], (remote-events, state-manager, ippc)->

# interesting-point-position-calculator.ls
define ['remote-events', 'state-manager'], (remote-events, state-manager)->

# chats-manager.ls
define ['remote-events', 'state-manager'], (remote-events, state-manager)->

