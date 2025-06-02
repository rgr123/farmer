const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    port: 8080,
    proxy: {
      '/api': {
        target: 'http://localhost:9090',  // 后端接口地址
        changeOrigin: true
        // pathRewrite 不需要，因为 /api 前缀你后端也用了
      }
    }
  },
  chainWebpack: config => {
    config.plugin('html')
      .tap(args => {
        args[0].title = "中国助农扶贫网";
        return args;
      })
  }
})
