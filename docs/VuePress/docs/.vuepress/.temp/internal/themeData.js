export const themeData = JSON.parse("{\"logo\":\"/images/Logo.png\",\"navbar\":[{\"text\":\"Home\",\"link\":\"/\"},{\"text\":\"Documentation\",\"link\":\"/documentation/\"},{\"text\":\"Meet The Team\",\"link\":\"/\"},{\"text\":\"Demo\",\"children\":[{\"text\":\"Demo 1 Docs\",\"link\":\"/demo/demo1.md\"},{\"text\":\"Demo 2 Docs\",\"link\":\"/demo/demo2.md\"},{\"text\":\"Demo 3 Docs\",\"link\":\"/demo/demo3.md\"},{\"text\":\"Demo 4 Docs\",\"link\":\"/demo/demo4.md\"}]},{\"text\":\"GitHub\",\"link\":\"https://github.com/COS301-SE-2024/WhatsOn-UP\"}],\"sidebar\":{\"/documentation/architecture/\":[{\"text\":\"Architectural Document\",\"children\":[{\"text\":\"Introduction\",\"link\":\"/documentation/architecture/introduction.html\"},{\"text\":\"Quality Requirements\",\"link\":\"/documentation/architecture/quality-requirements.html\"},{\"text\":\"Architectural Patterns\",\"link\":\"/documentation/architecture/architectural-patterns.html\"},{\"text\":\"Architectural Design Strategies\",\"link\":\"/documentation/architecture/architectural-design-strategies.html\"},{\"text\":\"Architectural Constraints\",\"link\":\"/documentation/architecture/architectural-constraints.html\"},{\"text\":\"Architectural Structure\",\"link\":\"/documentation/architecture/architectural-structure.html\"},{\"text\":\"Deployment Diagram\",\"link\":\"/documentation/architecture/deployment-diagram.html\"}]}]},\"locales\":{\"/\":{\"selectLanguageName\":\"English\"}},\"colorMode\":\"auto\",\"colorModeSwitch\":true,\"repo\":null,\"selectLanguageText\":\"Languages\",\"selectLanguageAriaLabel\":\"Select language\",\"sidebarDepth\":2,\"editLink\":true,\"editLinkText\":\"Edit this page\",\"lastUpdated\":true,\"lastUpdatedText\":\"Last Updated\",\"contributors\":true,\"contributorsText\":\"Contributors\",\"notFound\":[\"There's nothing here.\",\"How did we get here?\",\"That's a Four-Oh-Four.\",\"Looks like we've got some broken links.\"],\"backToHome\":\"Take me home\",\"openInNewWindow\":\"open in new window\",\"toggleColorMode\":\"toggle color mode\",\"toggleSidebar\":\"toggle sidebar\"}")

if (import.meta.webpackHot) {
  import.meta.webpackHot.accept()
  if (__VUE_HMR_RUNTIME__.updateThemeData) {
    __VUE_HMR_RUNTIME__.updateThemeData(themeData)
  }
}

if (import.meta.hot) {
  import.meta.hot.accept(({ themeData }) => {
    __VUE_HMR_RUNTIME__.updateThemeData(themeData)
  })
}
