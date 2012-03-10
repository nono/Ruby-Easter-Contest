Ruby Easter Contest
===================

Rules
-----

See http://contest.dimelo.com/index.html

Dependencies
------------

* Redis 2.4
* Ruby 1.9.3

Notes
-----

- No support for livetraffic_id
- ActionDispatch::RemoteIp is used to get the real IP (we use REMOTE_ADDR as a fallback)
- Servers clocks don't have to be synchronized
- Storing stats at each request is made in an efficient way, but gathering them uses `keys` and many calls to redis.
  Theorically, these calls are costly, but in practice, Redis is really fast, so you don't have to bother.
  A way to improve the scalability is to write in a redis master and reads from a slave.

Credits
-------

♡2012 by Bruno Michel. Copying is an act of love. Please copy and share.
