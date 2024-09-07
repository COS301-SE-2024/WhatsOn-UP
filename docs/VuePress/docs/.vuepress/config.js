import { viteBundler } from '@vuepress/bundler-vite'
import { defaultTheme } from '@vuepress/theme-default'
import { defineUserConfig } from 'vuepress'

export default defineUserConfig({
  bundler: viteBundler(),
  theme: defaultTheme({
    logo: "/images/Logo.png",
    navbar: [
      {
        text: 'Home',
        link: '/',
      },
      {
        text: 'Documentation',
        link: '/',
      },
      {
        text: 'Meet The Team',
        link: '/',
      },
      {
        text: 'GitHub',
        link: 'https://github.com/COS301-SE-2024/WhatsOn-UP',
      },
    ],
  }),
})