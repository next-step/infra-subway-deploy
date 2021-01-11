const path = require('path')

const outputPath = path.resolve(__dirname, '../src/main/resources/static')

module.exports = {
  mode: 'production',
  output: {
    path: outputPath,
    filename: '[name].js'
  }
}
