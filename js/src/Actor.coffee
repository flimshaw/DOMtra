define ['vendor/Box2dWeb-2.1.a.3'], (Box2D) ->

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

	window.Box2D = Box2D

	# special vars for actors
	DRAW_SCALE = 32

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

			# setup default body settings
			@density = if options.density == undefined then 1.0 else options.density
			@friction = if options.friction == undefined then .5 else options.friction
			@restitution = if options.restitution == undefined then .5 else options.restitution

			# overidden by children classes
			@preSetup()

			# run our setup function
			@setup()

			# overidden by children classes
			@postSetup()

			# kickstart the update process
			@update()

		preSetup: () ->
			return 1

		postSetup: () ->
			return

		setup: () ->
			# create a platform with some default settings
			fixDef = new b2FixtureDef
			fixDef.density = @density
			fixDef.friction = @friction
			fixDef.restitution = @restitution
			
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
			@body = game.createBody(bodyDef, fixDef)

			@hitCount = 0


		remove: () ->
			return 1


		# receive a hit from another actor on the stage somewhere
		hit: (actor) ->
			@hitCount++

		setPosition: (x, y) ->
			@x = x
			@y = y
			wX = (@x + (@width / 2)) / DRAW_SCALE
			wY = (@y + (@height / 2)) / DRAW_SCALE
			@body.SetPositionAndAngle(new b2Vec2(wX, wY))

		die: () ->
			@alive = false

		# will almost certainly be overidden by child classes
		update: () ->
			if @body.IsAwake() != undefined
				return 1

	return Actor