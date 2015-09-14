class @Baryga
  # Given an array of user ids returns an array of their relatives ids
  @getRelatives: (ids) ->
    relatives = []
    try
      result = JSON.parse(
        HTTP.get(
          "https://api.vk.com/method/users.get?" +
            "user_ids=#{ids.join(',')}" +
            "&fields=relatives&v=5.37"
        ).content
      ).response
    catch e
      console.log "https://api.vk.com/method/users.get?" +
          "user_ids=#{ids.join(',')}" +
          "&fields=relatives&v=5.37"
      return []

    if result?
      for baryga in result
        if baryga.relatives?
          for relative in baryga.relatives
            if relative.id.toString()[0] isnt '-'
              relatives.push relative.id

    relatives

  @filterByCity: (ids, city) ->
    filteredBarygas = []

    try
      result = JSON.parse(
        HTTP.get(
          "https://api.vk.com/method/users.get?" +
            "user_ids=#{ids.join(',')}" +
            "&fields=city,home_town&v=5.37"
        ).content
      ).response
    catch e
      console.log "https://api.vk.com/method/users.get?" +
          "user_ids=#{ids.join(',')}" +
          "&fields=city,home_town&v=5.37"
      return []

    if result?
      for baryga in result
        if isFromCity(baryga, city)
          filteredBarygas.push baryga.id

    filteredBarygas

  isFromCity = (baryga, searchCity) ->
    searchCity = searchCity?.toLowerCase() or ""
    city = baryga.city?.title.toLowerCase() or ""
    homeTown = baryga.home_town?.toLowerCase() or ""

    city.indexOf(searchCity) > -1 or homeTown.indexOf(searchCity) > -1
