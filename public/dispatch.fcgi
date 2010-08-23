#!/usr/bin/env perl
use Plack::Handler::FCGI;

my $app = do('/home/franck/code/projects/perl5/chat/app.psgi');
my $server = Plack::Handler::FCGI->new(nproc  => 5, detach => 1);
$server->run($app);
