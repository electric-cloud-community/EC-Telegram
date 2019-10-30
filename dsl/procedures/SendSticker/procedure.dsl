// This procedure.dsl was generated automatically
// DO NOT EDIT THIS BLOCK === procedure_autogen starts ===
procedure 'Send Sticker', description: '''Sends a sticker to the specified chat''', {

    step 'Send Sticker', {
        description = ''
        command = new File(pluginDir, "dsl/procedures/SendSticker/steps/SendSticker.pl").text
        // TODO altered shell
        shell = 'ec-perl'
        shell = 'ec-perl'

        postProcessor = '''$[/myProject/perl/postpLoader]'''
    }
// DO NOT EDIT THIS BLOCK === procedure_autogen ends, checksum: 0083a59282a088c9219a0c45e88df606 ===
// Do not update the code above the line
// procedure properties declaration can be placed in here, like
// property 'property name', value: "value"
}