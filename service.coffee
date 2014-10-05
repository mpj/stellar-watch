_ = require 'highland'

service = (bus) ->
  x = _(bus('transaction-new'))

  x.map(_.get('transaction'))
    .map((t) ->
      document: {
        from: t.Account
        to: t.Destination
        amount: t.Amount
        date: t.date
      }
  ).pipe(bus('mongo-save'))

module.exports = service
