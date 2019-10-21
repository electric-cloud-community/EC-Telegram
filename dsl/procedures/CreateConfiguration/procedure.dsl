
// DO NOT EDIT THIS BLOCK === configuration starts ===
procedure 'CreateConfiguration', description: 'Creates a plugin configuration', {

    step 'checkConnection',
        command: new File(pluginDir, "dsl/procedures/CreateConfiguration/steps/checkConnection.pl").text,
        errorHandling: 'abortProcedure',
        shell: 'ec-perl',
        condition: '$[/javascript myJob.checkConnection == "true" || myJob.checkConnection == "1"]'

    step 'createConfiguration',
        command: new File(pluginDir, "dsl/procedures/CreateConfiguration/steps/createConfiguration.pl").text,
        errorHandling: 'abortProcedure',
        exclusiveMode: 'none',
        postProcessor: 'postp',
        releaseMode: 'none',
        shell: 'ec-perl',
        timeLimitUnits: 'minutes'

    property 'ec_checkConnection', value: ''
// DO NOT EDIT THIS BLOCK === configuration ends, checksum: b014b0643b8b6b4a90b3d1745039da70 ===
// Place your code below
}