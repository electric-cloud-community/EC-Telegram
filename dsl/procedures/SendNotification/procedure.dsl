// This procedure.dsl was generated automatically
// === procedure_autogen starts ===
procedure 'Send Notification', description: 'Sends a simple text message', {

    step 'Send Notification', {
        description = ''
        command = new File(pluginDir, "dsl/procedures/SendNotification/steps/SendNotification.pl").text
        shell = 'ec-perl'

    }
// === procedure_autogen ends, checksum: 0a2859e740efc7ab5b51e75d9f1904b4 ===
// Do not update the code above the line
// procedure properties declaration can be placed in here, like
// property 'property name', value: "value"
}