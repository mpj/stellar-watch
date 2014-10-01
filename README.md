stellar-watch
=============

A service that can do queries on Stellar that updates in real time, that are not offered by the Stellar API. It works by subscribing to a stellard and updating an internal mongo database with the transactions. The initial version of stellar-watch is only interested in recent transactions and keeps a rolling log. API consumers can set up mongo queries that are re-run (throttled) when new transactions come in and the result of the transaction is pushed out as a subscription if the result differed from the last time it was sent out. 
