// This procedure.dsl was generated automatically
// DO NOT EDIT THIS BLOCK === procedure_autogen starts ===
procedure 'Send Notification', description: '''Sends a simple text message''', {

    step 'Send Notification', {
        description = ''
        command = new File(pluginDir, "dsl/procedures/SendNotification/steps/SendNotification.pl").text
        // TODO altered shell
        shell = 'ec-perl'

        postProcessor = '''$[/myProject/perl/postpLoader]'''
    }
// DO NOT EDIT THIS BLOCK === procedure_autogen ends, checksum: c7f1c1967bb796fb8c6d9d5ffd5e963b ===
// Do not update the code above the line
// procedure properties declaration can be placed in here, like
// property 'property name', value: "value"
}