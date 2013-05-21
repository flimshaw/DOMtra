require.config({
	shim: {
		"vendor/jquery-1.9.1.min": {
			exports: '$'
		},
		"vendor/underscore": {
			exports: '_'
		},
		"vendor/Box2dWeb-2.1.a.3": {
			exports: "Box2D"
		},
		"vendor/pixi.dev": {
			exports: "PIXI"
		}
	}
});

require(
	[
		'vendor/jquery-1.9.1.min',
		'vendor/pixi.dev',
		'bin/DOMtra'
	],
	function($, PIXI, DOMtra) {

		$(document).ready(function() {

			// create a new DOMtra instance
			var m_DOMtra = new DOMtra();




			// create an new instance of a pixi stage
			var stage = new PIXI.Stage(0x66FF99);
			
			// create a renderer instance
			var renderer = PIXI.autoDetectRenderer(window.innerWidth, window.innerHeight, null);
			
			// add the renderer view element to the DOM
			document.body.appendChild(renderer.view);
			
			requestAnimFrame( animate );
			
			// create a texture from an image path
			var texture = PIXI.Texture.fromImage("images/brick.gif");
			// create a new Sprite using the texture

			var bunnies = []

			var bunnyCount = 10000;

			for(var i = 0; i < bunnyCount; i++) {



				bunnies.push(new PIXI.Sprite(texture));
			
				var bunny = bunnies[bunnies.length - 1]

				// center the sprites anchor point
				bunny.anchor.x = 0.5;
				bunny.anchor.y = 0.5;
				
				// move the sprite t the center of the screen
				bunny.position.x = Math.random() * window.innerWidth;
				bunny.position.y = Math.random() * window.innerHeight;
				bunny.rotationSpeed = Math.random() * .4;
				
				stage.addChild(bunny);
			}

			
			function animate() {
			
			    requestAnimFrame( animate );
			
			    // just for fun, lets rotate mr rabbit a little
			    for(var i = 0; i < bunnyCount; i++) {
			    	bunnies[i].rotation += bunnies[i].rotationSpeed;
			    }
				
			    // render the stage   
			    renderer.render(stage);
			}


		});


	}
);