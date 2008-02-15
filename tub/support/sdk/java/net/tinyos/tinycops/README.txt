This folder includes two simple tools for injecting subscriptions / reading
notifications from a TinyCOPS application over the serial line. After running
make (in case of errors check your CLASSPATH variable) you can use
"SubscriptionInject" to inject a subscription and afterwards start
"NotificationListen" to listen for notifications.

For example, after installing tinyos-2.x-contrib/tub/apps/TinyCOPS on multiple
nodes, first run
$ java net.tinyos.tinycops.SubscriptionInject -constraint Ping ANY 0 -metadata Rate 10
and then
$ java net.tinyos.tinycops.NotificationListen
to display incoming notifications from the publishers. Then
$ java net.tinyos.tinycops.SubscriptionInject -unsubscribe
will stop the publishers.

In case of problems check that
-> all nodes have separate IDs
-> the SubscriberGWC() component was instantiated in the app
-> the attributes you subscribe to are present in the app

