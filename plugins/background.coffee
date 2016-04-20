new Command
  name: "background"
  help: "sets the provided image URL as background image for typestart.io window"

  init: ()->
    bg = typestart.datastore.get("background","image")
    if bg? and bg.length>0
      document.body.style.background = "url(#{bg}) no-repeat center center / cover fixed"

  f: (arg)->
    if arg.length>0
      document.body.style.background = "url(#{arg}) no-repeat center center / cover fixed"
      typestart.datastore.set("background","image",arg)
    else
      document.body.style.background = "hsl(200,50%,30%)"
      typestart.datastore.get("background","image",arg)