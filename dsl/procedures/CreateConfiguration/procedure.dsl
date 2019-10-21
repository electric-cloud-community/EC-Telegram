
// === configuration starts ===
// This part is auto-generated and will be regenerated upon subsequent updates
procedure 'CreateConfiguration', description: 'Creates a plugin configuration', {

    step 'checkConnection',
        command: new File(pluginDir, "dsl/procedures/CreateConfiguration/steps/checkConnection.pl").text,
        errorHandling: 'abortProcedure',
        shell: 'ec-perl',
        condition: '$[/javascript myJob.checkConnection == "true"]'

    step 'createConfiguration',
        command: new File(pluginDir, "dsl/procedures/CreateConfiguration/steps/createConfiguration.pl").text,
        errorHandling: 'abortProcedure',
        exclusiveMode: 'none',
        postProcessor: 'postp',
        releaseMode: 'none',
        shell: 'ec-perl',
        timeLimitUnits: 'minutes'

    property 'ec_checkConnection', value: ''
// === configuration ends, checksum: f0b384fd8177fc7f2495e0f70e09049c ===
// Place your code below
}