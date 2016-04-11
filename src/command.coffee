class @Command
  constructor:(data={})->
    @name = "Undefined command"
    @f = => @name
    @complete = ()=>
    @help = "Undocumented command"

    if typeof data == "string"
      try
        compiled = CoffeeScript.compile("(args)->\n  "+data.split("\n").join("\n  "), { bare: true })
        @f = eval.call(typestart.getContext(),compiled)
      catch error
    else
      @name = data.name if data.name?
      @f = data.f if data.f?
      @complete = data.complete if data.complete?
      @help = data.help if data.help?
      @example = data.example if data.example?
