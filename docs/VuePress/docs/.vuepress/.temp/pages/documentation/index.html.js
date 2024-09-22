import comp from "C:/Users/khany/Documents/GitHub/WhatsOn-UP/docs/VuePress/docs/.vuepress/.temp/pages/documentation/index.html.vue"
const data = JSON.parse("{\"path\":\"/documentation/\",\"title\":\"Documentation\",\"lang\":\"en-US\",\"frontmatter\":{\"title\":\"Documentation\"},\"headers\":[{\"level\":2,\"title\":\"Sections\",\"slug\":\"sections\",\"link\":\"#sections\",\"children\":[]},{\"level\":2,\"title\":\"Getting Started\",\"slug\":\"getting-started\",\"link\":\"#getting-started\",\"children\":[]}],\"git\":{\"updatedTime\":1726359177000,\"contributors\":[{\"name\":\"zdanise\",\"email\":\"zetdanise89@gmail.com\",\"commits\":1}]},\"filePathRelative\":\"documentation/index.md\"}")
export { comp, data }

if (import.meta.webpackHot) {
  import.meta.webpackHot.accept()
  if (__VUE_HMR_RUNTIME__.updatePageData) {
    __VUE_HMR_RUNTIME__.updatePageData(data)
  }
}

if (import.meta.hot) {
  import.meta.hot.accept(({ data }) => {
    __VUE_HMR_RUNTIME__.updatePageData(data)
  })
}
