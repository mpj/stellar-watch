stellar-watch
=============

A service that provides aggregates of transferred currencies/issuers on the stellar network, where transactions volume is within a certain range. It provides # of transactions, total transaction amount, currency, and issuer. The service will provide this as a stream of values, and leave sorting up to the consumer. When an aggregate is updated, this will simply be sent as any other value on the steam and the consumer will have to update it in it's set. 
