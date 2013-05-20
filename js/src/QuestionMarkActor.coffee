define ['bin/Actor'], (Actor) ->

	class QuestionMarkActor extends Actor

		constructor: (id, options) ->
			options.dynamic = true
			options.rotation = true
			options.width = Math.random() * 50 + 5
			options.height = Math.random() * 50 + 5
			options.className = "questionMark"
			super(id, options)

		# override our custom hit function
		hit: (actor) ->
			@hitCount += 1
			@el.style.opacity = Number(@el.style.opacity) - .05
			if @hitCount > 19
				@die()

		# override our update function
		update: () ->
			super
			if @y > window.innerHeight
				@die()

	return QuestionMarkActor