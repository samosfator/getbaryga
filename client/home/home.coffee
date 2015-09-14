Template.Home.events
  'click button': (event, tmpl) ->
    Meteor.call "getBarygas", tmpl.$('input[type=text]').val(), tmpl.$('input[type=range]').val(), (err, result) ->
      arr = ("<br><a href=\"https://vk.com/id#{id}\" target=\"_blank\">https://vk.com/id#{id}</a>" for id in result)
      tmpl.$(event.target).after(arr.join(''))
