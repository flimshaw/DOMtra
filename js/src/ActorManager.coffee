define [
	'vendor/underscore',
	'bin/World',
	'bin/Actor'
	], (_, World, Actor) ->

	class ActorManager

		constructor: () ->
			# object to hold all of our actor objects
			@actors = []
			@world = World.get()
			console.log("ActorManager Started")

		# factory method, returns an Actor object based on criteria
		actorFactory: (actorType, options) ->
			switch(actorType)
				when "Actor" then new Actor(@generateUID(), options)
				else new Actor(@generateUID(), options)

		# generate a guid for new actors
		generateUID: () ->
			guid = "d" + (((1+Math.random())*0x10000)|0).toString(16).substring(1) + (((1+Math.random())*0x10000)|0).toString(16).substring(1)
			return guid

		# attempt to create an actor from the json packet, return a reference to the actor we created
		spawnActor: (actorType, options) ->
			a = @actorFactory(actorType, options)
			@actors.push a
			return a

		getActorByUID: (uid) ->
			a = _.find @actors, (actor) ->
				actor.id == uid
			if a then a else -1

		deleteActor: (actor) ->
			document.body.removeChild(actor.el)
			@world.removeBody(actor.body)	

		# loop through all actors and update each one
		update: () ->
			# update all dynamic actors
			_.each @actors, (actor) =>	
				if actor.dynamic
					actor.update()
					if !actor.alive
						@deleteActor(actor)

			# filter our actor listing to get rid of dead guys
			@actors = _.filter @actors, (actor) ->
				actor.alive

	return ActorManager