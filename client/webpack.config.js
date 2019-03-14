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

// Options
const debugMode = buildMode !== 'production';
const dir = __dirname;
const dist = path.join(__dirname, "httpdocs");
console.log(dist);
console.log('projectDirectory:${dir} isProd:' + isProd + ' debugMode:${debugMode}');
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
        //public:'https://'+devHost+':9000',
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
        useLocalIp: true,
        headers: {
            "Access-Control-Allow-Origin": "https://pitverwaltung.de",
            "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, PATCH, OPTIONS",
            "Access-Control-Allow-Headers": "X-Requested-With, content-type, Authorization"
		},	       
	    historyApiFallback: {
	      index: 'crm.html',
            rewrites:[
            {from: '/', to: '/crm.html'}
            ]
        }
    },
    watch: true,    
	watchOptions:{
		aggregateTimeout:1500
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
            {
                test: /\.(sa|sc|c)ss$/,
                use: [                
                'style-loader',
                'css-loader',
                'sass-loader'
                ]
            }
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

        // Like generating the HTML page with links the generated JS files
        new HtmlWebpackPlugin({
            filename: isProd ? 'crm.php' : 'crm.html',
            template: isProd ? 'crm.php' : 'crm.html',
            title: 'Xpress CRM 2.0'
        })
    ]
};
