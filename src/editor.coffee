class @Editor
  constructor:(@typestart)->
    @editor = ace.edit("editor")
    @editor.setTheme "ace/theme/tomorrow_night_bright"
    @editor.getSession().setMode "ace/mode/coffee"
    @editor.getSession().on('change',=>
      @editorContentsChanged()
    )

  edit:(name)->
    content = @typestart.drive.load(name)
    if content?
      @editor.setValue content,1
    else
      @editor.setValue ""
    @typestart.showEditor()

  editorContentsChanged:()->
    @typestart.drive.store(@typestart.current_project,@editor.getValue())

