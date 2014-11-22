{decode} = require 'markov-pack'

main = ->
  new Page().setup()

getBinary = (path, onProgress, cb) ->
  req = new XMLHttpRequest
  req.open 'GET', path, true
  req.responseType = 'arraybuffer'
  req.onload = (oEvent) ->
    arrayBuffer = req.response
    return cb 'no-response' unless req.response
    return cb null, new Uint8Array req.response
  req.addEventListener 'progress', (ev) ->
    return unless ev.lengthComputable
    onProgress ev.loaded / ev.total
  , false
  req.send null

class Page
  constructor: ->
    @loadBtn = $ '#load'
    @progressBar = $ '#progress .progress-bar'
    @titles = $ '#titles'
    @generateBtn = $ '#generate'
    @decoder = null

  setup: ->
    @loadBtn.click @onLoad.bind @
    @generateBtn.click @onGenerate.bind @

  onLoad: ->
    @loadBtn.remove()
    path = window.staticPath + '/papers.makpak'
    getBinary path, @onProgress.bind(@), @onComplete.bind @

  onProgress: (ratio) ->
    @progressBar.css 'width', (ratio * 100) + '%'

  onComplete: (err, binary) ->
    return alert err if err
    @decoder = new decode.Decoder binary
    @decoder.decode()
    @progressBar.parent().remove()
    $('#controls').show()
    @onGenerate()

  onGenerate: ->
    @titles.empty()

    for i in [1 .. 20] by 1
      sentence = @decoder.joinSequence @decoder.getSequence()
      $('<p>').appendTo(@titles).text sentence
    return

main()
