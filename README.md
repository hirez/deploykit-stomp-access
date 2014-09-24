deploykit-stomp-access
======================

Devolve management responsibility for stage access.


What?
=====

A wee Sinatra site that generates passwords for the purposes of stuffing same into 
the (ht)access files in Nginx and/or HAProxy. Talks to a daemon on the target box(es) 
that 'manages' those logins.


Why?
====

We have (or had) a pile of sites that kept non-public versions lying around like teenagers, 
waiting for some random third party to sign off on the state of the pixels. Traditionally, 
access to those was 'managed' by allow rules in the website config. This was exactly as 
scalable and secure as you might imagine. 

So I hacked this rig up to make Ad Ops sod off and leave us alone.


Installation.
=============

As is becoming traditional, you will need a working STOMP broker or two.

The daemon ought to (Debian) package up per the shellscript. Insert broker user/pw in 
the YAML config as appropriate. You should probably tweak the topic names, too.

The 'server' is yet another squitty Sinatra 'app', which comes with initscript and 
nginx vhost in the obvious subdirs. Blah blah blah modern ruby, Bundler, Unicorn.

For HAProxy, a section of the initscript looks like this:

```
STAGEAUTH=/etc/haproxy/different-site.access

haproxy_start()
{
        start-stop-daemon --start --pidfile "$PIDFILE" \
                --exec $HAPROXY -- -f "$CONFIG" -f "$STAGEAUTH" -D -p "$PIDFILE" \
                $EXTRAOPTS || return 2
        return 0
}
```

For nginx:
```
auth_basic_user_file includes/example-site.access;
```
