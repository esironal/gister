((gister) ->
  ###
  Set up routes
  ###
  
  gister.router = new class extends Backbone.Router
    routes:
      ""                      : "create"
      "preview/:gist"         : "preview"
      "preview"               : "preview"
      ":gist/:filename"       : "edit"
      ":gist"                 : "createOrEdit"
      
    activateFile: (filename) ->
      # Check if the gist already has a file by that name, otherwise create it
      unless gister.gist.files.get(filename)
        gister.gist.files.add({filename}) # Not async
      
      # Avoid firing unnecessary callbacks
      unless filename is gister.state.get("active")
        gister.state.set active: filename      
    
    createOrEdit: (gist) ->
      if /^\d+$/.test(gist) then @edit(gist)
      else @create(gist)
    
    create: (filename) ->
      console.log "gister.router.create", arguments...
      
      # Reset the gist because it previously referred to a saved gist
      if gister.gist.id then gister.gist.reset()
      
      @activateFile filename or gister.gist.files.getNewFilename()
      
      # Allow the interface to react to a change in modes
      if gister.state.get("mode") isnt "create"
        gister.state.set mode: "create"
    
    edit: (id, filename) ->
      console.log "gister.router.edit", arguments...
      
      self = @
      
      if id isnt gister.gist.id
        gister.gist.reset({id})
        dfd = gister.gist.fetch()
          .done -> self.activateFile filename or gister.gist.files.last()?.get("filename") or gister.gist.files.getNewFilename()
          #.fail -> alert "WTFBBQ"
      else if filename
        @activateFile filename

      # Allow the interface to react to a change in modes
      if gister.state.get("mode") isnt "edit"
        gister.state.set mode: "edit"
    
    preview: (id) ->
      console.log "gister.router.preview", arguments...
      if id isnt gister.gist.id
        gister.state.set mode: "loading"
        gister.gist.fetch id, ->
          gister.state.set
            active: (gister.gist.files.last()?.get("filename") or gister.gist.files.getNewFilename())
            mode: "preview"
      else
        gister.state.set mode: "preview"

)(window.gister)