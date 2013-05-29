define ['bin/Level'], (Level) ->

	class LevelBoxes extends Level

		constructor: () ->
			super('LevelBoxes.json')

		actorSetup: () ->
			for i in [0..10]
				@actorManager.spawnActor( 'PlatformActor', { x: Math.random() * window.innerWidth, y: -100, dynamic: true, rotation: true })