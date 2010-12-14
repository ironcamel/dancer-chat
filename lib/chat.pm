package chat;
use Dancer ':syntax';

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get qr{/chat/(.*)} => sub {
    my $room = splat;
    my $env  = request->env;
    template 'room', { room => $room, host => 'foo', env => $env };
};

true;
