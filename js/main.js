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
		}
	}
});

require(
	[
		'vendor/jquery-1.9.1.min',
		'bin/DOMtra'
	],
	function($, DOMtra) {

		$(document).ready(function() {

			// create a new DOMtra instance
			var m_DOMtra = new DOMtra();

			// create a bunch of platforms
			for(var i = 0; i < 26; i++) {
				a = m_DOMtra.createActor('Actor', { x: i * 50, y: 410, height: 16, width: 16 })
			}
			
			// make a little particle system that spawns new boxes
			m_DOMtra.customUpdate = function() {
				var minSize = 10;
				var maxSize = 20;
				var maxParticles = 100;
				if(this.actorManager.actors.length < maxParticles) {
					this.createActor('Actor', { x: Math.random() * document.width, y: Math.random() * 100 * -1, height: Math.random() * maxSize + minSize, width: Math.random() * maxSize + minSize, dynamic: true, rotation: true })
				}		
			}

			m_DOMtra.start();

		});


	}
);