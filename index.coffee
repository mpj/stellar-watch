_ = require 'highland'
express = require 'express'
app = express()
snurra = require 'snurra'
service = require './service'
mongoWriteStream = require 'mongo-write-stream'
socket = require 'ws-json-client-stream'

app.get '/hello.txt', (req, res) ->
  res.send 'Hello world!'

server = app.listen 3000, ->
  bus = snurra()
  s = service bus

  collection = mongoWriteStream "mongodb://stellartest:stellartest123@flame.mongohq.com:27036/mpj_test"

  _(bus('mongo-save'))
    .map(_.get 'document')
    .pipe collection 'stellar-watch-test'

  stellarSocket = socket 'ws://live.stellar.org:9001'
  _(stellarSocket)
    .filter (event) ->
      event.transaction and event.transaction.TransactionType isnt 'Payment'
    .through(bus('log-stellar'))
    .pipe(bus('transaction-new'))

  stellarSocket.write
    "command" : "subscribe",
    "streams" :  [ "transactions" ]

  _(bus.envelopes()).each (e) ->
    console.log("")
    console.log("Envelope", e)

  console.log 'Listening on port %d', server.address().port
