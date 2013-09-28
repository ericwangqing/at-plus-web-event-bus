(require) <- define 
emit-callback = on-callback = null
socket=
  emit: !(event, data)->
    console.log "fake socket emit #{event} to server, with data: ", data
    emit-callback event, data if emit-callback

  on: !(event, data)->
    console.log "fake socket receice #{event} from server, with data: ", data
    on-callback event, data if on-callback

exports =
  set-emit-callback: !(callback)->
    emit-callback := callback

  set-on-callback: !(callback)->
    on-callback := callback

  send-fake-server-message: !(event, data)->
    socket.on event, data

  connect: ->
    socket
