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
		'bin/Game'
	],
	function($, Game) {

		$(document).ready(function() {

			// create a new DOMtra instance
			var DOMtra = new Game();

			window.DOMtra = DOMtra;

			DOMtra.addEventListener("gameStarted", function(data) {
				console.log(data);
			});

			DOMtra.start();

		});

	}
);