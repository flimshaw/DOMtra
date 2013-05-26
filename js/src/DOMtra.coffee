define 'DOMtra', ['bin/EventDispatcher', 'vendor/Box2dWeb-2.1.a.3', 'bin/ActorManager', 'vendor/requestAnimationFrame', 'bin/Level'], (EventDispatcher, Box2D, ActorManager, requestAnimFrame, Level) ->

	class DOMtra extends EventDispatcher

		# special vars for actors
		DRAW_SCALE = 32

		# some Box2D short-form references
		window.b2World = Box2D.Dynamics.b2World
		window.b2Vec2 = Box2D.Common.Math.b2Vec2
		window.b2DebugDraw = Box2D.Dynamics.b2DebugDraw

		constructor: (options) ->

			@options = options || {}

			# create a global for this game
			window.game = @;

			# get our console div
			#@el = document.createElement("div")
			#@el.setAttribute("id", "console")
			#@el.style.position = "absolute"
			#@el.style.left = 50
			#@el.style.top = 50
			#@el.style.width = 200
			#@el.style.height = 200
			#@el.style.opacity = .75
			#@el.style.color = "white"

			# append our element to the document body
			#document.body.appendChild(@el)
			
			# start a new PIXI stage
			@stage = new PIXI.Stage()

			# start a renderer
			@renderer = PIXI.autoDetectRenderer(window.innerWidth, window.innerHeight, null, true)

			# add it to the 
			@renderer.view.style.position = "absolute"
			@renderer.view.style.top = 0
			@renderer.view.style.left = 0
			@renderer.view.style.zIndex = 0
			document.body.appendChild(@renderer.view)

			# start a box2d world
			@world = new b2World(new b2Vec2(0, 30), true)

			super

		createBody: (bodyDef, fixDef) ->
			body = @world.CreateBody(bodyDef).CreateFixture(fixDef).GetBody()
			return body

		removeBody: (body) ->
			@world.DestroyBody(body)

		setGravity: (x, y) ->
			@world.SetGravity(new b2Vec2(x, y))

		start: () ->
			requestAnimFrame @update
			@dispatch("gameStarted")

		log: (message) ->
			#@el.innerHTML += "<br />" +  message

		update: () =>
			requestAnimFrame @update
			@world.Step(1 / 60, 10, 10)
			@renderer.render(@stage)

	return DOMtra

			