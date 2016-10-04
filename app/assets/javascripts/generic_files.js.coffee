$ ->

  toggleHiddenFields = -> 
    $(".fields").each ->
      x = $(this).children('dt')
      y = $(this).children('dd')
      if y.text().trim() == ""
        x.toggle()
        y.toggle()
  
  showAll = ->
    $(".fields").each ->
      x = $(this).children('dt')
      y = $(this).children('dd')
      x.show()   
      y.show()

  toggleHiddenFields()


  $('#showHiddenFields').click ->
    if $(this).hasClass( "is-hidden")
      showAll()
      $(this).html("Hide Empty Fields")
      $(this).removeClass("is-hidden")
      $(this).addClass("visible")
    else
      toggleHiddenFields()
      $(this).html("Show Hidden Fields")
      $(this).removeClass("visible")
      $(this).addClass("is-hidden")
    
