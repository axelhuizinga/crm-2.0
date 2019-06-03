const localConf = require('./webpack.local');
const devHost = localConf.ip;
const devServerHttps = localConf.devServerHttps;
const fs = require('fs');
const path = require('path');

const buildMode = process.env.NODE_ENV || 'development';
const buildTarget = process.env.TARGET || 'web';

const isProd = buildMode === 'production';

const sourcemapsMode = isProd ? undefined :'cheap-module-source-map' ;

// Plugins
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
//const MiniCssExtractPlugin = require('mini-css-extract-plugin');
// Options
const debugMode = buildMode !== 'production';
const dir = __dirname;
const dist = path.join(__dirname, "/../httpdocs");
//const dist = path.resolve(__dirname, "./httpdocs");
console.log('Output Directory:' + dist);
console.log(`projectDirectory:${dir} isProd:`+ isProd +  ` debugMode:${debugMode}`);
//
// Configuration:
// This configuration is still relatively minimalistic;
// each section has many more options
//
module.exports = {
   // context: __dirname,
    // List all the JS modules to create
    // They will all be linked in the HTML page
    entry: {
        app: './build.hxml'
    },
  // "info-verbosity":'verbose',
    mode: buildMode,
    // Generation options (destination, naming pattern,...)
    output: {
        path: dist,
        filename: 'app.js',
	//publicPath: dist
	publicPath: '/'
	//publicPath: 'https://192.168.178.20:9000/'
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
        //public:'https://'+devHost+':9000',
         //contentBase: './httpdocs/', //gives me directory listing in the browser
        contentBase: dist,
        compress: true,
        host:  devHost,
        https:{
            key: fs.readFileSync(path.resolve(__dirname, localConf.key)),
            cert: fs.readFileSync(path.resolve(__dirname, localConf.cert)),
        },
        port: 9000,
        overlay: false,
        lazy: false,
        hot:true,
        disableHostCheck: true,
        //inline: false,
        //useLocalIp: true,
        headers: {
            "Access-Control-Allow-Origin": "https://pitverwaltung.de",
            "Access-Control-Allow-Origin": "*",
	        "Access-Control-Allow-Credentials":true,
            "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, PATCH, OPTIONS",
            "Access-Control-Allow-Headers": "X-Requested-With, content-type, Authorization"
		},	       
	    historyApiFallback: {
            index: '/'
        },
	index: 'crm.html',
	staticOptions:{
		index:false
	},
	//publicPath: __dirname + '../httpdocs/'
	publicPath: '/',
		// Accepted values: none, errors-only, minimal, normal, detailed, verbose
		// Any other falsy value will behave as 'none', truthy values as 'normal'	
	stats: {}
    },
    watch: true,    
	watchOptions:{
		//aggregateTimeout:1500,
		ignored: ['httpdocs']
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
                    debug: debugMode,
                    logCommand: true,
                    watch: ['.']
                }
            },
            // Static assets loader
            // - you will need to adjust for webfonts
            // - you may use 'url-loader' instead which can replace
            //   small assets with data-urls
            {
                test: /\.(sa|sc|c)ss$/,
                use: [                
                'style-loader',
                'css-loader',
                'sass-loader'
                ]
            },
            {
                test: /\.(ttf|eot|svg|png|woff(2)?)(\?[a-z0-9]+)?$/,
                use: [{
                  loader: 'file-loader', options: {name: '.../webfont/[name].[ext]'}
                }]
              }
           // {
            //    test: /\.svg$/,
	///	loader: 'svg-inline-loader'
           // }
        ]
    },
    // Plugins can hook to the compiler lifecycle and handle extra tasks
    plugins: [
        // HMR: enable globally
        new webpack.HotModuleReplacementPlugin(),
        // HMR: prints more readable module names in the browser console on updates
        new webpack.NamedModulesPlugin(),
        // HMR: do not emit compiled assets that include errors
        new webpack.NoEmitOnErrorsPlugin(),
        // Like generating the HTML page with links the generated JS files  template: resolve(__dirname, 'src/public', 'index.html'),
        new HtmlWebpackPlugin({
            filename: (isProd ? 'crm.php' : 'crm.html'),
            template: path.resolve(__dirname, 'res/'+(isProd ? 'crm.php' : 'crm.html')),
            title: 'Xpress CRM 2.0'
        })
    ]
};
