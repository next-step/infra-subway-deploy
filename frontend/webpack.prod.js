const path = require('path')
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;

const outputPath = path.resolve(__dirname, '../src/main/resources/static')

module.exports = {
  mode: 'production',
  output: {
    path: outputPath,
    filename: '[name].js'
  },
  plugins : [
    new BundleAnalyzerPlugin()
  ]
}
