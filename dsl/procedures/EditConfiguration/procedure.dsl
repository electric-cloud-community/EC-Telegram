
// DO NOT EDIT THIS BLOCK === configuration starts ===
// This part is auto-generated and will be regenerated upon subsequent updates
procedure 'EditConfiguration', description: 'Checks connection for the changed configuration', {

    step 'checkConnection',
        command: new File(pluginDir, "dsl/procedures/CreateConfiguration/steps/checkConnection.pl").text,
        errorHandling: 'abortProcedure',
        shell: 'ec-perl',
        condition: '$[/javascript myJob.checkConnection == "true" || myJob.checkConnection == "1"]'

}
// DO NOT EDIT THIS BLOCK === configuration ends, checksum: 7f1886763f3642963019c3733d76b7a5 ===
