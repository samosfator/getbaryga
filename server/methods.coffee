Meteor.methods
  'getBarygas': (startingId, deep) ->
    relatives = Baryga.getRelatives [startingId]
    skipIds = []
    fromTernopil = []
    deep = parseInt(deep) or 1

    _(deep).times (n) ->
      console.log "running a #{n + 1} loop.... #{relatives.length} relatives,
      #{skipIds.length} skipping ids, #{fromTernopil.length} are from Ternopil !"
      Meteor._sleepForMs 400

      relativesChunks = chunk(relatives, 120)
      getTernopilGuys(relativesChunks)
      skipScannedGuys()
      findNewRelatives(relativesChunks)
      removeDuplicateGuys()
    fromTernopil

    getTernopilGuys = (relativesChunks) ->
      for relativesChunk, index in relativesChunks
        console.log 'processing chunk #' + (index + 1) + " (length: #{relativesChunk.length}) of " + relativesChunks.length
        Meteor._sleepForMs 300

        for ternopilBaryga in Baryga.filterByCity(relativesChunk, 'Терноп')
          fromTernopil.push ternopilBaryga

    skipScannedGuys = ->
      for scannedRelative in relatives
        skipIds.push scannedRelative

    findNewRelatives = (relativesChunks) ->
      for relativesChunk, index in relativesChunks
        Meteor._sleepForMs 300
        for newRelative in Baryga.getRelatives relativesChunk
          relatives.push newRelative

    removeDuplicateGuys = ->
      relatives = _.difference relatives, skipIds
      relatives = _.uniq relatives


chunk = (data, n) ->
  _.chain(data).groupBy((element, index) ->
    Math.floor index / n
  ).toArray().value()