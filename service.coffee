_ = require 'highland'
isObject = require 'mout/lang/isObject'

service = (bus) ->
  _(bus('transaction-new'))
    .filter( (event) -> event.engine_result_code is 0 )
    .filter( (event) -> event.validated )
    .pluck('transaction').compact()
    .filter((t) -> t.TransactionType is 'Payment')
    .map( (t) ->
      document:
        from: t.Account
        to: t.Destination
        amount: if isObject(t.Amount) then t.Amount else
          currency: 'STR'
          value: t.Amount
        date: t.date
    )
    .pipe bus 'mongo-save'

module.exports = service
