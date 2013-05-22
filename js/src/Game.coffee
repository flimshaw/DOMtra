define ['bin/EventDispatcher', 'bin/Box2DActorManager', 'vendor/requestAnimationFrame'], (EventDispatcher, Box2DActorManager, requestAnimFrame) ->

	class PlatformGame extends EventDispatcher

		constructor: () ->
			@box2d = new Box2DActorManager(@)
			@maxColumbos = 1000

			super

		start: () ->
			for i in [0..5]
				@box2d.spawnActor('PlatformActor', { width: 192, height: 32, x: (window.innerWidth * .9) * Math.random(), y: i * 100 + 300 })
			@spawnHero()
			requestAnimFrame @update
			@dispatch("gameStarted")

		spawnHero: () ->
			@box2d.spawnActor('ActorPixiHero', { x: (window.innerWidth * .9) * Math.random(), y: 200 })

		spawnColumbos: () ->
			if @box2d.actors.length < @maxColumbos
				@box2d.spawnActor('ActorPixiColumbo', { width: 34, height: 52, x: window.innerWidth * Math.random(), y: -80 })

		update: () =>
			requestAnimFrame @update
			@spawnColumbos()
			@box2d.update()


		dispatchTestEvent: () ->
			@dispatch("testEvent")