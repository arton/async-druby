#
# = async-druby.rb
#
# dRuby async style client addoon
#
# Copyright(c) 2013 arton.  You can redistribute it and/or
# modify it under the same terms as Ruby.
#
# Author: arton
#
# == Overview
# 
# async-druby is monkey patch for dRuby.
# it adds methods named with async_ prefix for each DRbObject.
# 
# ==== clinet code
#  
#  require 'async-druby'
#
#   # The URI to connect to
#   SERVER_URI="druby://localhost:8787"
#
#   timeserver = DRbObject.new_with_uri(SERVER_URI)
#
#   current = timeserver.get_current_time    # synchronous call as usual
#
#   timeserver.async_get_current_time do |current|  # async callback style
#     puts ccurrent  # => async-druby will call back this block
#   end
#   sleep # you may continue to run client for doing another work
#
# === restrictions
#
#   You don't call server method that takes block parameter.
#
require 'drb/drb'

module DRb

  class DRbObject
    alias _method_missing method_missing
    def method_missing(msg_id, *a, &b)
      if msg_id.to_s.index('async_') == 0 && b
        drb = Thread.current['DRb']
        Thread.start do
          Thread.current['DRb'] = drb
          ret = _method_missing(msg_id[6..-1].to_sym, *a)
          b.call(ret)
        end
      else
        _method_missing(msg_id, *a, &b)
      end
    end
  end
end
