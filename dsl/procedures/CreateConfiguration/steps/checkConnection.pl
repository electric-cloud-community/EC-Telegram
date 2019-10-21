use strict;
use warnings FATAL => 'all';
use ElectricCommander;

use Data::Dumper;
use LWP::UserAgent;
use HTTP::Request;
use URI::Escape qw/uri_escape/;
use JSON qw/decode_json/;

my $ec = ElectricCommander->new;

eval {
    # Get token
    my $token_xpath = $ec->getFullCredential('credential');
    die "No token specified" unless $token_xpath;
    my $token_secret = ( $token_xpath ? $token_xpath->findvalue("//password") : '' );
    die "No token specified" unless $token_secret;

    # Get Endpoint value
    my $uri = $ec->getProperty('endpoint')->findvalue('//value')->string_value;

    my $ua = LWP::UserAgent->new();

    my $endpoint = URI->new($uri);
    $endpoint->path('bot' . uri_escape($token_secret) . "/getMe");
    my $request = HTTP::Request->new(GET => $endpoint);

    my $response = $ua->request($request);

    unless ($response->is_success) {
        die "Request failed with " . $response->status_line();
    }

    my $json = JSON::decode_json($response->decoded_content());

    my $connectionSucceeded = $json->{ok} eq 'true';
    if (! $connectionSucceeded) {
        die "Connection failed: code '$connectionSucceeded'";
    }

    print "Bot name is: " . $json->{result}->{first_name} . "\n";
    exit 0;
};

# If the block code in eval {} dies
if ($@) {
    my $msg = $@;
    $ec->setProperty('/myJob/configError', $msg);
    $ec->setProperty('/myJobStep/summary', $msg);
    exit 1;
};
