const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const CaseSensitivePathsPlugin = require('case-sensitive-paths-webpack-plugin');
const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin');
module.exports = {
    // entry: [     "babel-polyfill", __dirname + "/app/main.js" ],
    entry: __dirname + "/app/main.js",
    output: {
        path: __dirname + "/dist", //打包后的文件存放的地方
        filename: "bundle.[hash].js" //打包后输出文件的文件名
    },
    devtool: 'false',
    devServer: {
        contentBase: "./public", //本地服务器所加载的页面所在的目录
        historyApiFallback: true,
        inline: true,
        port: 3000,
        // host : '192.168.117.133',
        proxy: {
            '/auth/**': {
                target: 'http://192.168.117.177:9999',
                changeOrigin: true,
                secure: false
            },
            '/api/**': {
                target: 'http://192.168.117.177:9999',
                changeOrigin: true,
                secure: false
            }
        }
    },
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
        new HtmlWebpackPlugin({
            template: __dirname + "/app/index.tmpl.html"
        }),
        // new webpack.optimize.CommonsChunkPlugin({     name: "vendor",     filename:
        // "vendor.js", }),
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
        new ExtractTextPlugin('[hash].css'),
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