define ['vendor/Box2dWeb-2.1.a.3', 'bin/World'], (Box2D, World) ->

	# map all our wacky Box2D methods to some more accessible places
	b2Vec2 = Box2D.Common.Math.b2Vec2
	b2AABB = Box2D.Collision.b2AABB
	b2BodyDef = Box2D.Dynamics.b2BodyDef
	b2Body = Box2D.Dynamics.b2Body
	b2FixtureDef = Box2D.Dynamics.b2FixtureDef
	b2Fixture = Box2D.Dynamics.b2Fixture
	b2World = Box2D.Dynamics.b2World
	b2MassData = Box2D.Collision.Shapes.b2MassData
	b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape
	b2CircleShape = Box2D.Collision.Shapes.b2CircleShape
	b2DebugDraw = Box2D.Dynamics.b2DebugDraw
	b2MouseJointDef =  Box2D.Dynamics.Joints.b2MouseJointDef

	# special vars for actors
	DRAW_SCALE = 32
	myWorld = World.get()

	class Actor

		@body = false
		@dynamic = false

		constructor: (id, options = false) ->
			# receive our ID, and options from our constructor
			@id = id
			@options = options

			# by default, we are alive
			@alive = true

			# is our body object dynamic or static
			@dynamic = if options.dynamic == undefined then false else options.dynamic

			# set our height and width
			@height = if options.height == undefined then 32 else options.height
			@width = if options.width == undefined then 32 else options.width

			# do we allow this object to rotate or not
			@rotation = if options.rotation == undefined then false else options.rotation

			# setup default status variables
			@x = if options.x == undefined then 0 else options.x
			@y = if options.y == undefined then 0 else options.y

			# default to not assigning listeners for contact events
			@listener = if options.listener == undefined then false else options.listener

			# run our setup function
			@setup()

		setup: () ->
			# create a platform with some default settings
			fixDef = new b2FixtureDef
			fixDef.density = 1.0
			fixDef.friction = 0.5
			fixDef.restitution = 0.45
			fixDef.shape = new b2PolygonShape
			fixDef.shape.SetAsBox((@width / 2) / DRAW_SCALE, (@height / 2) / DRAW_SCALE)

			# create a new body definition
			bodyDef = new b2BodyDef
			if @dynamic
				bodyDef.type = b2Body.b2_dynamicBody
			else
				bodyDef.type = b2Body.b2_staticBody

			# positions the center of the object (not upper left!)
			wX = (@x + (@width / 2)) / DRAW_SCALE
			wY = (@y + (@height / 2)) / DRAW_SCALE
			bodyDef.position.Set(wX, wY)
			bodyDef.userData = @id
			bodyDef.fixedRotation = !@rotation

			# instantiate our body element, and add it to the world
			@body = myWorld.createBody(bodyDef, fixDef)

			# create a div and append it 
			@el = document.createElement("div")
			@el.setAttribute("id", @id)
			@el.style.position = "absolute"
			@el.style.opacity = 1
			@el.className = "domtraActor"

			# set our shape and position according to our body
			@updateDomElement()

			# append our element to the document body
			document.body.appendChild(@el)

			@hitCount = 0

			# kickstart the update process
			@update()


		# receive a hit from another actor on the stage somewhere
		hit: (actor) ->
			@hitCount += 1
			@el.style.opacity = Number(@el.style.opacity) - .05
			if @hitCount > 19
				@die()

		updateDomElement: () -> 
				@width = (@body.GetFixtureList().m_shape.m_vertices[1].x - @body.GetFixtureList().m_shape.m_vertices[0].x) * DRAW_SCALE 
				@height = (@body.GetFixtureList().m_shape.m_vertices[2].y - @body.GetFixtureList().m_shape.m_vertices[1].y) * DRAW_SCALE
				@el.style.height = @height + "px"
				@el.style.width = @width + "px"

		updateDomPosition: () ->
			@y = Math.floor((@body.GetPosition().y * DRAW_SCALE) - (@height / 2))
			@x = Math.floor((@body.GetPosition().x * DRAW_SCALE) - (@width / 2));
			angle = @body.GetAngle()
			@el.style.top = @y + "px"
			@el.style.left = @x + "px"
			@el.style.WebkitTransform = "rotate(" + angle + "rad)"

		setPosition: (x, y) ->
			@x = x
			@y = y
			wX = (@x + (@width / 2)) / DRAW_SCALE
			wY = (@y + (@height / 2)) / DRAW_SCALE
			@body.SetPositionAndAngle(new b2Vec2(wX, wY))
			@updateDomPosition()

		die: () ->
			@alive = false

		update: () ->
			if @body.IsAwake() != undefined
				@updateDomPosition()
				if @y > 500
					@die()	

	return Actor