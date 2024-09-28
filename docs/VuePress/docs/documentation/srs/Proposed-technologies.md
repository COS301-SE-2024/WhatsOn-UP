# Technology choices(NEEDS TO BE UPDATED)

| Use case | Proposed technology/framework |
| :---- | :---- |
| Front-end | Flutter   |
| Backend | SpringBoot (Kotlin) & NestJS |
| Database | Supabase PostgreSQL |
| Hosting | Google Cloud Platform |
| Version Control | Git with Github and Docker |
| Team Organization | T-Metric  and Github Kanban Boards  |
| Testing  | J-Unit, Flutter’s built-in testing library and,Mockito |
| Documentation | Google Docs, Markdown and VuePress |
| CI-CD | Github actions |

# 

# 

# Proposed Technologies Deep Dive 

### 

**Front-End Development: Flutter**

Reasoning: Flutter offers several advantages for mobile app development:

* Reduced Development Time: A single code base for both Android and iOS platforms saves time and resources.  
  * Native-like Performance: Utilises Dart for a smooth and responsive user experience.  
  * Visually Appealing UI: Provides a rich set of widgets for building an engaging interface.  
  * Rapid Development Cycles: Hot reload functionality allows for near-instantaneous updates on the device.

Benefits for WhatsOn@UP: Flutter's features make it ideal for creating a visually engaging and preformant application for both Android and iOS users, catering to a wider audience within the university community.

**Back-End Development: SpringBoot with Kotlin**

Reasoning: Spring Boot with Kotlin is chosen for its robust, scalable, and secure framework, leveraging:

* Performance:  High performance and efficient resource management.  
  * Security:  Built-in robust security features to protect user data.  
  * Scalability: Spring Boot,Kotlin can handle a growing user base with its asynchronous nature  and integrates well with cloud services.  
  * Security: Built-in robust security features to protect user data.

Benefits for WhatsOn@UP: Spring Boot with Kotlin enables efficient event management, high performance, robust security, and scalability for the growing user base.

**Database: PostgreSQL**

Reasoning: PostgreSQL is a powerful and flexible relational database:

* Open-Source: Freely available and widely adopted, with a large community for support.  
  * ACID Compliance: Ensures data integrity and consistency, crucial for event data management.  
  * Scalability: Can handle a growing amount of event data as the app gains users.

Benefits for WhatsOn@UP: PostgreSQL provides a robust foundation for storing and managing event data, user information, and other application-specific details reliably.

**Hosting: Amazon Web Services (AWS)**

Reasoning: AWS is a leading cloud platform that offers a wide range of services:

* Scalability: Easily scale resources (storage, computing power) as user base and data storage needs grow.  
  * Reliability: AWS provides high availability and disaster recovery features to ensure app uptime.  
  * Security: Offers robust security features to protect user data and application integrity.

Benefits for WhatsOn@UP: AWS ensures a reliable and secure infrastructure for hosting our WhatsOn@UP application, allowing it to adapt to future growth and user demands.

**Version Control: Git with GitHub and Docker**

Reasoning: Version control and containerization are essential for efficient development:

* Git: Tracks code changes, enabling collaboration and rollback if needed.  
  * GitHub: Popular platform for hosting Git repositories, facilitating code sharing and collaboration.  
  * Docker: Creates containerized environments, ensuring consistent development, testing, and deployment across machines.

Benefits for WhatsOn@UP: Git and GitHub streamline code management and collaboration, while Docker guarantees a consistent coding and deployment environment throughout the development process.

**Team Organization: Trello and/or GitHub Boards**

      Reasoning: Project management tools help organise tasks and communication:

* Trello: Simple and visual Kanban board system for task management and progress tracking.  
  * GitHub Boards: Integrated with Git repositories, offering basic Kanban functionality within the familiar GitHub environment.

Benefits for WhatsOn@UP: Trello or GitHub Boards provide a flexible approach for task management and team communication, allowing us to adapt to our preferred workflow.

**Testing: JUnit**

Reasoning: JUnit is a widely-used testing framework for Java with the following benefits:

* Robust Framework: Offers a comprehensive set of annotations and assertions for writing and running repeatable tests.  
  * Integration: Seamlessly integrates with build tools like Maven and Gradle, as well as CI/CD pipelines.  
  * Extensibility: Supports extension frameworks such as JUnit 5 extensions for custom behaviours.  
  * Community Support: Large community and extensive documentation, providing a wealth of resources and plugins.


  * Fast: Provides fast test execution for rapid feedback during development.

Benefits for WhatsOn@UP: JUnit helps us ensure the reliability and correctness of our backend services written in Kotlin. By writing unit tests and integration tests, we can validate the functionality of individual components and their interactions, catching bugs early in the development cycle.

**Testing: Flutter’s Built-in Testing Library**

Reasoning: JFlutter’s built-in testing library offers a suite of testing tools designed specifically for Flutter applications:

* Unit Testing: Allows testing of individual components (functions, methods, classes) to ensure they work as expected.  
  * Integration Testing: Provides tools to test the complete app or large parts of it, verifying that all pieces work together.  
  * Widget Testing: Enables testing of Flutter widgets, ensuring the UI behaves correctly.

Benefits for WhatsOn@UP: Flutter’s built-in testing library helps us maintain high code quality for the mobile app. By leveraging unit, widget, and integration tests, we can ensure the app's functionality, UI/UX, and performance meet the expected standards, leading to a smooth and reliable user experience. 

**Documentation: Google Docs and Markdown**

Reasoning: Choosing the right documentation tool depends on the type and complexity of information:

* Google Docs: Ideal for collaborative creation and editing of project documentation.Offers clear formatting options and ease of use for various documentation types (user guides, design documents).  
* Markdown: Well-suited for simpler documentation like code comments, API references, or short READMEs. Lightweight and integrates easily with code repositories like GitHub.

Benefits for WhatsOn@UP: This combination allows us to leverage the strengths of both tools. Google Docs facilitates collaborative creation of comprehensive documentation, while Markdown can be used for concise code-related documentation or READMEs within the project repository.

**CI/CD: GitHub Actions and AWS CodeDeploy**

       Reasoning: Automating builds, testing, and deployments streamlines development:

GitHub Actions: Free built-in CI/CD workflows within GitHub repositories. Ideal for simpler deployments and triggering automated tests upon code pushes.

AWS CodeDeploy: Service for automating deployments to servers or containers on AWS. Integrates well with other AWS services for a comprehensive CI/CD pipeline.

Benefits for WhatsOn@UP: This combination provides a cost-effective and scalable approach to CI/CD. We can utilise GitHub Actions for initial automation and graduate to AWS CodeDeploy for more complex deployments as the project matures.
