#!/usr/bin/env perl
use lib ('/home/franck/code/git/dancer/lib');
use Dancer;

use Plack::Builder;
use Plack::App::Cascade;
use Web::Hippie::App::JSFiles;

use lib ('lib');

load_app 'chat';
load_app 'chat::websocket';

my $dancer_base = sub {
    my $env     = shift;
    my $request = Dancer::Request->new($env);
    Dancer->dance($request);
};

my $websocket = sub {
    my $env = shift;
    my $request = Dancer::Request->new($env);
    Dancer->dance($request);
};

builder {
    mount '/_hippie' => builder {
        enable "+Web::Hippie";
        enable "+Web::Hippie::Pipe";
        $websocket;
    };
    mount '/static' => Plack::App::Cascade->new(
        apps => [
            Web::Hippie::App::JSFiles->new->to_app,
            Plack::App::File->new( root => 'public' )->to_app,
        ]
    );
    mount '/' => $dancer_base;
};
