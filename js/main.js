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
			for(var i = 0; i < 3; i++) {
				a = m_DOMtra.createActor('PlatformActor', { x: (window.innerWidth / 2) * Math.random() + (window.innerWidth / 4) - 64, y: i * 250 + 100 })
			}

			// make a little particle system that spawns new boxes
			m_DOMtra.customUpdate = function() {
				var maxParticles = 50;
				if(this.actorManager.actors.length < maxParticles) {
					this.createActor('EnemyTurtleActor', { x: Math.random() * document.width, y: -50 })
				}
			}

			m_DOMtra.start();

		});


	}
);