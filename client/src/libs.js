//
// npm dependencies library
//
(function(scope) {
	'use-strict';
	scope.__registry__ = Object.assign({}, scope.__registry__, {

		// list npm modules required in Haxe		
		'flatpickr': require('flatpickr'),
		'history': require('history'),
		'react': require('react'),
		'react-bulma-components': require('react-bulma-components'),		
		//'react-data-grid': require('react-data-grid'),		
		'react-flatpickr': require('react-flatpickr'),
		'react-intl': require('react-intl'),
		
		'react-number-format': require('react-number-format'),		
		'react-dom': require('react-dom'),
		'react-router-dom': require('react-router-dom'),

		'react-router': require('react-router'),
		'react-paginate': require('react-paginate'),
		'prop-types': require('prop-types'),
		'redux': require('redux'),		
		'react-redux': require('react-redux'),
		'sprintf-js': require('sprintf-js')
	});

	if (process.env.NODE_ENV !== 'production') {
		// enable hot-reload
		require('haxe-modular');
	}

})(typeof $hx_scope != "undefined" ? $hx_scope : $hx_scope = {});
