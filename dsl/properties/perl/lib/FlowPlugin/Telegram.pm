package FlowPlugin::Telegram;
use JSON;
use strict;
use warnings;
use base qw/FlowPDF/;
use FlowPDF::Log;
use Data::Dumper;
use JSON::XS qw/decode_json/;

# Feel free to use new libraries here, e.g. use File::Temp;

# Service function that is being used to set some metadata for a plugin.
sub pluginInfo {
    return {
        pluginName          => '@PLUGIN_KEY@',
        pluginVersion       => '@PLUGIN_VERSION@',
        configFields        => ['config'],
        configLocations     => ['ec_plugin_cfgs'],
        defaultConfigValues => {}
    };
}
# Auto-generated method for the procedure Send Notification/Send Notification
# Add your code into this method and it will be called when step runs
sub sendNotification {
    my FlowPDF $pluginObject = shift;

    my FlowPDF::Context $context = $pluginObject->newContext();
    my FlowPDF::Config $configValues = $context->getConfigValues();

    my $params = $context->getStepParameters();

    my $result = eval {sendNotificationStep($pluginObject, $configValues, $params)};
    if ($@) {
        my FlowPDF::StepResult $stepResult = $context->newStepResult();
        $stepResult->setJobStepOutcome('error');
        $stepResult->setJobSummary('Job step failed');
        $stepResult->setJobStepSummary("Error: " . $@);
        $stepResult->apply();
        return 0;
    }

    my FlowPDF::StepResult $stepResult = $context->newStepResult();
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

# Auto-generated method for the procedure Send Sticker/Send Sticker
# Add your code into this method and it will be called when step runs
# Parameter: config
# Parameter: chatId
# Parameter: stickerId
# Parameter: silent

sub sendSticker {
    my ($pluginObject) = @_;

    my $context = $pluginObject->getContext();
    my $params = $context->getRuntimeParameters();

    my $ECTelegramRESTClient = $pluginObject->getECTelegramRESTClient;
    # If you have changed your parameters in the procedure declaration, add/remove them here
    my %restParams = (
        'chat_id' => $params->{'chatId'},
        'sticker' => $params->{'stickerId'},
        'disable_notification' => $params->{'silent'},
    );
    my $response = $ECTelegramRESTClient->sendSticker(%restParams);
    logInfo("Got response from the server: ", $response);

    my $stepResult = $context->newStepResult;

    $stepResult->apply();
}

# This method is used to access auto-generated REST client.
sub getECTelegramRESTClient {
    my ($self) = @_;

    my $context = $self->getContext();
    my $config = $context->getRuntimeParameters();

    require FlowPlugin::ECTelegramRESTClient;
    my $client = FlowPlugin::ECTelegramRESTClient->new(
        $config->{endpoint},
        bot_token => $config->{password},
    );
    return $client;
}
## === step ends ===
# Please do not remove the marker above, it is used to place new procedures into this file.


1;
