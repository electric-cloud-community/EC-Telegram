// This procedure.dsl was generated automatically
// DO NOT EDIT THIS BLOCK === procedure_autogen starts ===
procedure 'Send Notification', description: '''Sends a simple text message''', {

    step 'Send Notification', {
        description = ''
        command = new File(pluginDir, "dsl/procedures/SendNotification/steps/SendNotification.pl").text
        // TODO altered shell
        shell = 'ec-perl'
        shell = 'ec-perl'

        postProcessor = '''$[/myProject/perl/postpLoader]'''
    }
// DO NOT EDIT THIS BLOCK === procedure_autogen ends, checksum: d9210145310f0cf5b6215a0970d5da18 ===
// Do not update the code above the line
// procedure properties declaration can be placed in here, like
// property 'property name', value: "value"
}