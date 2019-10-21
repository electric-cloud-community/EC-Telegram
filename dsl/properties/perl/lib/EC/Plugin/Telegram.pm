package EC::Plugin::Telegram;
use strict;
use warnings;

use base qw/ECPDF/;
use ECPDF::Log;

use Data::Dumper;
use JSON::XS qw/decode_json/;

# Service function that is being used to set some metadata for a plugin.
sub pluginInfo {
    return {
        pluginName      => '@PLUGIN_KEY@',
        pluginVersion   => '@PLUGIN_VERSION@',
        configFields    => [ 'config' ],
        configLocations => [ 'ec_plugin_cfgs' ]
    };
}

# Auto-generated method for the procedure Send Notification/Send Notification
# Add your code into this method and it will be called when step runs
sub sendNotification {
    my ECPDF $pluginObject = shift;

    my ECPDF::Context $context = $pluginObject->newContext();
    my ECPDF::Config $configValues = $context->getConfigValues();

    my $params = $context->getStepParameters();

    my $result = eval {sendNotificationStep($pluginObject, $configValues, $params)};
    if ($@) {
        my ECPDF::StepResult $stepResult = $context->newStepResult();
        $stepResult->setJobStepOutcome('error');
        $stepResult->setJobSummary('Job step failed');
        $stepResult->setJobStepSummary("Error: " . $@);
        $stepResult->apply();
        return 0;
    }

    my ECPDF::StepResult $stepResult = $context->newStepResult();
    $stepResult->setJobStepOutcome($stepResult->{outcome} || 'success');
    $stepResult->setJobStepSummary($stepResult->{jobStepSummary} || 'empty job step summary');
    $stepResult->setJobSummary($result->{jobSummary} || $stepResult->{jobStepSummary});
    $stepResult->apply();

    return 1;
}

sub sendNotificationStep {
    my ( $pluginObject, $configValues, $params ) = @_;

    # Reading parameters
    my $receiver = $params->getRequiredParameter('chatId')->getValue();
    my $message = $params->getRequiredParameter('text')->getValue();
    my $silent = $params->getParameter('silent') ? $params->getParameter('text')->getValue() : '';

    # Reading config values
    my $endpoint = $configValues->getRequiredParameter('endpoint');
    my $token = $configValues->getRequiredParameter('credential')->getSecretValue();

    ## Building the request
    my $rest = $pluginObject->newContext()->newRESTClient();

    # URI and query parameters
    my URI::http $request_uri = URI->new($endpoint);
    $request_uri->path("bot$token/sendMessage");
    $request_uri->query_form(
        chat_id              => $receiver,
        text                 => $message,
        disable_notification => ( $silent ? 'true' : 'false' )
    );
    my $request = $rest->newRequest(POST => $request_uri);
    logTrace("REQUEST", $request);

    # Do the request
    my $response = $rest->doRequest($request);
    logTrace("RESPONSE", $response);

    # Check response errors
    unless ($response->is_success) {
        logDebug("REQUEST", $request);
        logDebug("RESPONSE", $response);

        my $status_error = '';

        # Trying to read the message from the JSON body
        eval {
            my $json = eval {decode_json($response->decoded_content())};
            $status_error = $json->{description};
            if ($@) {
                die "Failed to decode the JSON: $@";
            }
        };

        # If we cannot receive the error from the JSON, just show the HTTP status line
        die $status_error || $response->status_line();
    }

    my $json = eval {decode_json($response->decoded_content())};
    if ($@) {
        die "Failed to decode the JSON: $@";
    }

    # Check API error (inside the content)
    if (! $json->{ok} == 1) {
        die 'Telegram returned error :' . ( $json->{description} || 'Unknown error' );
    }

    return {
        outcome    => 'success',
        summary    => 'Sent notification',
        jobSummary => 'Success',
    }
}
## === step ends ===
# Please do not remove the marker above, it is used to place new procedures into this file.


1;