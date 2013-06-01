async-druby
===========

make writing druby client as callback style

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
