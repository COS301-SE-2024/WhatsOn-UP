export const redirects = JSON.parse("{}")

export const routes = Object.fromEntries([
  ["/", { loader: () => import(/* webpackChunkName: "index.html" */"C:/Users/khany/Documents/GitHub/WhatsOn-UP/docs/VuePress/docs/.vuepress/.temp/pages/index.html.js"), meta: {"title":"Hello world"} }],
  ["/documentation/", { loader: () => import(/* webpackChunkName: "documentation_index.html" */"C:/Users/khany/Documents/GitHub/WhatsOn-UP/docs/VuePress/docs/.vuepress/.temp/pages/documentation/index.html.js"), meta: {"title":"Documentation"} }],
  ["/documentation/architecture/architectural-constraints.html", { loader: () => import(/* webpackChunkName: "documentation_architecture_architectural-constraints.html" */"C:/Users/khany/Documents/GitHub/WhatsOn-UP/docs/VuePress/docs/.vuepress/.temp/pages/documentation/architecture/architectural-constraints.html.js"), meta: {"title":""} }],
  ["/documentation/architecture/architectural-design-strategies.html", { loader: () => import(/* webpackChunkName: "documentation_architecture_architectural-design-strategies.html" */"C:/Users/khany/Documents/GitHub/WhatsOn-UP/docs/VuePress/docs/.vuepress/.temp/pages/documentation/architecture/architectural-design-strategies.html.js"), meta: {"title":""} }],
  ["/documentation/architecture/architectural-patterns.html", { loader: () => import(/* webpackChunkName: "documentation_architecture_architectural-patterns.html" */"C:/Users/khany/Documents/GitHub/WhatsOn-UP/docs/VuePress/docs/.vuepress/.temp/pages/documentation/architecture/architectural-patterns.html.js"), meta: {"title":""} }],
  ["/documentation/architecture/architectural-structure.html", { loader: () => import(/* webpackChunkName: "documentation_architecture_architectural-structure.html" */"C:/Users/khany/Documents/GitHub/WhatsOn-UP/docs/VuePress/docs/.vuepress/.temp/pages/documentation/architecture/architectural-structure.html.js"), meta: {"title":""} }],
  ["/documentation/architecture/deployment-diagram.html", { loader: () => import(/* webpackChunkName: "documentation_architecture_deployment-diagram.html" */"C:/Users/khany/Documents/GitHub/WhatsOn-UP/docs/VuePress/docs/.vuepress/.temp/pages/documentation/architecture/deployment-diagram.html.js"), meta: {"title":""} }],
  ["/documentation/architecture/", { loader: () => import(/* webpackChunkName: "documentation_architecture_index.html" */"C:/Users/khany/Documents/GitHub/WhatsOn-UP/docs/VuePress/docs/.vuepress/.temp/pages/documentation/architecture/index.html.js"), meta: {"title":"Architectural Document"} }],
  ["/documentation/architecture/introduction.html", { loader: () => import(/* webpackChunkName: "documentation_architecture_introduction.html" */"C:/Users/khany/Documents/GitHub/WhatsOn-UP/docs/VuePress/docs/.vuepress/.temp/pages/documentation/architecture/introduction.html.js"), meta: {"title":""} }],
  ["/documentation/architecture/quality-requirements.html", { loader: () => import(/* webpackChunkName: "documentation_architecture_quality-requirements.html" */"C:/Users/khany/Documents/GitHub/WhatsOn-UP/docs/VuePress/docs/.vuepress/.temp/pages/documentation/architecture/quality-requirements.html.js"), meta: {"title":""} }],
  ["/404.html", { loader: () => import(/* webpackChunkName: "404.html" */"C:/Users/khany/Documents/GitHub/WhatsOn-UP/docs/VuePress/docs/.vuepress/.temp/pages/404.html.js"), meta: {"title":""} }],
]);

if (import.meta.webpackHot) {
  import.meta.webpackHot.accept()
  if (__VUE_HMR_RUNTIME__.updateRoutes) {
    __VUE_HMR_RUNTIME__.updateRoutes(routes)
  }
  if (__VUE_HMR_RUNTIME__.updateRedirects) {
    __VUE_HMR_RUNTIME__.updateRedirects(redirects)
  }
}

if (import.meta.hot) {
  import.meta.hot.accept(({ routes, redirects }) => {
    __VUE_HMR_RUNTIME__.updateRoutes(routes)
    __VUE_HMR_RUNTIME__.updateRedirects(redirects)
  })
}
