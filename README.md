async-druby
===========

make writing druby client as callback style

- require 'async-druby' makes also requiring drb automatically
- any methods of your DRbObject can be called with prefix 'async_' (says assync_ed method).
- async_ed method takes a block that block-variable is the result of the invokcation of druby server.
- restriction: any methods that originally takes block does not accept async_ed method.

sample code

```
require 'async-druby'

# The URI to connect to
SERVER_URI="druby://localhost:8787"

timeserver = DRbObject.new_with_uri(SERVER_URI)

current = timeserver.get_current_time # synchronous call as usual

timeserver.async_get_current_time do |current| # async callback style
  puts ccurrent # => async-druby will call back this block
end
sleep # you may continue to run client for doing another work
```
