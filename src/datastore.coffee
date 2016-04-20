class @DataStore
  constructor:(@main)->

  set:(namespace,name,data)->
    namespace = namespace.name if typeof namespace != "string" and namespace.name?
    localStorage.setItem(namespace+"."+name,JSON.stringify(data))

  get:(namespace,name)->
    namespace = namespace.name if typeof namespace != "string" and namespace.name?
    JSON.parse localStorage.getItem(namespace+"."+name)

  exists:(namespace,name)->
    namespace = namespace.name if typeof namespace != "string" and namespace.name?
    localStorage.getItem(namespace+"."+name)?

  remove:(namespace,name)->
    namespace = namespace.name if typeof namespace != "string" and namespace.name?
    if @exists(namespace,name)
      localStorage.removeItem(namespace+"."+name)
      true
    else
      false

  list:(namespace)->
    namespace = namespace.name if typeof namespace != "string" and namespace.name?
    res = []
    for i in [0..localStorage.length-1]
      key = localStorage.key(i)
      if key.indexOf(namespace+".") == 0
        res.push key.substring(10,key.length)

    res