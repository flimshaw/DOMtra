define ['bin/EventDispatcher', 'bin/Box2DActorManager', 'vendor/requestAnimationFrame'], (EventDispatcher, Box2DActorManager, requestAnimFrame) ->

	class PlatformGame extends EventDispatcher

		constructor: () ->
			@box2d = new Box2DActorManager(@)
			super

		start: () ->
			for i in [0..5]
				@box2d.spawnActor('PlatformActor', { width: 192, height: 32, x: (window.innerWidth * .9) * Math.random(), y: i * 100 + 300 })

			requestAnimFrame @update
			@dispatch("gameStarted")

		spawnColumbos: () ->
			if @box2d.actors.length < 100
				@box2d.spawnActor('ActorPixiHero', { width: 34, height: 52, x: window.innerWidth * Math.random(), y: -80 })

		update: () =>
			requestAnimFrame @update
			@spawnColumbos()
			@box2d.update()


		dispatchTestEvent: () ->
			@dispatch("testEvent")