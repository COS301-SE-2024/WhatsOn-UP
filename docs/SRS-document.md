# Temp

**DevForce**

COS 301

University of Pretoria

# WhatsOn@UP SRS Document

**Contact:** [devforce.capstone@gmail.com](mailto:devforce.capstone@gmail.com)

[Important Links	2](https://docs.google.com/document/d/1Ja-Ev1ghWPG8koCJdV99sALttg2e2dUh/edit#heading=h.9tfgzuurgt0a)

[Introduction	3](#Introduction)

[Class Diagram	6](https://docs.google.com/document/d/1Ja-Ev1ghWPG8koCJdV99sALttg2e2dUh/edit#heading=h.3rdcrjn)

[User Stories	7](https://docs.google.com/document/d/1Ja-Ev1ghWPG8koCJdV99sALttg2e2dUh/edit#heading=h.alyvrqomu9h3)

[Functional Requirements	9](https://docs.google.com/document/d/1Ja-Ev1ghWPG8koCJdV99sALttg2e2dUh/edit#heading=h.imbblc9y3gzw)

[Quality Requirements	12](https://docs.google.com/document/d/1Ja-Ev1ghWPG8koCJdV99sALttg2e2dUh/edit#heading=h.lx81q1slxzx)

[Service Contracts	13](https://docs.google.com/document/d/1Ja-Ev1ghWPG8koCJdV99sALttg2e2dUh/edit#heading=h.qtihvzf2bjq2)

[Description	13](https://docs.google.com/document/d/1Ja-Ev1ghWPG8koCJdV99sALttg2e2dUh/edit#heading=h.xo699ohe700f)

[**User Management	13**](https://docs.google.com/document/d/1Ja-Ev1ghWPG8koCJdV99sALttg2e2dUh/edit#heading=h.xg0h4wl50i67)

[General Request Format	13](https://docs.google.com/document/d/1Ja-Ev1ghWPG8koCJdV99sALttg2e2dUh/edit#heading=h.5urjexmaywqx)

[Register User	14](https://docs.google.com/document/d/1Ja-Ev1ghWPG8koCJdV99sALttg2e2dUh/edit#heading=h.9z1xnugjsitj)

[Login User	16](https://docs.google.com/document/d/1Ja-Ev1ghWPG8koCJdV99sALttg2e2dUh/edit#heading=h.actqqxvnt7mi)

[**Event Management	17**](https://docs.google.com/document/d/1Ja-Ev1ghWPG8koCJdV99sALttg2e2dUh/edit#heading=h.yioe8t6etyfz)

[**Get upcoming events	17**](https://docs.google.com/document/d/1Ja-Ev1ghWPG8koCJdV99sALttg2e2dUh/edit#heading=h.qp7i10yvl3ys)

[Get saved events	20](https://docs.google.com/document/d/1Ja-Ev1ghWPG8koCJdV99sALttg2e2dUh/edit#heading=h.elay7rylgnuf)

[Architectural Patterns	23](https://docs.google.com/document/d/1Ja-Ev1ghWPG8koCJdV99sALttg2e2dUh/edit#heading=h.1ksv4uv)

[Proposed Technologies	25](https://docs.google.com/document/d/1Ja-Ev1ghWPG8koCJdV99sALttg2e2dUh/edit#heading=h.44sinio)

[Proposed Technologies Deep Dive	26](https://docs.google.com/document/d/1Ja-Ev1ghWPG8koCJdV99sALttg2e2dUh/edit#heading=h.2jxsxqh)

[Choosing the Right Tools for the Job	26](https://docs.google.com/document/d/1Ja-Ev1ghWPG8koCJdV99sALttg2e2dUh/edit#heading=h.z337ya)

[Project Development Methodology	31](https://docs.google.com/document/d/1Ja-Ev1ghWPG8koCJdV99sALttg2e2dUh/edit#heading=h.3j2qqm3)

[Proactive Planning:Addressing Key Considerations for WhatsOn@UP Development	32](https://docs.google.com/document/d/1Ja-Ev1ghWPG8koCJdV99sALttg2e2dUh/edit#heading=h.3whwml4)

[Wow Factor 32](#wow-factor)

### 

### **Important Links**

Repository: [COS301-SE-2024/WhatsOn-UP (github.com)](https://github.com/COS301-SE-2024/WhatsOn-UP)

Demo 1 Slides: [Slides](https://www.canva.com/design/DAGGsKNb6aU/W8v3NKotCxBJOJauO8_IrA/)

Wireframes:[Wireframes](https://drive.google.com/file/d/1qSlPJPVNYl5rjaByyzo5KBY_vjX_63GY/view?usp=drive_link)

Testing Documentation: [Testing Documentation](https://docs.google.com/document/d/1SfIxE-KDSOgc1vl41UrfoCZFlWVLJbdIIYWA4zPoOc0/edit?usp=drive_link)

Technologies Research: [Technologies Research](https://docs.google.com/document/d/1i5oyOKCl6RR43fGU84T-jpH3FCVdWkCGCwjNLkaaPE4/edit?usp=drive_link)

Github Ruleset Research: [CI/CD - Google Docs](https://docs.google.com/document/d/1Ig4SYOKnw4ZOrzP6SjYiHuW31lKe9OM7teOcSr8CBp4/edit#heading=h.lt3dnkdyw0h7)

Coding Standards Documentation:[Coding Standards](https://docs.google.com/document/d/1_oVeZqWZemT3urwrFUN708oN37bDlg5WAx-VP4TaVw4/edit?usp=drive_link)
### **Introduction**

Students often miss out on enriching experiences beyond academics due to the difficulty in finding and managing various campus events. Current methods rely on scattered sources, making it challenging for students and even university guests to stay informed and involved. The proposed WhatsOn@UP software system aims to be the central hub for all events happening at the University of Pretoria, with the vision of expanding to encompass other universities at a later stage.

Imagine a centralized hub where all university events are readily discoverable. Students and guests can effortlessly browse public events or search for specific interests using clear filters. Need to navigate to an event? A built-in map ensures you remain on course. Adding events to your personal calendar? Just a single tap keeps you organized. The aim is to design an intuitive and user-friendly application that puts all the information users need at their fingertips.

Behind the scenes, our developers will not only prioritize a user-friendly experience but also ensure robust security measures are built in to safeguard the university's integrity and reputation. We, as DevForce, are invested in the initiative to revolutionize the way students engage with their university communities.

**Objectives**:

The high-level objectives for the WhatsOn@UP project are:

1. **Centralised Event Management:**

Develop a comprehensive mobile application to serve as a central hub for all events at the University of Pretoria, ensuring ease of event discovery and participation for students and guests.

1. **Enhanced User Engagement:**

Increase engagement with campus events by providing an intuitive interface that allows users to browse, search, and filter events based on their interests.

1. **Seamless Navigation and Calendar Integration:**

Integrate a built-in navigation system to help users easily locate event venues and ensure seamless integration with personal calendar applications (e.g. Google Calendar) for streamlined event management.

1. **User-Friendly Experience:**

Focus on creating an intuitive and user-friendly application that is accessible to all users, regardless of their technical proficiency, to promote frequent usage and engagement.

1. **Robust Security Measures:**

Implement strong security protocols to protect user data, including secure authentication, data encryption, and role-based access control to prevent unauthorised access and safeguard the university’s reputation.

1. **Scalability and Future Expansion:**

Design the application with scalability in mind, allowing for future expansion to other universities and the addition of new features and functionalities as needed.

1. **Personalised Event Recommendations:**

Utilise data analytics to analyse user behaviour and preferences, providing personalised event recommendations to enhance user experience and event participation.

1. **Community Building:**

Foster a vibrant and interactive university culture by promoting events and facilitating community engagement through features like event invitations, RSVPs, and notifications.

1. **Big Data Analytics**:

Incorporate big data analytics to generate insights and trends on user engagement and event popularity, helping event organisers to optimise event planning and logistics.

1. **Notification and Communication Features:**

Provide users with notifications about upcoming events, changes to events they are interested in, and invitations to private events, ensuring they stay informed and connected.

Using modern mobile application technology, WhatsOn@UP aims to revolutionise the way students and guests interact with university events. By creating a centralised, secure, and user-friendly platform, the project seeks to enhance campus life and build a stronger university community. The scope of WhatsOn@UP includes developing a cross-platform mobile application using Flutter, with a backend implemented in Spring Boot, Kotlin and a PostgreSQL database. The system will be hosted on  AWS to ensure scalability and reliability.

[https://lh7-us.googleusercontent.com/lMpeIAivzL2MNmdeCcyCC2gWJS1wFjjsqaeWh9Zhis95AteWLHHWzd9kIlDaPqfxz_Iwe86xpJoJ4dkQD8A-Q9GU5mzIE0kifTURESOPgd4RfR2KuBeIvnsWt7V-N-fsyZkmR6Hp7y5VhCVEY_jv6g](https://lh7-us.googleusercontent.com/lMpeIAivzL2MNmdeCcyCC2gWJS1wFjjsqaeWh9Zhis95AteWLHHWzd9kIlDaPqfxz_Iwe86xpJoJ4dkQD8A-Q9GU5mzIE0kifTURESOPgd4RfR2KuBeIvnsWt7V-N-fsyZkmR6Hp7y5VhCVEY_jv6g)

### **Class Diagram**

### 

[https://lh7-us.googleusercontent.com/FY4iko2oUsYKor1ih_nTeVUE1tBWVVM5KIhGzpx9r-FC2VRY3HC9XF1K45II2Il8z23aWlg4iWhBX_jJ1ZuM6VC4IiVwujZyuQ-w_7sBHE7hgeBZeNa9SxJ43OucGvld_bm38xPuJKzF](https://lh7-us.googleusercontent.com/FY4iko2oUsYKor1ih_nTeVUE1tBWVVM5KIhGzpx9r-FC2VRY3HC9XF1K45II2Il8z23aWlg4iWhBX_jJ1ZuM6VC4IiVwujZyuQ-w_7sBHE7hgeBZeNa9SxJ43OucGvld_bm38xPuJKzF)

### **User Stories**

1. **As a Guest User:**

1.1  I can browse public events on the WhatsOn@UP platform without needing to create an account.

1.2 I can utilise search and filter functionalities to find events of interest based on categories, dates, and locations.

1.3 I can view detailed information about each event, including its name, description, date, time, and location.

1.4 I can use the built-in map feature to navigate to event venues.

1.5 I can add public events to my personal calendar directly from the app.

1. **As a General User:**

**2.1**  I can register an account with WhatsOn@UP using my email address, google or social media login credentials.

2.2 I can log into the WhatsOn@UP system using my registered email and password.

2.3 I can search for and view public events on the platform.

2.4 I can add events to my personal calendar and manage my event schedule.

2.5 I can RSVP to private events if invited by the host.

1. **As a Host User:**

**3.1**  I can create new events by providing details such as event name, description, date, time, location, and category (public or private).

3.2 I can edit and manage events I have created, including updating event details and cancelling events if necessary.

3.3 I can invite users to private events by sending them event invitations.

3.4 I can view RSVPs and manage attendee lists for private events.

3.5 I can access analytics and insights about my hosted events, such as attendance rates and user engagement metrics.

1. **As an Admin User:**

**4.1**  I can manage user accounts within the WhatsOn@UP system, including creating, editing, and deleting user profiles.

4.2 I can review and approve event requests submitted by host users before they are published on the platform.

4.3 I can monitor all events within the WhatsOn@UP system and ensure compliance with platform guidelines and policies.

4.4 I can manage system settings and configurations, including security settings, notification preferences, and feature toggles.

4.5 I can generate reports and analytics on user engagement, event trends, and system usage for strategic planning and decision-making purposes.

### **Functional Requirements**

**Use Case Diagram**

[https://lh7-us.googleusercontent.com/lMpeIAivzL2MNmdeCcyCC2gWJS1wFjjsqaeWh9Zhis95AteWLHHWzd9kIlDaPqfxz_Iwe86xpJoJ4dkQD8A-Q9GU5mzIE0kifTURESOPgd4RfR2KuBeIvnsWt7V-N-fsyZkmR6Hp7y5VhCVEY_jv6g](https://lh7-us.googleusercontent.com/lMpeIAivzL2MNmdeCcyCC2gWJS1wFjjsqaeWh9Zhis95AteWLHHWzd9kIlDaPqfxz_Iwe86xpJoJ4dkQD8A-Q9GU5mzIE0kifTURESOPgd4RfR2KuBeIvnsWt7V-N-fsyZkmR6Hp7y5VhCVEY_jv6g)

[https://lh7-us.googleusercontent.com/_dMP9pwtKx2uywkWPh1e1dz8BhejRxNneNYhBMaQRf4p4yCYwxj9HWlqzZa4MY3H6aDdMo3bFDcsXHjMEDLp0Kddv4HbrRCidR9CajyRs5jZ87wmb0U2rES1uP8Wtr5tDsQoi2TH-nkMscTQ3j28iA](https://lh7-us.googleusercontent.com/_dMP9pwtKx2uywkWPh1e1dz8BhejRxNneNYhBMaQRf4p4yCYwxj9HWlqzZa4MY3H6aDdMo3bFDcsXHjMEDLp0Kddv4HbrRCidR9CajyRs5jZ87wmb0U2rES1uP8Wtr5tDsQoi2TH-nkMscTQ3j28iA)

**Requirements implemented for Demo 1** 							 Technical Requirements

1. **User Registration, Authentication, and Access Control:**
    1. Users should be able to log into their accounts.
    2. Users should be able to create new accounts.
    3. Users should be able to view some parts of the app without creating or signing into an account.
    4. User should be assigned roles (Guest, General, Host, Admin):
        1. Users should only be able to access specific features and content based on their assigned roles.
        2. Admin users should be able to grant/revoke Host status to General users.
2. **Create, Edit, Delete, RSVP Events:**
    1. Host and Admin users should be able to manage events:
        1. Host and Admin users should be able to create new events.
        2. Host and Admin users should be able to edit existing events.
        3. Host and Admin users should be able to delete existing events.
    2. General, Host and Admin users should be able to add public events to their calendars.
    3. Host and Admin users should be able to invite specific users to a private event.
3. **Discovering and browsing events:**
    1. Users should be able to discover new events based on their interests.
    2. Users should be able to search for events.
    3. Users should be able to filter events.

Non-technical Requirements

1. **The app should be user-friendly:**
    1. The design should maintain a consistent layout and navigation structure.
    2. The design should be visually appealing.

**Subsystems**

1. User Registration and Authentication Subsystem
2. User Management Subsystem
3. Event Management Subsystem
4. Calendar Integration Subsystem
5. Navigation and Mapping Subsystem
6. Notification Subsystem Subsystem
7. Analytics and Recommendations Subsystem

### **Quality Requirements**

1. **Usability**:
    1. The application should have an intuitive user interface, easy navigation, and clear event categorization to ensure users can quickly find and engage with events of interest.
    2. Strategies:
        1. Intuitive and simple layout that allows for easy navigation between different pages.
2. **Performance**:
    1. The application should respond quickly to user interactions, with fast loading times for event listings, calendar views, and navigation features.
    2. Strategies:
        1. Make use of CDNs to ensure low latency regardless of the user’s location.
        2. Make use of caching to ensure quick loading times.
3. **Security**:
    1. User data should be securely stored and transmitted, with measures in place to prevent unauthorised access, data breaches, and malicious activities.
    2. Strategies:
        1. Make use of token-based authorisation and use 2FA for authentication.
4. **Accessibility**:
    1. The application should be accessible to users with disabilities.
    2. Strategies:
        1. The application must be screen reader friendly.
        2. Comply to WCAG guidelines
5. **Scalability**:
    1. The application infrastructure should be able to handle increasing numbers of users and events without degradation in performance or reliability.
    2. Strategies:
        1. Using auto scaling groups in cloud environments.
        2. Incoming traffic should be distributed evenly across server instances.
            
            [https://lh7-us.googleusercontent.com/ryUiPHUNpGeIjZ4bxe_Vse9TXlTFmt-uijE08GfLm8fCku-UWWIqd_UD1O2LoXqK6Z__7nlkkTT7riIb0T_RjdYwaj5nDlkYEe4sP-ht6rrfv6LPOJyd78P6ySCF7D1rQ55OFzV2vWzVCLaG6b-5ng](https://lh7-us.googleusercontent.com/ryUiPHUNpGeIjZ4bxe_Vse9TXlTFmt-uijE08GfLm8fCku-UWWIqd_UD1O2LoXqK6Z__7nlkkTT7riIb0T_RjdYwaj5nDlkYEe4sP-ht6rrfv6LPOJyd78P6ySCF7D1rQ55OFzV2vWzVCLaG6b-5ng)
            

### **Service Contracts**


### **Architectural Patterns**

1. **Service-Oriented Architecture (SOA):**

WhatsOn@UP is expected to handle various functionalities like event search, user management, and push notifications. SOA allows us to decompose the application into independent, reusable services. This approach offers:

- Scalability: Individual services can be scaled independently based on their needs. For example, the event search service can be scaled up during peak usage times without impacting other services like user management.
- Security: Fine-grained access controls can be implemented at the service level, ensuring only authorised users or applications can access specific functionalities. This enhances security by limiting access points to sensitive data.
- Interoperability: Services can be designed with standardised APIs that can be accessed by different technologies and platforms. This allows for easier integration with other systems.
1. **Enterprise Service Bus (ESB):**

To ensure reliable and secure communication as the number of services in WhatsOn@UP grows, an Enterprise Service Bus (ESB) acts as a central hub, facilitating data exchange between services. This ESB implementation offers several key benefits:

- Scalability: The ESB efficiently routes messages even when services are spread across multiple servers, ensuring WhatsOn@UP functions smoothly.
- Security: The ESB enforces security measures like message encryption and authentication to protect data exchanged between services.
- Performance: The ESB manages asynchronous communication between services, improving user interface responsiveness by not blocking the UI while services retrieve data from each other.

**3. Model-View-Controller (MVC):**

MVC is a well-established pattern that separates the application logic (Model) from the user interface (View) and the data binding between them (Controller). This separation promotes:

- Usability: Developers can focus on building a robust model and efficient data handling, leading to a more maintainable and user-friendly application in the long run.
- Performance: MVC allows for optimised UI rendering and data handling techniques, contributing to better overall application performance.

By implementing these architecture patterns, WhatsOn@UP can achieve the desired level of scalability, security, usability, and performance.

### **Proposed Technologies**

The technology stack outlined in this proposal represents our recommendation based on our technical expertise and understanding of project requirements. We are open to discussing alternative solutions or specific preferences you might have for the development tools and frameworks. As final-year students, we're constantly eager to learn new technologies and frameworks, so don't hesitate to suggest changes or discuss options.

| Use case | Proposed technology/framework |
| --- | --- |
| Frontend | Flutter |
| Backend | SpringBoot, Kotlin |
| Database | PostgreSQL |
| Hosting | Amazon Web Services (AWS) |
| Version Control | Git with Github and Docker |
| Team Organization | Trello  and Github Boards |
| Testing | J-Unit and Flutter’s built-in testing library |
| Documentation | Google docs and Markdown |
| CI-CD | Github actions and AWS CodeDeploy |

# Proposed Technologies Deep Dive

### **Choosing the Right Tools for the Job**

**Front-End Development: Flutter**

Reasoning: Flutter offers several advantages for mobile app development:

- Reduced Development Time: A single codebase for both Android and iOS platforms saves time and resources.
- Native-like Performance: Utilises Dart for a smooth and responsive user experience.
- Visually Appealing UI: Provides a rich set of widgets for building an engaging interface.
- Rapid Development Cycles: Hot reload functionality allows for near-instantaneous updates on the device.

Benefits for WhatsOn@UP: Flutter's features make it ideal for creating a visually engaging and performant application for both Android and iOS users, catering to a wider audience within the university community.

**Back-End Development: SpringBoot with Kotlin**

Reasoning: Spring Boot with Kotlin is chosen for its robust, scalable, and secure framework, leveraging:

- Performance: High performance and efficient resource management.
- Security: Built-in robust security features to protect user data.
- Scalability: Spring Boot,Kotlin can handle a growing user base with its asynchronous nature and integrates well with cloud services.
- Security: Built-in robust security features to protect user data.

Benefits for WhatsOn@UP: Spring Boot with Kotlin enables efficient event management, high performance, robust security, and scalability for the growing user base.

**Database: PostgreSQL**

Reasoning: PostgreSQL is a powerful and flexible relational database:

- Open-Source: Freely available and widely adopted, with a large community for support.
- ACID Compliance: Ensures data integrity and consistency, crucial for event data management.
- Scalability: Can handle a growing amount of event data as the app gains users.

Benefits for WhatsOn@UP: PostgreSQL provides a robust foundation for storing and managing event data, user information, and other application-specific details reliably.

**Hosting: Amazon Web Services (AWS)**

Reasoning: AWS is a leading cloud platform that offers a wide range of services:

- Scalability: Easily scale resources (storage, computing power) as user base and data storage needs grow.
- Reliability: AWS provides high availability and disaster recovery features to ensure app uptime.
- Security: Offers robust security features to protect user data and application integrity.

Benefits for WhatsOn@UP: AWS ensures a reliable and secure infrastructure for hosting our WhatsOn@UP application, allowing it to adapt to future growth and user demands.

**Version Control: Git with GitHub and Docker**

Reasoning: Version control and containerization are essential for efficient development:

- Git: Tracks code changes, enabling collaboration and rollback if needed.
- GitHub: Popular platform for hosting Git repositories, facilitating code sharing and collaboration.
- Docker: Creates containerized environments, ensuring consistent development, testing, and deployment across machines.

Benefits for WhatsOn@UP: Git and GitHub streamline code management and collaboration, while Docker guarantees a consistent coding and deployment environment throughout the development process.

**Team Organization: Trello and/or GitHub Boards**

Reasoning: Project management tools help organise tasks and communication:

- Trello: Simple and visual Kanban board system for task management and progress tracking.
- GitHub Boards: Integrated with Git repositories, offering basic Kanban functionality within the familiar GitHub environment.

Benefits for WhatsOn@UP: Trello or GitHub Boards provide a flexible approach for task management and team communication, allowing us to adapt to our preferred workflow.

**Testing: JUnit**

Reasoning: JUnit is a widely-used testing framework for Java with the following benefits:

- Robust Framework: Offers a comprehensive set of annotations and assertions for writing and running repeatable tests.
- Integration: Seamlessly integrates with build tools like Maven and Gradle, as well as CI/CD pipelines.
- Extensibility: Supports extension frameworks such as JUnit 5 extensions for custom behaviours.
- Community Support: Large community and extensive documentation, providing a wealth of resources and plugins.
- Fast: Provides fast test execution for rapid feedback during development.

Benefits for WhatsOn@UP: JUnit helps us ensure the reliability and correctness of our backend services written in Kotlin. By writing unit tests and integration tests, we can validate the functionality of individual components and their interactions, catching bugs early in the development cycle.

**Testing: Flutter’s Built-in Testing Library**

Reasoning: JFlutter’s built-in testing library offers a suite of testing tools designed specifically for Flutter applications:

- Unit Testing: Allows testing of individual components (functions, methods, classes) to ensure they work as expected.
- Integration Testing: Provides tools to test the complete app or large parts of it, verifying that all pieces work together.
- Widget Testing: Enables testing of Flutter widgets, ensuring the UI behaves correctly.

Benefits for WhatsOn@UP: Flutter’s built-in testing library helps us maintain high code quality for the mobile app. By leveraging unit, widget, and integration tests, we can ensure the app's functionality, UI/UX, and performance meet the expected standards, leading to a smooth and reliable user experience.

**Documentation: Google Docs and Markdown**

Reasoning: Choosing the right documentation tool depends on the type and complexity of information:

- Google Docs: Ideal for collaborative creation and editing of project documentation.Offers clear formatting options and ease of use for various documentation types (user guides, design documents).
- Markdown: Well-suited for simpler documentation like code comments, API references, or short READMEs. Lightweight and integrates easily with code repositories like GitHub.

Benefits for WhatsOn@UP: This combination allows us to leverage the strengths of both tools. Google Docs facilitates collaborative creation of comprehensive documentation, while Markdown can be used for concise code-related documentation or READMEs within the project repository.

**CI/CD: GitHub Actions and AWS CodeDeploy**

Reasoning: Automating builds, testing, and deployments streamlines development:

GitHub Actions: Free built-in CI/CD workflows within GitHub repositories. Ideal for simpler deployments and triggering automated tests upon code pushes.

AWS CodeDeploy: Service for automating deployments to servers or containers on AWS. Integrates well with other AWS services for a comprehensive CI/CD pipeline.

Benefits for WhatsOn@UP: This combination provides a cost-effective and scalable approach to CI/CD. We can utilise GitHub Actions for initial automation and graduate to AWS CodeDeploy for more complex deployments as the project matures.

[https://lh7-us.googleusercontent.com/XDCCqU_NaNa0uT9OPaXTqXQetpz1O-TWZahfSDuShai0yc8hNYjEel_LzfZ4nhlj_CylpmS8mdcKF6ZajZerGer8kcg1vlITtY9Fv-80lHqNXk8lm1FOJ7b-OhDyWkclyiX6nkYSf0JEkFkaPoJN_A](https://lh7-us.googleusercontent.com/XDCCqU_NaNa0uT9OPaXTqXQetpz1O-TWZahfSDuShai0yc8hNYjEel_LzfZ4nhlj_CylpmS8mdcKF6ZajZerGer8kcg1vlITtY9Fv-80lHqNXk8lm1FOJ7b-OhDyWkclyiX6nkYSf0JEkFkaPoJN_A)

### **Project Development Methodology**

Our team will be using the Agile Process which focuses primarily on the implementation of the system, where just enough, digestible documentation is provided to keep all stakeholders on the same page. This process will be used alongside the Scrum Methodology in order to deliver customer value, remain flexible to any changes, and maintain transparency with stakeholders.

As such, the development process will be broken up into 2-week sprints where a minimum viable product will be produced. In these two weeks, we will have short daily stand-up meetings (daily Scrums) to report progress and voice any concerns in order to ensure consistent progress. Before such a sprint, tasks will be taken from the Product Backlog (produced from the MVP being broken up into features) based on story points assigned to such tasks - as opposed to using fixed time-block estimation.

During a given sprint, backlog refinement will be performed to ensure that features wanted by the customer and needed by the client are efficiently prioritised. This will be done to help organise and plan upcoming sprints.

After each 2-week period, there will be a Sprint Retrospection where what worked, what did not work, and what should be changed for future sprints will all be evaluated.

# Proactive Planning:Addressing Key Considerations for WhatsOn@UP Development

1. **Prioritizing User Experience (UX):**

Creating an intuitive and user-friendly experience is paramount for WhatsOn@UP's success.  To achieve this, we plan to conduct usability testing sessions throughout the development process.  These sessions, involving students on campus, will allow us to identify and address any usability issues early on.  Furthermore, we'll integrate in-app tutorials to guide new users through the app's functionalities.  We'll also adopt an iterative design process, where user feedback from testing sessions is actively incorporated to continuously improve the overall UX.  Additionally, we will explore A/B testing different design elements and functionalities to see which ones resonate best with users.

1. **Enabling Offline Functionality:**

We understand the importance of ensuring the app functions even when users are offline.  To address this challenge, we plan to implement caching mechanisms. This will allow the app to store frequently accessed event data, such as upcoming events or saved favorites, for offline use.  Even when offline, users will still be able to browse saved events, view details of previously accessed events, or utilize basic filtering options.

1. **Guaranteeing Security:**

Security is a top priority for WhatsOn@UP.  We plan to address this by utilizing secure data storage solutions, including encrypted databases and user authentication mechanisms.  Furthermore, we'll follow secure coding best practices to minimize vulnerabilities and stay updated on the latest security threats.  To proactively identify and address potential security weaknesses, we will also consider conducting penetration testing during development.

1. **Ensuring Accessibility:**

We are committed to making WhatsOn@UP accessible to all users, including those with disabilities.  To achieve this, we'll strive for conformance with the Web Content Accessibility Guidelines (WCAG).  This will ensure features like screen reader compatibility, high-contrast themes, and appropriate text sizing are implemented within the app.  Additionally, we'll utilize accessibility testing tools to identify and fix any accessibility issues that might arise throughout development.

1. **Maintaining Performance and Scalability:**

As the WhatsOn@UP user base and data volume grow, it's crucial to maintain optimal performance and scalability.  We plan to address this by implementing code optimization techniques throughout development.  Additionally, we'll choose a scalable cloud-based hosting platform, such as AWS, that can handle increasing user traffic and data storage needs.   Finally, we'll employ continuous performance monitoring to identify any potential bottlenecks and ensure smooth app performance for all users.
# WOW Factor
## Augmented Reality
Augmented reality (AR) navigation is a new technology that helps people find their way by showing directions on their device's screen, like a smartphone or a headset. It combines real-time location data with virtual information to make navigation easier and more intuitive. Instead of having to look at a map and compare it to the real world, AR navigation overlays directions directly onto what you see through your device's camera.
Here's how indoor AR navigation works in three simple steps:

- Finding Your Location: First, the system figures out where you are inside the building. This is the hardest part.
Planning the Route: Next, it creates a path from where you are (point A) to where you want to go (point B).
- Displaying Directions: Finally, it shows virtual directions on your screen, on top of the real-world view.
The last two steps are quite straightforward. The real challenge is accurately finding your current location inside the building. 

## Unity MARS 
Unity MARS (Mixed and Augmented Reality Studio) is a powerful tool that enhances the development of augmented reality (AR) applications by providing an intuitive, robust framework for creating context-aware AR experiences. Here’s how Unity MARS can help with AR navigation:

Unity MARS allows developers to create AR applications that understand and interact with the real world in a contextual manner. For AR navigation, this means the application can accurately interpret the environment, identify landmarks, and provide relevant navigational cues based on the user's surroundings.

Unity MARS includes tools for precise environment mapping, which is crucial for AR navigation. It can create detailed spatial maps of the environment, allowing for accurate placement of navigation markers and routes. This ensures that virtual navigation aids align perfectly with the physical world.

Unity MARS supports geolocation and anchoring, allowing navigation applications to use GPS data and anchor virtual objects to specific physical locations. This feature is critical for outdoor navigation, enabling users to follow routes and find destinations accurately.

Unity MARS provides a scalable framework that can handle various levels of complexity in AR navigation projects. Whether it’s a simple indoor navigation system for a museum or a comprehensive city-wide navigation app, Unity MARS can be customized to meet specific project requirements.

