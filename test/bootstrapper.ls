AT_PLUS_HOST = 'at-plus.cn'
AT_PLUS_BASE = 'http://' + AT_PLUS_HOST
page-type = remote-events = remote-events-master = null

if location.host is not AT_PLUS_HOST
  iframe = document.create 'iframe'
  at-plus-page = iframe.content-window
  iframe.src = AT_PLUS_BASE + '/' + encode location.href
  document.body.append-child iframe
else
  remote-events = require 'remote-events'

if is-on-host!
  page-type = 'host'
  target-page = at-plus-page = create-at-plus-page
  host-page = window
else # on at-plus page (ap)
  page-type = 'ap'
  at-plus-page = window
  target-page = host-page = window.parent

remote-events = new remote-events {
  name: document.title
  type: page-type
  this-page: window
  target-page: target-page
  # socket: if type is 'master' then io.connect! else null
}

if is-on-host!
  other-host-initial-works!
  remote-events.on 'ap:ap-page-booted', !(data)->
    do-host-page-business!

  remote-events.emit 'host:host-page-booted'

else # on ap
  (is-success) <-! compete-master window.local-storage
  if is-sucess
    (socket) <-! io.connect
    remote-events-master = new remote-events {
      name: '@+ master in: ' + document.title
      type: 'master'
      this-page: window
      target-page: target-page
      socket: socket
    }
    remote-events-master.heart-beat! # TODO: heart-beat超时，他人compete master， 当前master to die
    other-ap-initial-works!
    remote-events.on 'host:host-page-booted', !(data)->
      do-ap-page-business!
    remote-events.emit 'ap:ap-page-booted'
  else
    other-ap-initial-works!
    remote-events.on 'host:host-page-booted', !(data)->
      do-ap-page-business!
    remote-events.emit 'ap:ap-page-booted'



