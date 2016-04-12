class TypeStart
  constructor: ->
    @drive = new Drive(@)
    @editor = new Editor(@)
    @commands = []
    @createIcon()
    @context = {}
    @welcome_text = """
typestart.io version 0.1
Fork me here: https://github.com/pmgl/typestart.io
type 'help' for help

"""

    @terminal = $("#terminal").terminal( ((c, term)=>
      return if c.trim().length == 0
      res = @exec c
      if res == null
        res = "null"
      else if res == false
        res = "false"
      else
        switch typeof res
          when "function"
            res = typeof res
          when "number"
            res = res.toString()
      @terminal.echo res
      return
    ),
      greetings: @welcome_text,
      name: 'tsio',
      height: "auto",
      prompt: '> ',
      completion: (terminal,input,callback)=>
        callback @completion(input)
    )

  createIcon:()->
    link = document.createElement("link")
    link.rel = "icon"
    link.type = "image/png"

    canvas = document.createElement("canvas")
    size = 512
    canvas.width = size
    canvas.height = size
    context = canvas.getContext("2d")
    context.translate(size/2,size/2)
    context.scale(size/2,size/2)
    context.fillStyle = "#000"
    #context.rotate(Math.PI*.25)
    context.fillRect(-1,-1,2,2)
    #context.rotate(-Math.PI*.25)
    context.strokeStyle = "hsl(170,50%,50%)"
    context.lineWidth = .3
    context.beginPath()
    context.moveTo(-.3,-.5)
    context.lineTo(.3,0)
    context.lineTo(-.3,.5)
    context.stroke()
    link.href = canvas.toDataURL()

    document.head.appendChild(link)

  showEditor:()->
    $(".terminalcontainer").hide()
    $(".editorcontainer").show()
    @terminal.pause()
    @editor.editor.focus(true)

  showTerminal:()->
    $(".terminalcontainer").show()
    $(".editorcontainer").hide()
    @terminal.resume()

  eval:(code)->
    return eval.call(@context,code)

  exec:(line)->
    line = line.trim()
    return if line.length == 0
    s = line.split(" ")
    if s.length>0
      command = s.splice(0,1)[0]
      args = if s.length>0 then s.join(" ").trim() else ""

      if not @commands[command]? and @drive.load(command)?
        @load(command)

      if @commands[command]?
        if @commands[command] instanceof Alias
          cmd = @commands[command].command
          if cmd.indexOf("{args}")>= 0
            cmd = cmd.replace("{args}",args)
          else
            cmd = cmd + " " + args
          @exec(cmd)
        else if @commands[command] instanceof Command
          @commands[command].f(args)
      else if line.indexOf("http://") == 0 or line.indexOf("https://") == 0 or line.indexOf("www.") == 0
        @open(line)
      else
        try
          compiled = CoffeeScript.compile(line,{bare: true})
          @eval(compiled,args)
        catch err
          "[[;#D42;#300]#{err}]"

  load:(command)->
    code = @drive.load command
    if code?
      compiled = CoffeeScript.compile(code, { bare: true })
      @commands[command] = @eval(compiled)

  echo:(arg=" ")->
    @terminal.echo(arg)
    return

  error:(text)->
    @echo "[[;#D42;#300]#{text}]"

  edit:(arg)->
    @current_project = arg
    @editor.edit(arg)

  open:(arg)->
    if arg.indexOf("http://")<0 and arg.indexOf("https://")<0
      arg = "http://"+arg
    window.open(arg,"_blank")
    return

  export:()->

  import:()->

  completion:(input)->
    res = []
    for c of @commands
      if c.indexOf(input) == 0
        res.push c
    res

  store:(args)->
    i = args.indexOf(" ")
    @typestart.drive.store(args.substring(0,i),args.substring(i,args.length).trim())

  list:()->
    res = @typestart.drive.list()
    res.join("\n")

typestart = new TypeStart()