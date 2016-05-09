new Command
  name: "todo"
  help: "A command-line todo list"

  f: (arg)->
    s = typestart.splitArg(arg)

    try
      list = typestart.datastore.get("todo","list")
    catch err

    list = [] if not list?

    switch s.length
      when 0
        displayed = 0
        for i in [0..list.length-1] by 1
          if list[i]?
            typestart.echo("#{i+1}. #{list[i]}")
            displayed++
        return if displayed == 0 then "Nothing to do!" else undefined

      when 1,2
        num = parseInt(s[0])
        if not Number.isNaN(num) and num>0
          switch s[1]
            when "done"
              task = list[num-1]
              list[num-1] = null
              typestart.datastore.set("todo","list",list)
              return "Task done: #{num}. #{task}"
        else
          switch s[0]
            when "done"
            else
              for i in [0..list.length-1] by 1
                if not list[i]?
                  list[i] = arg
                  typestart.datastore.set("todo","list",list)
                  return "New task: #{i+1}. #{arg}"
              list.push(arg)
              typestart.datastore.set("todo","list",list)
              return "New task: #{list.length}. #{arg}"

