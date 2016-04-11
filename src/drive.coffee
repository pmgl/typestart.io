class @Drive
  constructor:(@main)->

  store:(name,data)->
    localStorage.setItem("typestart."+name,data)

  load:(name)->
    localStorage.getItem("typestart."+name)

  exists:(name)->
    localStorage.getItem("typestart."+name)?

  remove:(name)->
    if @exists(name)
      localStorage.removeItem("typestart."+name)
      true
    else
      false

  list:()->
    res = []
    for i in [0..localStorage.length-1]
      key = localStorage.key(i)
      if key.indexOf("typestart.") == 0
        res.push key.substring(10,key.length)

    res