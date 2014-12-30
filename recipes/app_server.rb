#
# Cookbook Name:: tcp-tuning
# Recipe:: app_server
#
# Copyright (C) 2014 Wanelo, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

# TIME_WAITS CRYYYYYY: http://lists.illumos.org/pipermail/developer/2011-April/001958.html
# tl;dr many connections between two machines quickly cause every possible port to be in
# TIME_WAIT status. If the TCP sequence counter (a 32-bit counter) wraps around, the next
# attempted connection will be interpreted as part of the previous connection, get an RST
# response, and have to try again after tcp_rexmit_interval_initial + min. To mitigate we:

# 1) Reduce smallest_anon_port for more ephemeral ports, which reduces collisions
# 2) Reduce time_wait_interval so less connections are in TIME_WAIT
# 3) Change strong_iss to 0 so that sequence numbers increment by only a fixed amount
# 4) Change iss_incr to 25000 as per the linked ML post to reduce wrap-around
# 5) Reduce rexmit_interval_initial, min, and max so that collisions take less time
# 6) Reduce ip_abort_interval to 4x the rexmit_interval_initial, as recommended

tcp_tuning 'app-server' do
  settings 'smallest_anon_port' => 8192,
           'time_wait_interval' => 5000,
           'strong_iss' => 0,
           'iss_incr' => 25_000,
           'rexmit_interval_initial' => 150,
           'rexmit_interval_min' => 25,
           'rexmit_interval_max' => 15_000,
           'ip_abort_interval' => 60_000
end
