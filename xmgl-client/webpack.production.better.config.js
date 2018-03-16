const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const CaseSensitivePathsPlugin = require('case-sensitive-paths-webpack-plugin');
const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const config = {
    entry: {
        index: __dirname + "/app/views/main.js",
        home: __dirname + "/app/views/home.js",
        oa: __dirname + "/app/views/oa.js",
        tp: __dirname + "/app/views/tp.js",
        permission: __dirname + "/app/views/permission.js",
        demo: __dirname + "/app/views/demo.js",
        base_config:__dirname + "/app/views/common_link.js",
        serve_api:__dirname + "/app/views/common_link.js",
        work_log:__dirname + "/app/views/common_link.js",
        user_center:__dirname + "/app/views/common_link.js",
        project:__dirname + "/app/views/common_link.js",
        employee:__dirname + "/app/views/common_link.js",
        message:__dirname + "/app/views/common_link.js",
        eureka:__dirname + "/app/views/common_link.js",
        vendor: ['react', 'react-dom', 'react-router', 'antd', 'mirrorx']
    },
    output: {
        path: __dirname + "/dist",
        filename: "[name].[hash].js",
        chunkFilename: '[id].chunk.js'
    },
    devtool: 'false',
    resolve: {
        extensions: ['.js', '.jsx']
    },
    module: {
        rules: [
            {
                test: /(\.jsx|\.js)$/,
                use: {
                    loader: "babel-loader"
                },
                exclude: /node_modules/
            }, {
                test: /\.scss$|\.css$/,
                use: ExtractTextPlugin.extract({
                    fallback: 'style-loader',
                    use: ['css-loader', 'sass-loader']
                })
            }, {
                test: /\.json$/,
                loader: 'json-loader'
            }, {
                test: /\.(ttf|eot|svg|woff(2)?)(\?[a-z0-9=&.]+)?$/,
                loader: 'file-loader'
            }
        ]
    },
    plugins: [
        new webpack.DefinePlugin({
            'process.env': {
                NODE_ENV: JSON.stringify('production')
            }
        }),
        new webpack.BannerPlugin('南京全高信息科技有限公司 @2017 create by cuiwei'),
        new webpack
            .optimize
            .CommonsChunkPlugin({
                name: 'vendor',
                minChunks: function (module, count) {
                    const resource = module.resource
                    // 以 .css 结尾的资源，重复 require 大于 1 次
                    return resource && /\.css$/.test(resource) && count > 1
                }
            }),
        new webpack.NamedModulesPlugin(),
        new webpack.HotModuleReplacementPlugin(),
        new CaseSensitivePathsPlugin(),
        new webpack
            .optimize
            .OccurrenceOrderPlugin(),
        new webpack
            .optimize
            .UglifyJsPlugin({
                output: {
                    comments: false
                },
                compress: {
                    warnings: false
                }
            }),
        new ExtractTextPlugin('[name].[hash].css'),
        new OptimizeCssAssetsPlugin({
            cssProcessor: require('cssnano'),
            cssProcessorOptions: {
                discardComments: {
                    removeAll: true
                }
            },
            canPrint: true
        })
    ]
}
var entries = config.entry;
for (var name in entries) {
    if (name === 'vendor') 
        continue;
    let plugin = new HtmlWebpackPlugin({
        template: __dirname + "/app/templates/index.tmpl.html",
        filename: name + '.html',
        inject: 'body',
        hash: true,
        chunks: ['vendor', name],
        minify: { //压缩HTML文件
            removeComments: true, //移除HTML中的注释
            collapseWhitespace: false //删除空白符与换行符
        }
    })
    config
        .plugins
        .push(plugin)
}
module.exports = config;