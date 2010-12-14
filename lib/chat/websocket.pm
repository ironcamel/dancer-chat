package chat::websocket;

use strict;
use warnings;
use Dancer ':syntax';

use Dancer::Plugin::WebSocket;

websocket '/new_listener' => sub {
    my $env   = request->env;
    my $room  = $env->{'hippie.args'};
    my $topic = $env->{'hippie.bus'}->topic($room);
    $env->{'hippie.listener'}->subscribe($topic);
};

websocket '/message' => sub {
    my $env   = request->env;
    my $room  = $env->{'hippie.args'};
    my $topic = $env->{'hippie.bus'}->topic($room);

    my $msg = $env->{'hippie.message'};
    $msg->{time} = time;
    $msg->{address} = $env->{REMOTE_ADDR};
    $topic->publish($msg);
};

1;
