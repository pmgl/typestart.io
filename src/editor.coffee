class @Editor
  constructor:(@typestart)->
    @editor = ace.edit("editor")
    @editor.setTheme "ace/theme/tomorrow_night_bright"
    @editor.getSession().setMode "ace/mode/coffee"
    @editor.getSession().on('change',=>
      @editorContentsChanged()
    )
    $("#editorcancelbutton").click ()=>
      @typestart.showTerminal()

    $("#editorsavebutton").click ()=>
      @typestart.drive.store(@typestart.current_project,@editor.getValue())
      @typestart.showTerminal()

  edit:(name)->
    $("#editorfilename").html "editing: #{name}"
    content = @typestart.drive.load(name)
    if content?
      @editor.setValue content,1
    else
      @editor.setValue ""
    @typestart.showEditor()

  editorContentsChanged:()->
    #@typestart.drive.store(@typestart.current_project,@editor.getValue())

