define [], () ->

	class Actor
		constructor: (id) ->

			# receive our ID from the actorFactory
			@id = id

			# setup default status variables
			@y = 0
			@x = 0
			@height = 32
			@width = 64

			@collisionOffset = 15
			@frameDelay = 10
			@frameCounter = 0
			@currentFrame = 0
			@animations = {
				default: [0,0]
			}
			
			@currentAnimation = "default"
			@sheetWidth = 5
			
			# run our setup function
			@setup()

		setAnimation: (animation) ->
			newAnimation = animation + @currentDir
			if newAnimation != @currentAnimation
				@currentAnimation = animation + @currentDir
				@currentFrame = -1
				@frameCounter = @frameDelay

		animate: () ->
			animations = {
				"standRight": [0, 0],
				"standLeft": [5, 5],
				"walkRight": [1, 4],
				"walkLeft": [6, 9],
				"jumpRight": [20, 20],
				"jumpLeft": [25, 25]
			}

			if(@currentFrame == -1)
				@currentFrame = @animations[@currentAnimation][0]

			@frameCounter++
			if(@frameCounter >= @frameDelay)
				@frameCounter = 0
				@currentFrame++
				if(@currentFrame > @animations[@currentAnimation][1])
					@currentFrame = @animations[@currentAnimation][0]

				frameX = -(@width * (@currentFrame % @sheetWidth)) + "px"
				frameY = -(@height * Math.floor(@currentFrame / @sheetWidth)) + "px"
				$(@el).css('background-position', frameX + " " + frameY)

		setup: () ->
			# create a div and append it 
			@el = document.createElement("div")
			@el.setAttribute("id", @id)
			@el.style.background = "url(" + @SPRITESHEET_DIR + @spriteSheet + ")"
			@el.style.backgroundRepeat = "no-repeat";
			@el.style.position = "absolute";
			@el.style.top = "0px;"
			@el.style.width = @width + "px";
			@el.style.height = @height + "px";
			document.body.appendChild(@el)

			@customSetup()

		customSetup: () ->
			return true

		move: () ->
			@x += @xVel;
			@y += @yVel;
			@el.style.top = @y + "px";
			@el.style.left = @x + "px";

		update: () ->
			@move()
			@animate()


	return Actor