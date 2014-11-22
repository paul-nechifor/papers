{decode} = require 'markov-pack'

main = ->
  getBinary window.staticPath + '/papers.makpak', (err, binary) ->
    return alert err if err
    console.log binary

getBinary = (path, cb) ->
  req = new XMLHttpRequest
  req.open 'GET', path, true
  req.responseType = 'arraybuffer'
  req.onload = (oEvent) ->
    arrayBuffer = req.response
    return cb 'no-response' unless req.response
    return cb null, new Uint8Array req.response
  req.send null

class Page
  constructor: (@binary) ->

  setup: ->

main()
