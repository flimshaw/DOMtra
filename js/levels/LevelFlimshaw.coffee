define ['vendor/jquery-1.9.1.min', 'DOMtra'], ($, DOMtra) ->

	class LevelFlimshaw extends DOMtra.Level

		constructor: () ->
			@maxParticles = 1000
			@maxLifeSpan = 300
			@minLifeSpan = 100
			@boxSize = 32
			super('LevelFlimshaw.json')

		addDOMActor: (evt) =>
			img = $(evt.currentTarget)
			@actorManager.spawnActor( 'Actor', { x: img.offset().left, y: img.offset().top, width: img.width(), height: img.height() })

		actorSetup: () ->
			@actorManager.spawnActor( 'Actor', { x: 0, y: window.innerHeight - 32, height: 32, width: window.innerWidth, dynamic: false, rotation: false })
			@actorManager.spawnActor( 'ActorPixiHero', { x: 100, y: 0, width: 32, height: 64 })
			addDOMActor = @addDOMActor
			spawnActor = @actorManager.spawnActor
			$('.platform').each () ->
				if $(@).width() <= 0
					$(@).load addDOMActor
					$(@).attr('src', $(@).data('src'))
				else
					evt = {}
					evt.currentTarget = @
					addDOMActor(evt)
					

		behave: () ->
			if @actorManager.actors.length < @maxParticles
				@actorManager.spawnActor( 'PlatformActor', { lifeSpan: Math.random() * @maxLifeSpan + @minLifeSpan, x: Math.random() * window.innerWidth, y: -64, height: @boxSize, width: @boxSize, dynamic: true, rotation: true })

			
	return LevelFlimshaw