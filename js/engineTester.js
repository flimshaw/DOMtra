require.config({
	shim: {
		"jquery-1.9.1.min": {
			exports: '$'
		}
	},
	baseUrl: 'js/vendor'
});

require(
	[
		'jquery-1.9.1.min',
		'DOMtra'
	],
	function($, DOMtra) {

		$(document).ready(function() {

			window.DOMtra = new DOMtra();

		});

	}
);