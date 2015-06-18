#!/usr/bin/env perl
use Dancer;

use Plack::Builder;
use Plack::App::Cascade;
use Web::Hippie::App::JSFiles;

use lib ('lib');

use chat;
use chat::websocket;

my $dancer_base = sub {
    my $env     = shift;
    my $request = Dancer::Request->new( env => $env);
    Dancer->dance($request);
};

my $websocket = sub {
    my $env = shift;
    my $request = Dancer::Request->new( env => $env);
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
    )->to_app;
    mount '/' => $dancer_base;
};
