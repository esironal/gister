((lumbar) ->
  ###
  Define Lumbar model classes
  ###
  
  class lumbar.Collection extends Backbone.Collection
  
  class lumbar.Model extends Backbone.Model
    getViewModel: -> _.extend {}, @toJSON()
    

)(window.lumbar)