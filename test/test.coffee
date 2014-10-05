socket = require 'ws-json-client-stream'
_ = require 'highland'
snurra = require 'snurra'
mout = require 'mout'
assert = require 'assert'

service = require '../service'

describe 'service', ->
  s = null
  envelopes = null
  oneEnvelopeMatching = (pattern) ->
    matches = (target) ->
    mout.array.find envelopes, (envelope) ->
      mout.object.deepMatches(envelope, pattern)

  bus = null
  beforeEach ->
    envelopes = []
    bus = snurra()
    _(bus.envelopes()).each (x) ->
      envelopes.push x
    service = service(bus)

  describe 'given a new transaction', ->
    beforeEach (done) ->
      bus('transaction-new').write
        "status": "closed"
        "transaction": {
          "Account": "gnkEf9U3TzF2r5UUxZi463DTEm7wA3bfBY"
          "Amount": "10000000"
          "Destination": "gE39AWRXBQBpHJnLrgwymGp5DkcpCUoVDK"
          "date": 465829980
        }
      setTimeout done, 100

    it 'write that transaction to mongo', ->
      assert oneEnvelopeMatching
        topic: 'mongo-save'
        message:
          document:
            from: 'gnkEf9U3TzF2r5UUxZi463DTEm7wA3bfBY'
            to: 'gE39AWRXBQBpHJnLrgwymGp5DkcpCUoVDK'
            amount: '10000000'
            date: 465829980


describe.skip 'given a message', ->
  stellarSocket = null
  beforeEach ->
    stellarSocket = socket 'ws://live.stellar.org:9001'
    stellarSocket.write
      "command" : "subscribe",
      "streams" :  [ "transactions" ]

  it 'done', (done) ->
    this.timeout 20000
    _(stellarSocket).each (x) ->
      console.log("message" , JSON.stringify(x, null, 2))
      console.log("")