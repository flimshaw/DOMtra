define ['vendor/Box2dWeb-2.1.a.3', 'bin/World', 'bin/Actor'], (Box2D, World, Actor) ->

	# special vars for actors
	DRAW_SCALE = 32

	class ActorDOM extends Actor

		@body = false
		@dynamic = false

		preSetup: () ->
			# create a div and append it 
			@el = document.createElement("div")
			@el.setAttribute("id", @id)
			@el.style.position = "absolute"
			@el.style.opacity = 1
			@el.className = @className || "default"

			# append our element to the document body
			document.body.appendChild(@el)

			@elReady = true

		postSetup: () ->
			@updateDomElement()

		updateDomElement: () -> 
			@width = (@body.GetFixtureList().m_shape.m_vertices[1].x - @body.GetFixtureList().m_shape.m_vertices[0].x) * DRAW_SCALE 
			@height = (@body.GetFixtureList().m_shape.m_vertices[2].y - @body.GetFixtureList().m_shape.m_vertices[1].y) * DRAW_SCALE
			@el.style.height = @height + "px"
			@el.style.width = @width + "px"

		remove: () ->
			document.body.removeChild(@el)

		updateDomPosition: () ->
			@el.style.top = Math.floor((@body.GetPosition().y * DRAW_SCALE) - (@height / 2)) + "px"
			@el.style.left = Math.floor((@body.GetPosition().x * DRAW_SCALE) - (@width / 2)) + "px"
			@el.style.WebkitTransform = "rotate(" + @body.GetAngle() + "rad)"

		setPosition: (x, y) ->
			super(x, y)
			@updateDomPosition()

		update: () ->
			if @body.IsAwake() != undefined && @elReady == true
				@updateDomPosition()

	return ActorDOM