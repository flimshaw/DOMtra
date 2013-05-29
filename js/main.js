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
		},
		"vendor/zepto.min": {
			exports: "$"
		}
	},
	paths: {
		"DOMtra": 'bin/DOMtra'
	}
});

require(
	[
		'vendor/jquery-1.9.1.min',
		'DOMtra',
		'bin/LevelBoxes',
		'bin/LevelFlimshaw'
	],
	function($, DOMtra, LevelBoxes, LevelFlimshaw) {

		$(document).ready(function() {

			// create a new DOMtra instance
			window.DOMtra = new DOMtra();

			window.DOMtra.loadLevel(new LevelFlimshaw());

			window.DOMtra.start();

		});


	}
);