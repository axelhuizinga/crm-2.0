const localConf = require('./webpack.local');
const devHost = localConf.ip;

const path = require('path');

const buildMode = process.env.NODE_ENV || 'development';
const buildTarget = process.env.TARGET || 'web';

const isProd = buildMode === 'production';

const sourcemapsMode = isProd ? 'hidden-source-map':'eval-source-map' ;

// Plugins
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const useFriendly = true;
const FriendlyErrorsWebpackPlugin = require('friendly-errors-webpack-plugin');
//const haxeFormatter = require('haxe-loader/errorFormatter');
//const haxeTransformer = require('haxe-loader/errorTransformer');

//const  = new ExtractTextPlugin('app.css');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
// Options
const debugMode = buildMode !== 'production';
const dir = __dirname;
const dist = __dirname + "../httpdocs/";
console.log(dist);
// Sourcemaps: https://webpack.js.org/configuration/devtool/
// - 'eval-source-map': fast, but JS bundle is somewhat obfuscated
// - 'source-map': slow, but JS bundle is readable
// - undefined: no map, and JS bundle is readable
console.log('isProd:' + isProd);
//
// Configuration:
// This configuration is still relatively minimalistic;
// each section has many more options
//
module.exports = {
    // List all the JS modules to create
    // They will all be linked in the HTML page
    entry: {
        app: './build.hxml'
    },
    mode: buildMode,
    // Generation options (destination, naming pattern,...)
    output: {
        path: dist,
        filename: 'app.js',
	publicPath: '/'
    },
    // Module resolution options (alias, default paths,...)
    resolve: {
	    modules: [path.resolve(dir, 'res/scss'), 'node_modules'],
        extensions: ['.js', '.json']
    },
    // Sourcemaps option for development
    devtool: sourcemapsMode,
    // Live development server (serves from memory)
    devServer: {
        contentBase: dist,
        compress: true,
	host:  devHost,
	https: true,
        port: 9000,
        overlay: true,
        hot: true,  
        inline: true,
        headers: {
            "Access-Control-Allow-Origin": "https://pitverwaltung.de",
            "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, PATCH, OPTIONS",
            "Access-Control-Allow-Headers": "X-Requested-With, content-type, Authorization"
		},	    
	watchOptions:{
		aggregateTimeout:1500
	},	    
	historyApiFallback: {
	      index: 'crm.html',
            rewrites:[
            {from: '/', to: '/crm.html'}
            ]
        }
    },
    //watch: true,    
	watchOptions:{
		aggregateTimeout:1500,
		//poll: 1500
	},    
    
    // List all the processors
    module: {
        rules: [
            // Haxe loader (through HXML files for now)
            {
                test: /\.hxml$/,
                loader: 'haxe-loader',
                options: {
                    // Additional compiler options added to all builds
                    extra: '-D build_mode=' + buildMode,
                    debug: debugMode
                }
            },
            // Static assets loader
            // - you will need to adjust for webfonts
            // - you may use 'url-loader' instead which can replace
            //   small assets with data-urls
            {
                test: /\.(gif|png|jpg|svg)$/,
                loader: 'file-loader',
                options: {
                    name: '[name].[hash:7].[ext]'
                }
            },
	    {
                test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/, 
                loader: 'file-loader'
	    },
	    {
                test:  /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/, 
		    loader: "url-loader?limit=10000&mimetype=application/font-woff" 
	    },	    
            // CSS processor/loader
            // - this is where you can add sass/less processing,
            // - also consider adding postcss-loader for autoprefixing
            {
                test: /\.(sa|sc|c)ss$/,
                use: [
                !isProd ? 'style-loader' : MiniCssExtractPlugin.loader,
                'css-loader',
                'sass-loader',
                ]
            }
        ]
    },
    // Plugins can hook to the compiler lifecycle and handle extra tasks
    plugins: [
	new MiniCssExtractPlugin({
		// Options similar to the same options in webpackOptions.output
		// both options are optional
		filename: !isProd ? '[name].css' : '[name].[hash].css',
		chunkFilename: !isProd ? '[id].css' : '[id].[hash].css',
	}),
        // HMR: enable globally
        new webpack.HotModuleReplacementPlugin(),
        // HMR: prints more readable module names in the browser console on updates
        new webpack.NamedModulesPlugin(),
        // HMR: do not emit compiled assets that include errors
        new webpack.NoEmitOnErrorsPlugin(),

        // Like generating the HTML page with links the generated JS files
        new HtmlWebpackPlugin({
            filename: isProd ? 'crm.php' : 'crm.html',
            template: isProd ? 'crm.php' : 'crm.html',
            title: 'Xpress CRM 2.0'
        })
        // You may want to also:
        // - minify/uglify the output using UglifyJSPlugin,
        // - extract the small CSS chunks into a single file using ExtractTextPlugin
        // - avoid modules duplication using CommonsChunkPlugin
        // - inspect your JS output weight using BundleAnalyzerPlugin
    ].concat(useFriendly ? [
		new FriendlyErrorsWebpackPlugin({
			compilationSuccessInfo: {
				messages: [
					`Your application is running here: https://${devHost}:${9000}`
				]
			},
			//additionalTransformers: [haxeTransformer],
			//additionalFormatters: [haxeFormatter]
		})
	] : [])
	//.concat(isProd ? [extractCSS] : []),
};
