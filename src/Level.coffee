define ['bin/ActorManager'], (ActorManager) ->

	class Level

		constructor: (jsonFile) ->

			@ready = false
			@alive = true
			$.getJSON(jsonFile, @setup)

		setup: (data) =>

			# start an actor manager
			@actorManager = new ActorManager(@)

			# set gravity options
			game.setGravity(data.world.gravity.x, data.world.gravity.y)

			@actorsListing = data.actors

			assetsToLoader = [ data.spriteSheet ]

			loader = new PIXI.AssetLoader(assetsToLoader)

			loader.onComplete = () =>
				@initializeActors()
				@ready = true

			loader.load()

		# overwritten by children classes to define specific levels
		initializeActors: () ->
			for actor in @actorsListing
				@actorManager.spawnActor(actor.type, actor.options)
			@actorSetup()

		actorSetup: () ->
			return 1

		# overwritten by children classes to determine level state and run special actor checks
		behave: () ->
			return true

		die: () ->
			@alive = false

		update: () ->
			if @ready
				if !@behave()
					@die()
				@actorManager.update()