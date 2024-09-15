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
        link: '/documentation/',
      },
      {
        text: 'Meet The Team',
        link: '/',
      },
      {
        text: 'Demo',
        children: [
          {
            text: 'Demo 1 Docs',
            link: '/demo/demo1.md',
          },
          {
            text: 'Demo 2 Docs',
            link: '/demo/demo2.md',
          },
          {
            text: 'Demo 3 Docs',
            link: '/demo/demo3.md',
          },
          {
            text: 'Demo 4 Docs',
            link: '/demo/demo4.md',
          },
        ],
      },
      {
        text: 'GitHub',
        link: 'https://github.com/COS301-SE-2024/WhatsOn-UP',
      },
    ],
    sidebar: {
      '/documentation/architecture/': [
        {
          text: 'Architectural Document',
          children: [
            {
              text: 'Introduction',
              link: '/documentation/architecture/introduction.html',
            },
            {
              text: 'Quality Requirements',
              link: '/documentation/architecture/quality-requirements.html',
            },
            {
              text: 'Architectural Patterns',
              link: '/documentation/architecture/architectural-patterns.html',
            },
            {
              text: 'Architectural Design Strategies',
              link: '/documentation/architecture/architectural-design-strategies.html',
            },
            {
              text: 'Architectural Constraints',
              link: '/documentation/architecture/architectural-constraints.html',
            },
            {
              text: 'Architectural Structure',
              link: '/documentation/architecture/architectural-structure.html',
            },
            {
              text: 'Deployment Diagram',
              link: '/documentation/architecture/deployment-diagram.html',
            },
          ],
        },
      ],
      // '/documentation/srs/': [
      //   {
      //     text: 'SRS Document',
      //     children: [
      //       {
      //         text: 'Introduction',
      //         link: '/documentation/srs/introduction.html',
      //       },
      //       {
      //         text: 'Requirements',
      //         link: '/documentation/srs/requirements.html',
      //       },
      //       {
      //         text: 'Use Cases',
      //         link: '/documentation/srs/use-cases.html',
      //       },
      //     ],
      //   },
      // ],
      // '/documentation/design/': [
      //   {
      //     text: 'Design Document',
      //     children: [
      //       {
      //         text: 'System Architecture',
      //         link: '/documentation/design/system-architecture.html',
      //       },
      //       {
      //         text: 'Component Design',
      //         link: '/documentation/design/component-design.html',
      //       },
      //       {
      //         text: 'Data Flow',
      //         link: '/documentation/design/data-flow.html',
      //       },
      //     ],
      //   },
      // ],
    },
  }),
})