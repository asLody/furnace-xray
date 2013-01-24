#= require vendor/d3.v3
#= require vendor/dagre
#= require vendor/jquery
#= require vendor/ui.jquery
#= require vendor/sugar-1.3.8
#= require vendor/stacktrace-0.4
#= require vendor/chosen.jquery
#= require_tree ./lib
#= require_self

# TODO: ZOMG!!! REFACTOR ME PLZ :cry: :scream: ;((((
$ ->
  svg    = $('svg')
  slider = $('#timeline .slider')
  functions = $('#functions select')
  window.index = 0

  # Resize SVG canvas
  resize = -> svg.height $('html').height() - $('#toolbar').outerHeight()
  resize() && $(window).bind 'resize', resize

  # Fill functions selector
  window.data.each (f, i) -> functions.append "<option value='#{i}'>#{f.name}</option>"
  functions.chosen()
  functions.change ->
    window.index = functions.val()
    draw()

  # Setup slider
  slider.slider
    min: 0
    slide: -> $('#timeline input').val $(@).slider('value')
    change: -> $('#timeline input').val $(@).slider('value')

  $('#timeline button.ok').click ->
    draw $('#timeline input').val().toNumber()

  $('#timeline button.left').click ->
    draw $('#timeline input').val().toNumber()-1

  $('#timeline button.right').click ->
    draw $('#timeline input').val().toNumber()+1   

  $('button').button()

  # Draw routine
  draw = (step) ->
    try
      $('#timeline').show()

      data = window.data[window.index.toNumber()]

      Drawer.reset() if window.input?.function.name != data.name
      Drawer.clear()

      window.input = new Input data
      window.input.rebuild(step)
      window.drawer = new Drawer(new Graph(input))

      slider.slider
        max: window.input.events.length-1
        value: window.input.stop

      $('#timeline #steps').text window.input.events.length-1

      $('#title').removeClass('error').html window.input.function.title()
    catch error
      console.log error
      $('#timeline').hide()
      $('#title').addClass('error').text 'Unable to build graph: problem dumped to console'

  # Start with firts function
  draw()