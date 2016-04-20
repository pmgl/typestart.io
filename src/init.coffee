typestart.commands.edit = new Command
  name: "edit"
  help: "Creates or opens an existing command source file"
  f: (arg)-> typestart.edit arg
  complete: (arg)->
    res = typestart.drive.list()
    for i in [res.length-1..0] by -1
      res.splice(i,1) if res[i].indexOf(arg) != 0
    res

typestart.commands.help = new Command
  name: "help"
  help: "Displays list of commands or help on a particular command"
  f: (arg)->
    if arg.length == 0
      #typestart.echo()
      for name of typestart.commands
        cmd = typestart.commands[name]
        name += ": "
        name += " " while name.length<12
        if cmd instanceof Command
          typestart.echo name+cmd.help
        else if cmd instanceof Alias
          typestart.echo name+"alias "+cmd.command
      #typestart.echo()
    else
      if typestart.commands[arg]?
        #typestart.echo()
        cmd = typestart.commands[arg]
        arg += ": "
        arg += " " while arg.length<12
        if cmd instanceof Command
          typestart.echo arg+cmd.help
          typestart.echo cmd.example if cmd.example?
        else if cmd instanceof Alias
          typestart.echo arg+"alias "+cmd.command
        typestart.echo()
      else
        "[[;#D42;#300]Command does not exist]"
    return

typestart.commands.list = new Command
  name: "list"
  help: "Displays the list of available commands"
  f: ()->
    for name of typestart.commands
      cmd = typestart.commands[name]
      typestart.echo name
    return


typestart.commands.alias = new Command
  name: "alias"
  help: "Creates an alias to another command."
  example: "alias google open http://www.google.com/?#q={args}"
  f: (arg)->
    s = arg.split(" ")
    if s.length>0
      cmd = s.splice(0,1)[0]
      args = s.join(" ").trim()
      typestart.drive.store(cmd,"new Alias(\""+args.replace(/"/g,"\\\"")+"\")")
      typestart.commands[cmd] = new Alias(args)
      cmd+": alias "+args

typestart.commands.open = new Command
  name: "open"
  help: "opens provided URL"
  f: (arg) -> typestart.open arg

typestart.commands.remove = new Command
  name: "remove"
  help: "Removes command or alias"
  f: (arg) ->
    if typestart.drive.remove(arg)
      "Removed: "+arg
    else
      typestart.error("Not found: "+arg)
      return

typestart.commands.install = new Command
  name: "install"
  help: "Installs a plug-in. Without arguments, lists the official available plug-ins."
  f: (arg)->
    if arg.length>0
      $.get "plugins/#{arg}.coffee", (result)->
        typestart.drive.store(arg,result)
        typestart.load(arg)
        typestart.echo("Successfully installed plug-in: "+arg)
      return "Installing plug-in: "+arg
    else
      typestart.echo "background: allows to set a background picture to your typestart.io"
      typestart.echo "todo: a command line todo list"
    return

#typestart.commands.load = new Command
#typestart.commands.save = new Command

try
  for name in typestart.drive.list()
    typestart.load(name)
catch err
  typestart.error(err)