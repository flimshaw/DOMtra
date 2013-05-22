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

			// create a bunch of platforms
			for(var i = 0; i < 5; i++) {
				a = m_DOMtra.createActor('PlatformActor', { width: 192, height: 32, x: (window.innerWidth * .9) * Math.random(), y: i * 100 + 300 })
			}

			m_DOMtra.customUpdate = function() {
				var maxParticles = 2000;
				if(this.actorManager.actors.length < maxParticles) {
					for(var x = 0; x < 1; x++) {
						m_DOMtra.createActor('ActorPixiHero', { width: 34, height: 52, x: window.innerWidth * Math.random(), y: -80 })
					}
				}
			}

			m_DOMtra.start();

			window.DOMtra = m_DOMtra;

			var stage = m_DOMtra.world.stage



		});


	}
);