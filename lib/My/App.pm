use v5.26;
use utf8;
package My::App;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
/;

extends 'Catalyst';

has 'schema' => (
    is      => 'ro',
    isa     => 'Object',
    builder => '_build_schema',
);

sub _build_schema {
    my ( $self ) = ( shift );
    my $config = $self->config;

    require My::App::Schema;
    return 'My::App::Schema'->connect(
        $config->{'database'},
        $config->{'database_username'},
        $config->{'database_password'},
    );
}

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in my_app.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'My::App',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
    encoding => 'UTF-8', # Setup request decoding and response encoding
);

# Start the application
__PACKAGE__->setup();

=encoding utf8

=head1 NAME

My::App - Catalyst based application

=head1 SYNOPSIS

    script/my_app_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<My::App::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Toby Inkster, tinkster@theperlshop.net

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
