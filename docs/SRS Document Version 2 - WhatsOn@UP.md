**DevForce**  
COS 301  
University of Pretoria

# WhatsOn@UP

## **Contact:** [devforce.capstone@gmail.com](mailto:devforce.capstone@gmail.com)

[Important Links	2](#important-links)

[Introduction	3](#introduction)

[Class Diagram	6](#class-diagram)

[User Stories	7](#user-stories)

[Functional Requirements	9](#functional-requirements)

[Quality Requirements	12](#quality-requirements)

[Service Contracts	13](#service-contracts)

[Description	13](#description)

[**User Management	13**](#user-management)

[General Request Format	13](#heading=h.5urjexmaywqx)

[Register User	13](#register-user)

[Login User	15](#login-user)

[**Event Management	16**](#event-management)

[**Get upcoming events	17**](#heading=h.qp7i10yvl3ys)

[Get saved events	19](#get-saved-events)

[Architectural Patterns	22](#architectural-patterns)

[Proposed Technologies	24](#proposed-technologies)

[Proposed Technologies Deep Dive	25](#proposed-technologies-deep-dive)

[Choosing the Right Tools for the Job	25](#choosing-the-right-tools-for-the-job)

[Project Development Methodology	30](#project-development-methodology)

[Proactive Planning:Addressing Key Considerations for WhatsOn@UP Development	32](#proactive-planning:addressing-key-considerations-for-whatson@up-development)

[Appendix	34](#appendix)

[User Characteristics	39](#user-characteristics)

#### **Important Links** {#important-links}

Repository: [COS301-SE-2024/WhatsOn-UP (github.com)](https://github.com/COS301-SE-2024/WhatsOn-UP) 

Demo 1 Slides: [https://www.canva.com/design/DAGGsKNb6aU/W8v3NKotCxBJOJauO8\_IrA/](https://www.canva.com/design/DAGGsKNb6aU/W8v3NKotCxBJOJauO8_IrA/)

Wireframes:[https://drive.google.com/file/d/1qSlPJPVNYl5rjaByyzo5KBY\_vjX\_63GY/view?usp=drive\_link](https://drive.google.com/file/d/1qSlPJPVNYl5rjaByyzo5KBY_vjX_63GY/view?usp=drive_link) 

Testing Documentation: [https://docs.google.com/document/d/1SfIxE-KDSOgc1vl41UrfoCZFlWVLJbdIIYWA4zPoOc0/edit?usp=drive\_link](https://docs.google.com/document/d/1SfIxE-KDSOgc1vl41UrfoCZFlWVLJbdIIYWA4zPoOc0/edit?usp=drive_link) 

Technologies Research: [https://docs.google.com/document/d/1i5oyOKCl6RR43fGU84T-jpH3FCVdWkCGCwjNLkaaPE4/edit?usp=drive\_link](https://docs.google.com/document/d/1i5oyOKCl6RR43fGU84T-jpH3FCVdWkCGCwjNLkaaPE4/edit?usp=drive_link) 

Github Ruleset Research: [CI/CD \- Google Docs](https://docs.google.com/document/d/1Ig4SYOKnw4ZOrzP6SjYiHuW31lKe9OM7teOcSr8CBp4/edit#heading=h.lt3dnkdyw0h7)

#### 

#### 

#### **Introduction** {#introduction}

Students often miss out on enriching experiences beyond academics due to the difficulty in finding and managing various campus events. Current methods rely on scattered sources, making it challenging for students and even university guests to stay informed and involved. The proposed WhatsOn@UP software system aims to be the central hub for all events happening at the University of Pretoria, with the vision of expanding to encompass other universities at a later stage.

Imagine a centralized hub where all university events are readily discoverable. Students and guests can effortlessly browse public events or search for specific interests using clear filters. Need to navigate to an event? A built-in map ensures you remain on course. Adding events to your personal calendar? Just a single tap keeps you organized. The aim is to design an intuitive and user-friendly application that puts all the information users need at their fingertips.

Behind the scenes, our developers will not only prioritize a user-friendly experience but also ensure robust security measures are built in to safeguard the university's integrity and reputation. We, as DevForce, are invested in the initiative to revolutionize the way students engage with their university communities.

**Objectives**:

The high-level objectives for the WhatsOn@UP project are:

1. **Centralised Event Management:**

   Develop a comprehensive mobile application to serve as a central hub for all events at the University of Pretoria, ensuring ease of event discovery and participation for students and guests.

2. **Enhanced User Engagement:**

   Increase engagement with campus events by providing an intuitive interface that allows users to browse, search, and filter events based on their interests.

3. **Seamless Navigation and Calendar Integration:**

   Integrate a built-in navigation system to help users easily locate event venues and ensure seamless integration with personal calendar applications (e.g. Google Calendar) for streamlined event management.

4. **User-Friendly Experience:**

   Focus on creating an intuitive and user-friendly application that is accessible to all users, regardless of their technical proficiency, to promote frequent usage and engagement.

5. **Robust Security Measures:**

   Implement strong security protocols to protect user data, including secure authentication, data encryption, and role-based access control to prevent unauthorised access and safeguard the university’s reputation.

6. **Scalability and Future Expansion:**

   Design the application with scalability in mind, allowing for future expansion to other universities and the addition of new features and functionalities as needed.

7. **Personalised Event Recommendations:**

   Utilise data analytics to analyse user behaviour and preferences, providing personalised event recommendations to enhance user experience and event participation.

8. **Community Building:**

   Foster a vibrant and interactive university culture by promoting events and facilitating community engagement through features like event invitations, RSVPs, and notifications.

9. **Big Data Analytics**:

   Incorporate big data analytics to generate insights and trends on user engagement and event popularity, helping event organisers to optimise event planning and logistics.

10. **Notification and Communication Features:**

    Provide users with notifications about upcoming events, changes to events they are interested in, and invitations to private events, ensuring they stay informed and connected.

Using modern mobile application technology, WhatsOn@UP aims to revolutionise the way students and guests interact with university events. By creating a centralised, secure, and user-friendly platform, the project seeks to enhance campus life and build a stronger university community. The scope of WhatsOn@UP includes developing a cross-platform mobile application using Flutter, with a backend implemented in Spring Boot, Kotlin and a PostgreSQL database. The system will be hosted on  AWS to ensure scalability and reliability.

#### **Class Diagram**  {#class-diagram}

#### **![][image1]**

	

#### **User Stories**  {#user-stories}

1. **As a Guest User:**

   **1.1**  I can browse public events on the WhatsOn@UP platform without needing to create an account.

   1.2 I can utilise search and filter functionalities to find events of interest based on categories, dates, and locations.

   1.3 I can view detailed information about each event, including its name, description, date, time, and location.

   1.4 I can use the built-in map feature to navigate to event venues.

   1.5 I can add public events to my personal calendar directly from the app.

2. **As a General User:**

   **2.1**  I can register an account with WhatsOn@UP using my email address, google or social media login credentials.

   2.2 I can log into the WhatsOn@UP system using my registered email and password.

   2.3 I can search for and view public events on the platform.

   2.4 I can add events to my personal calendar and manage my event schedule.

   2.5 I can RSVP to private events if invited by the host.

3. **As a Host User:**

   **3.1**  I can create new events by providing details such as event name, description, date, time, location, and category (public or private).

   3.2 I can edit and manage events I have created, including updating event details and cancelling events if necessary.

   3.3 I can invite users to private events by sending them event invitations.

   3.4 I can view RSVPs and manage attendee lists for private events.

   3.5 I can access analytics and insights about my hosted events, such as attendance rates and user engagement metrics.

4.  **As an Admin User:**

   **4.1**  I can manage user accounts within the WhatsOn@UP system, including creating, editing, and deleting user profiles.

   4.2 I can review and approve event requests submitted by host users before they are published on the platform.

   4.3 I can monitor all events within the WhatsOn@UP system and ensure compliance with platform guidelines and policies.

   4.4 I can manage system settings and configurations, including security settings, notification preferences, and feature toggles.

   4.5 I can generate reports and analytics on user engagement, event trends, and system usage for strategic planning and decision-making purposes.

### 

### **Functional Requirements**  {#functional-requirements}

## **Use Case Diagram** 

## **Requirements implemented for Demo 1** 							 Technical Requirements

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

#### **4\. Invite Users**

* **4.1. Navigation to Create Event:**  
  * The system shall allow users to navigate to the `Create Event` page either by selecting the `Create Event` option or by pressing the `+` button on the home page.  
* **4.2. Event Creation:**  
  * The system shall allow users to fill in the necessary event details on the `Create Event` page.  
* **4.3. Submit Event:**  
  * Upon pressing the `Submit` button, the system shall save the event details and automatically navigate the user to the `Invite Users` page.  
* **4.4. Invite Users:**  
  * The system shall allow users to enter the full name of another user they want to invite to the event.  
* **4.5. Send Invitation:**  
  * Upon pressing the `Invite` button, the system shall send an invitation to the specified user.  
* **4.6. Invitation Response:**  
  * The invited user shall be able to accept or decline the invitation through their notifications.

#### **5\. Admin Management: Host Application**

* **5.1. Manage Events Navigation:**  
  * The system shall allow admins to navigate to the `Manage Events` section.  
* **5.2. Access Host Applications:**  
  * The system shall display a list of general host applications under the `General Host Application` tab.  
* **5.3. Application Management:**  
  * The system shall allow admins to accept or decline host applications.  
  * If the user is not verified, the system shall prevent the admin from accepting the application. Declining the application shall only be possible if the user has submitted the required documents.

#### **6\. Admin Management: Events**

* **6.1. Manage Events Navigation:**  
  * The system shall allow admins to navigate to the `Manage Events` section.  
* **6.2. View Attendees:**  
  * The system shall allow admins to view all attendees for a specific event.  
* **6.3. View All Events:**  
  * The system shall allow admins to view all events.  
* **6.4. Event Management:**  
  * The system shall allow admins to delete or edit any event.

#### **7\. Location**

* **7.1. Retrieve Campus Venues:**  
  * The system shall retrieve real campus venues when an event is created.  
* **7.2. View Event Location:**  
  * The system shall allow users to view the location of the event on a map.

#### **8\. Host Application**

* **8.1. Host Application Submission:**  
  * The system shall allow general users to apply for a host promotion by filling out a form with the necessary details, applicable to both UP students and non-UP students.  
* **8.2. Notification of Application Response:**  
  * The system shall notify the user via notifications if their application has been accepted or rejected by the admin.

#### **9\. Notifications**

* **9.1. Event Invitation Notification:**  
  * The system shall notify users when they have been invited to an event.  
* **9.2. Application Response Notification:**  
  * The system shall notify users when their host application has been accepted or rejected.  
* **9.3. Event Update Notification:**  
  * The system shall broadcast notifications to users who have RSVP'd to an event if the event has been edited.

## Non-technical Requirements

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

#### **Quality Requirements**  {#quality-requirements}

1. **Usability**:   
   1. The application should have an intuitive user interface, easy navigation, and clear event categorization to ensure users can quickly find and engage with events of interest.  
   2. Strategies:  
      1.  Intuitive and simple layout that allows for easy navigation between different pages.  
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

#### **Service Contracts** {#service-contracts}

#### **Description** {#description}

The documentation below provides a detailed specification the formatting of requests to, and subsequent responses from, the Spring Boot API.

Please note that text wrapped in handlebars (`{{ }}`) will likely change in the, near, future.

Note that for all subsequent requests to the API:

* `POST` will be used  
* JSON format will be required in the request body  
* The server's response body will contain data in JSON format  
* {{ JWTs will be used for authentication }}

For each request, the following will need to be included in the header:

{

    "Content-Type": "application/json",

    "Authorization": "\<AUTH KEY\>"

}

#### **User Management** {#user-management}

- ## **Register User** {#register-user}

This will manage creation, deletion, updating, and viewing of user accounts and details

![][image2]

**Request Example:**

{

    "request": "register\_user",

    "auth\_token": "\<token\>",

    "first\_name": "John",

    "last\_name": "Doe",

    "email": "jDoe@email.com",

    "password": "\<encrypted password\>"

}

**Successful response Example:**

{

    "status": "success",

    "timestamp": 1703277000,

    "body": {

        "message": "user successfully created"

    }

}

**Error response example:**

{

    "status": "failure",

    "timestamp": 1703277000,

    "data": {

        "hint": "user already exists \- duplicate email"

    }

}

- ## **Login User** {#login-user}

![][image3]

**Request Example:**

{

    "request": "login\_user",

    "return": "auth\_token",

    "email": "jDoe@email.com",

    "password": "\<encrypted password\>"

}

**Successful response example:**

{

    "status": "success",

    "timestamp": 1703277000,

    "body": {

        "auth\_token": "\<token\>"

    }

}  
**Error response example:**

{

    "status": "failure",

    "timestamp": 1703277000,

    "data": {

        "hint": "user 'jDoe@email.com' not found \- invalid email address"

    }

}

# **Event Management**  {#event-management}

- # **Get upcoming events**![][image4]

**Request Example 1:**

{

    "request": "get\_upcoming\_events",

    "auth\_token": "\<token\>",

    "return": \["event\_id", "title"\]

}

**Success response example 1:**

{

    "status": "success",

    "timestamp": 1703277000,

    "body": {

        \[

            {

                "event\_id": {{001}},

                "title": "Super cool first event"

            },

            {

                "event\_id": {{002}},

                "title": "Slightly less cool second event"

            },

            {

                "event\_id": {{003}},

                "title": "Some other event"

            }

        \]

    }

}

**Request Example 2:**

{

    "request": "get\_upcoming\_events",

    "auth\_token": "\<token\>",

    "return": \["event\_id", "title", "attendees"\],

    "filter": {

        "event\_id": {{001}}

    }

}  
**Success response example 2:**

{

    "status": "success",

    "timestamp": 1703277000,

    "body": {

        \[

            {

                "event\_id": {{001}},

                "title": "Super cool first event",

                "attendees":\[

                    {

                    "user\_id": {{uid001}},

                    "user\_name": "J0hN\_2005"

                    },

                    {

                    "user\_id": {{uid005}},

                    "user\_name": "Janeee"

                    }

                \] }\]}}

**Error response example:**

{

    "status": "failure",

    "timestamp": 1703277000,

    "data": {

        "hint": "No event with id '{{001}}' exists}"

    }

}

- ## **Get saved events** {#get-saved-events}

![][image5]

**Request Example 1:**

{

    "request": "get\_saved\_events",

    "auth\_token": "\<token\>",

    "user\_id": {{uid001}},

    "return": \["event\_id", "title", "description", "event\_type"\]

}  
*Note that fuzzy sort is to be used for fuzzy searchable fields such as (title or description)*

**Success response example 1:**

{

    "status": "success",

    "timestamp": 1703277000,

    "body": {

        \[

            {

                "event\_id": {{004}},

                "title": "Campus wedding",

                "description": "watch two star-crossed lovers get together right here on hatfield campus",

                "event\_type": "Workshop"

            },

            {

                "event\_id": {{006}},

                "title": "Blood drive"

                "description": "Donate blood on hatfield campus \- in the student centre",

                "event\_type": "Career fair"

            },

            {

                "event\_id": {{003}},

                "title": "Some other event"

                "description": "You have no reason to not attend",

                "event\_type": "Career fair"

            }

        \]

    }

}

**Request Example 2:**

{

    "request": "get\_upcoming\_events",

    "auth\_token": "\<token\>",

    "return": \["event\_id", "title", "description", "event\_type"\],

    "filter": {

        "description": "On Hatfield Campus",

        "event\_type": "Workshop"

    }

}  
**Success response example 2:**

{

    "status": "success",

    "timestamp": 1703277000,

    "body": {

        \[

            {

                "event\_id": {{004}},

                "title": "Campus wedding",

                "description": "watch two star-crossed lovers get together right here on hatfield campus",

                "event\_type": "workshop"

            }

        \]  }}

#### 

#### **Architectural Patterns** {#architectural-patterns}

1. **Service-Oriented Architecture (SOA):**

WhatsOn@UP is expected to handle various functionalities like event search, user management, and push notifications. SOA allows us to decompose the application into independent, reusable services. This approach offers:

* Scalability: Individual services can be scaled independently based on their needs. For example, the event search service can be scaled up during peak usage times without impacting other services like user management.  
* Security: Fine-grained access controls can be implemented at the service level, ensuring only authorised users or applications can access specific functionalities. This enhances security by limiting access points to sensitive data.  
* Interoperability: Services can be designed with standardised APIs that can be accessed by different technologies and platforms. This allows for easier integration with other systems.


2. **Enterprise Service Bus (ESB):**

To ensure reliable and secure communication as the number of services in WhatsOn@UP grows, an Enterprise Service Bus (ESB) acts as a central hub, facilitating data exchange between services. This ESB implementation offers several key benefits:

* Scalability: The ESB efficiently routes messages even when services are spread across multiple servers, ensuring WhatsOn@UP functions smoothly.  
* Security: The ESB enforces security measures like message encryption and authentication to protect data exchanged between services.  
* Performance: The ESB manages asynchronous communication between services, improving user interface responsiveness by not blocking the UI while services retrieve data from each other.


  **3\. Model-View-Controller (MVC):**

 MVC is a well-established pattern that separates the application logic (Model) from the user interface (View) and the data binding between them (Controller). This separation promotes:

* Usability: Developers can focus on building a robust model and efficient data handling, leading to a more maintainable and user-friendly application in the long run.  
* Performance: MVC allows for optimised UI rendering and data handling techniques, contributing to better overall application performance.

By implementing these architecture patterns, WhatsOn@UP can achieve the desired level of scalability, security, usability, and performance.

#### **Proposed Technologies**  {#proposed-technologies}

The technology stack outlined in this proposal represents our recommendation based on our technical expertise and understanding of project requirements. We are open to discussing alternative solutions or specific preferences you might have for the development tools and frameworks. As final-year students, we're constantly eager to learn new technologies and frameworks, so don't hesitate to suggest changes or discuss options.

| Use case | Proposed technology/framework |
| :---- | :---- |
| Frontend | Flutter   |
| Backend | SpringBoot, Kotlin, nest js |
| Database | PostgreSQL |
| Hosting | Amazon Web Services (AWS) |
| Version Control | Git with Github and Docker |
| Team Organization | Trello  and Github Boards  |
| Testing  | J-Unit and Flutter’s built-in testing library |
| Documentation | Google docs and Markdown  |
| CI-CD | Github actions and AWS CodeDeploy |

# 

# Proposed Technologies Deep Dive  {#proposed-technologies-deep-dive}

### **Choosing the Right Tools for the Job** {#choosing-the-right-tools-for-the-job}

**Front-End Development: Flutter**

Reasoning: Flutter offers several advantages for mobile app development:

* Reduced Development Time: A single codebase for both Android and iOS platforms saves time and resources.  
  * Native-like Performance: Utilises Dart for a smooth and responsive user experience.  
  * Visually Appealing UI: Provides a rich set of widgets for building an engaging interface.  
  * Rapid Development Cycles: Hot reload functionality allows for near-instantaneous updates on the device.

Benefits for WhatsOn@UP: Flutter's features make it ideal for creating a visually engaging and performant application for both Android and iOS users, catering to a wider audience within the university community.

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

![][image6]

#### 

#### 

#### 

#### 

#### 

#### 

#### 

#### 

#### **Project Development Methodology** {#project-development-methodology}

Our team will be using the Agile Process which focuses primarily on the implementation of the system, where just enough, digestible documentation is provided to keep all stakeholders on the same page. This process will be used alongside the Scrum Methodology in order to deliver customer value, remain flexible to any changes, and maintain transparency with stakeholders.

As such, the development process will be broken up into 2-week sprints where a minimum viable product will be produced. In these two weeks, we will have short daily stand-up meetings (daily Scrums) to report progress and voice any concerns in order to ensure consistent progress. Before such a sprint, tasks will be taken from the Product Backlog (produced from the MVP being broken up into features) based on story points assigned to such tasks \- as opposed to using fixed time-block estimation. 

During a given sprint, backlog refinement will be performed to ensure that features wanted by the customer and needed by the client are efficiently prioritised. This will be done to help organise and plan upcoming sprints. 

After each 2-week period, there will be a Sprint Retrospection where what worked, what did not work, and what should be changed for future sprints will all be evaluated.

#### 

# Proactive Planning:Addressing Key Considerations for WhatsOn@UP Development {#proactive-planning:addressing-key-considerations-for-whatson@up-development}

1. **Prioritizing User Experience (UX):**  
   Creating an intuitive and user-friendly experience is paramount for WhatsOn@UP's success.  To achieve this, we plan to conduct usability testing sessions throughout the development process.  These sessions, involving students on campus, will allow us to identify and address any usability issues early on.  Furthermore, we'll integrate in-app tutorials to guide new users through the app's functionalities.  We'll also adopt an iterative design process, where user feedback from testing sessions is actively incorporated to continuously improve the overall UX.  Additionally, we will explore A/B testing different design elements and functionalities to see which ones resonate best with users.  
2. **Enabling Offline Functionality:**  
   We understand the importance of ensuring the app functions even when users are offline.  To address this challenge, we plan to implement caching mechanisms. This will allow the app to store frequently accessed event data, such as upcoming events or saved favorites, for offline use.  Even when offline, users will still be able to browse saved events, view details of previously accessed events, or utilize basic filtering options.  
3. **Guaranteeing Security:**  
   Security is a top priority for WhatsOn@UP.  We plan to address this by utilizing secure data storage solutions, including encrypted databases and user authentication mechanisms.  Furthermore, we'll follow secure coding best practices to minimize vulnerabilities and stay updated on the latest security threats.  To proactively identify and address potential security weaknesses, we will also consider conducting penetration testing during development.   
4. **Ensuring Accessibility:**  
   We are committed to making WhatsOn@UP accessible to all users, including those with disabilities.  To achieve this, we'll strive for conformance with the Web Content Accessibility Guidelines (WCAG).  This will ensure features like screen reader compatibility, high-contrast themes, and appropriate text sizing are implemented within the app.  Additionally, we'll utilize accessibility testing tools to identify and fix any accessibility issues that might arise throughout development.  
5. **Maintaining Performance and Scalability:**  
   As the WhatsOn@UP user base and data volume grow, it's crucial to maintain optimal performance and scalability.  We plan to address this by implementing code optimization techniques throughout development.  Additionally, we'll choose a scalable cloud-based hosting platform, such as AWS, that can handle increasing user traffic and data storage needs.   Finally, we'll employ continuous performance monitoring to identify any potential bottlenecks and ensure smooth app performance for all users.  
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
   

#### **Appendix**  {#appendix}

### **Technology Choices for WhatsOn@UP**

**Frontend Development: Flutter**

- **Overview**: Flutter is a cross-platform framework using Dart, a dynamically typed language with JIT compilation for hot-reloading, providing a single codebase for Android and iOS.  
- **Pros and Cons:**  
* Pros:  
  * **Enhanced User Experience:** Provides native-like performance and visually appealing UIs, crucial for engaging university students.  
  * **Efficiency:** Hot reload feature accelerates development cycles, enabling rapid prototyping and immediate feedback.  
  * **Scalability:** Ensures consistent UI/UX across platforms, reducing maintenance efforts and enhancing user satisfaction.  
* Cons: Smaller community compared to some alternatives, primarily focused on mobile apps.  
- **Fit with Architecture Strategies:**  
* Flutter aligns with our strategy for consistent UI/UX across platforms, leveraging Dart's efficiency and hot reload for rapid prototyping.

- ## Why Flutter and not React Native?

* **Enhanced User Experience:** Flutter provides native-like performance and visually appealing UIs, crucial for engaging university students, which React Native might not achieve as consistently due to its bridge between JavaScript and native components.  
* **Efficiency:** The hot reload feature in Flutter accelerates development cycles, enabling rapid prototyping and immediate feedback, a capability that React Native lacks in terms of speed and responsiveness.  
* **Scalability:** Flutter ensures consistent UI/UX across platforms, reducing maintenance efforts and enhancing user satisfaction more effectively compared to React Native, which may require platform-specific adjustments.  
- 

**Backend Development: Spring Boot with Kotlin**

- **Overview**: Spring Boot is a Java-based framework known for its scalability, security, and ease of development.  
- **Pros and Cons:**  
* Pros:   
  * **Performance:** Optimized for high performance and efficient resource management, critical for handling a growing user base.  
  * **Security:** Built-in security features protect user data, ensuring compliance with university privacy standards.  
  * **Scalability:** Asynchronous nature supports scalability, integrating seamlessly with cloud services like AWS.  
* Cons: Requires more configuration compared to some frameworks like Node.js.  
- **Fit with Architecture Strategies:**  
* Spring Boot with Kotlin supports our microservices architecture, ensuring reliability and scalability in managing event data and user interactions.

- ## Why Spring Boot with Kotlin and not Node.js?

* **Performance:** Spring Boot with Kotlin is optimized for high performance and efficient resource management, crucial for handling a growing user base, whereas Node.js may require more tuning for optimal performance in enterprise-level applications.  
* **Security:** Built-in security features in Spring Boot protect user data, ensuring compliance with university privacy standards more comprehensively than Node.js, which often relies on third-party libraries for security implementations.  
* **Scalability:** The asynchronous nature of Spring Boot with Kotlin supports scalability, integrating seamlessly with cloud services like AWS, a feature that Node.js, while scalable, may require additional effort for robust scalability.  
- 

**Database: PostgreSQL**

- **Overview**: PostgreSQL is a powerful open-source relational database known for its reliability and scalability.  
- **Pros and Cons:**  
* Pros:   
  * **Data Integrity:** ACID compliance ensures data integrity, critical for managing event data and user information securely.  
  * **Scalability:** Scales effectively with increased data and user interactions, supporting WhatsOn@UP's growth trajectory.  
  * **Community Support:** Active community and robust ecosystem provide ongoing support and updates.  
* Cons: May require more administration compared to NoSQL databases for scaling.  
- **Fit with Architecture Strategies:**  
* PostgreSQL ensures data integrity and consistency, crucial for managing event data and user information securely.

- ## Why PostgreSQL and not MySQL?

* **Data Integrity:** PostgreSQL's ACID compliance ensures data integrity, critical for managing event data and user information securely, a level of assurance that MySQL might not consistently provide in complex transactional scenarios.  
* **Scalability:** PostgreSQL scales effectively with increased data and user interactions, supporting WhatsOn@UP's growth trajectory better than MySQL, which might require more effort in administration for scaling in high-demand environments.  
* **Community Support:** PostgreSQL boasts an active community and robust ecosystem, providing ongoing support and updates that MySQL's community might not match in terms of frequency and depth.

**Hosting: Amazon Web Services (AWS)**

- **Overview**: AWS offers a scalable cloud platform with a wide range of services for hosting and managing applications.  
- **Pros and Cons:**  
* Pros:  
  * **Scalability:** Easily scales infrastructure resources based on user demand, ensuring uninterrupted service availability.  
  * **Reliability:** High availability and disaster recovery features minimize downtime and enhance user experience.  
  * **Security:** Advanced security features safeguard data and infrastructure, meeting stringent university privacy and compliance requirements.  
  * **Global Reach:** AWS's global infrastructure supports WhatsOn@UP’s potential expansion and user base diversity.  
* Cons: Cost can scale with usage, complex pricing structure.  
- **Fit with Architecture Strategies:**  
* AWS provides a reliable and secure infrastructure for hosting WhatsOn@UP, supporting future growth and ensuring high availability.

- ## Why AWS and not Firebase or Azure?

* **Scalability:** AWS easily scales infrastructure resources based on user demand, ensuring uninterrupted service availability more comprehensively than Firebase or Azure, which may have limitations in scaling certain resources.  
* **Reliability:** AWS offers high availability and disaster recovery features that minimize downtime and enhance user experience, a level of reliability that Firebase and Azure might not consistently provide across all services.  
* **Security:** Advanced security features in AWS safeguard data and infrastructure, meeting stringent university privacy and compliance requirements better than Firebase or Azure, which may require additional configuration for similar security levels.  
* **Global Reach:** AWS's global infrastructure supports WhatsOn@UP’s potential expansion and user base diversity, a geographic advantage that Firebase and Azure may not match in terms of coverage and accessibility.

By selecting Flutter, Spring Boot with Kotlin, PostgreSQL, and AWS, we've chosen technologies that collectively offer robustness, scalability, security, and efficiency. These choices not only align with our technical requirements but also ensure that WhatsOn@UP meets the high expectations of performance and reliability demanded by users within the University. Each technology brings unique strengths that together contribute to a seamless and user-friendly experience, enhancing engagement and satisfaction within the university community.

### 

### **User Characteristics** {#user-characteristics}

The users of the app can be classified into the following groups:

1. **Students**  
   Students are the primary target audience. Consisting mainly of enrolled students that are interested in discovering and attending various events, and engaging with the campus. They will be mainly interested in seeing which events are happening, where these events are happening, and at what time. Students will include the following user types: Guest users, if they do not wish to create an account but still want to view which events are happening. General users, if they intend to rsvp to events they will need to register an account. Host users, if they are part of some club on campus and they have been given permission to host an event.

2. **Event Organisers**  
   Comprises representatives of student clubs, campus businesses, and external partners authorised to host events at the university. They will be focused on creating and managing events. Event organisers include the following user types: Host users, if they intend on hosting events they need to be a host. Admin users, if they are trusted and have been given permission.

3. **University Guests**  
   Temporary visitors to the campus. This can include prospective students, guest speakers at events or users that are not students at the university, but are attending some event that is open to the public there. These users will mainly be interested in the in-app navigation feature, which can guide them to the location on campus where they need to be. University guests will include the following user types: Guest users, if they are a guest speaker at an event they will most likely not have an account but can still use the app for navigation purposes.

### **Coding Standards**

Creating cleaner code means writing code that is readable, efficient, and effectively detects bugs and errors. Coding standards are a set of guidelines that help developers express their decisions clearly, facilitating collaboration with other developers and stakeholders who may review the code.

Naming Conventions

We will use camelCase for naming functions, classes, and variables. This enhances readability and understanding of each entity's functionality. Names should be concise yet descriptive, avoiding overly short or cryptic names like "X." The names should clearly describe the purpose of variables, functions, and classes.

### Formatting

For frontend development, we will use **Flutter linter rules** configured both locally and in our CI/CD pipeline. This automation ensures consistent linting with rules such as:

* `prefer_const_constructors_in_immutables`: Optimizes performance by using const constructors in immutable classes.  
* `use_key_in_widget_constructors`: Improves widget state preservation and performance by using the key parameter in widget constructors.  
* `non_constant_identifier_names`: Enforces camelCase naming convention for non-constant identifiers.  
* `unused_import`: Flags unused imports to keep our codebase clean.

Indentation will use 2 spaces for tabs, ensuring consistent formatting with a Dart built-in formatter.

For backend development, we will use **Ktlint** with the following rules:

* `indent_style` and `tab_width`: Indentation will be set to 3 spaces.  
* `UnusedImports`: Reports and removes unused imports in Kotlin code.

### Commenting

Comments should briefly describe code functionality to aid readability. Avoid overly descriptive comments and place them above the relevant code section.

### File Structure and Organization

Backend:

* Controllers folder  
* Service folder  
* **File naming in UpperCamelCase format.**

Frontend:

* Pages, Screens, Services, Widgets folders  
* **Main file naming in snake\_case format.**

### Git Standards

Git Flow:

* Main: Production-ready branch.  
* Develop: Ongoing development branch.  
* Feature: Temporary branches for new features.  
* Release: Preparing new release versions.

Branch Naming Convention:

* Features: **feat**/\<nameOfTheFeature\>  
* Bug fixes: **fix**/\<nameOfTheBugFixes\>  
* Documentation: **docs**/\<nameOfDocumentationName\>

Commit Message Standards:

* Minimum of 10 words per commit.  
* Use of  "Bug" keyword for minor fixes with the feature/component name that was fixed.  
* Provide a clear explanation of changes, potentially in bullet points.

### Code Reviews

* At least one reviewer must approve pull requests.  
* All CI/CD checks must pass before merging.  
* Pull requests should include tags, mention addressed milestones, a descriptive title, and an explanatory body.

  

[image1]: <data:image/png;base64,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7ubOnRtY43EeOQdCCCFEIaLItBAiJ/DQIoQQQhQSFpkm0iSEENlCoRkhhBCikKClWVYKQoicIJ9pIYQQhcbTTz/tUliXCSFEtsgaTwghRKFBimOKzmNCCJEtypkWQghRaFAATz7TQgghhBBClAIctZQzLYTICcqZFkIIUWhgUazItBBCCCGEEKWAmiKKTAshcoIi06KQueKKKzQkaKCwmBC5IkWlQiGEyJbff/89OksIIWJJ5cqVo7OEKBWvvPKKItNCiNygyLQQIilITItcYUVblDMthBBCiEJCYlrkioEDByoyLYTIDYpMC5FsHnroocAvfvbs2e6GG25wPXv2dIsWLXLXXHONu/jii12tWrWKrpRQJKZFrvjxxx8VmRZCCCGEc4cffnjweujQoe7nn38Opu+66y5XtWpV17hx42BekpGYFrnitttucymVABZC5ILwH68QQsQZiWmRSxSZFkIIIURBITEtcoVFpqMzhRCiNChnWgiRFCSmRS5JrVmzJjpPCCFKjHymhRBJ4e9//3t0lhClQjnTQoicoZxpIURSkJgWuSS1bt266DwhhCgxv/32W3SWEELEEolpkSssMv3tt99G5wshRIlRK5cQG3jiiSdc27ZtXffu3V2XLl3cd9995w444ADXtWtXt+eee7qjjz7aPfLII4Gv86OPPuoGDRpkr8eOHWvLNmjQwC1fvty1atXKvf76627//fe37fz1r391Y8aMCe9OlBCJaZEr6C8kNw8hhBAix1SoUMEdeuihrkmTJiag8XCuXr26vX7rrbfcww8/7MaNGxeI6TfffDNYt3Pnzu7qq6929GlCRIMfT5w40cYS09khMS1yhUWmf/rpp+h8IYQoMb/88kt0lhAFy+DBg92VV17pPv/8c/e///3PffbZZ65GjRqBmH7ppZdMECOma9as6YYPH24VCIECKcz79ddf3ZIlS2xeWExXqVLFTZs2ze9KlAKJaZFLUpRBFEKIbOGPXwiRf+bNmxedJUqIxLTIFRaZXrt2bXS+EEKUGKJvQgiRBCSmRS6RNZ4QIifIGk8IkRQkpkWumDRpkkupapkQIhcoZ1oIkRQkpkUukZgWQuQEiWkhRFKQmBa5onfv3i715ZdfRucLIUSJUc60EBvAyYOOSThz3H777dG3A+68804bf/TRR5F3RD6RmBa54quvvnKp6EwhhCgN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mDRpUvQrTYvEdHokpiWmhciEItMiIGqNN2TIEPfEE0+Ytyw988kXRSj36NHDjRo1yp1//vnWwQpfWWztgDF/3u3bt7dpfKg9iGfyTOmshaVe165d3dFHH205qDggkG8qNiYpYjpfKDKdHQ8//HB0VlqiYhqLugULFrimTZu66dOnm0Xe5MmTrZPliBEj3AMPPGDLMcYO87bbbrPpt956y8bkkOM9zfJ4VuPywXK85j3cO4B7AvCgznvcfx599FGbN2fOHLdixQp77f3rseb022PMcffp08feywcS0xLTQmRCkWkREBXT/EHxZzpy5EiztfJiGms7QADjO0uhBe8H68U0xRsAb2kPnrLdunUzMd2gQQMT040aNXINGzZ0HTp0sEIQYmOSIqbzFZmWmM6OkoppHpSBoir4zPM779Wrl5s2bZo7/vjjAwtEfuPcC5gOi2nuH3hP40N/1VVXbVTh8IADDihio+jFNNuqXbu2e/vtt82Cz3taezENFHYaPXq0bdevx32E6qrco4prX1gSJKYlpoXIhCLTIiCa5kGxFsRvaSDyhPD2pcczgc3YLbfcEp0tXHLEdL7IRkxPmTKlyDQPh4hEWkx4AIwSfqArL9VhSyqmPStXrrSULnKun3rqKdsO36cXwnyHvEZs42DSrl27oCWKNDAiybRchT2jEeQsw4O3//6ZJrpNzQO/PtvyMI8BUefFMtNepBMt99UW84HEtMS0EJlI+fxVIaJiWsSDpIhpXxkz10TFNKlHtG4AaQBU1CNaSYvItddeayL46aefNhGH5zMPdbR+kD/sxTRQmdMzZswYSzNATO+333427+WXX7YxAjDJ98nSimmxHolpiWkhMqHItAiQmI4nSRHT+cKLaZrxYe7cuSaYGYiMIqZJK/CExTSRVKKgpBFFxTSpAmHee++9tGKa/W3pktbZIDGdHRLTEtNCZEI50yJAYjqeJEVMl9ec6WeffTbRgkJiOjskppN77QtRVigyLQIkpuNJUsR0vtjSYjrpFFdML1++3L3yyisaIoPEtMS0EJlQZFoESEzHk6SI6fIamU46xRXTikynR2JaYlqITKS8d6cQUWs8wBrrpptusuHWW281e7ywy8EhhxziKlasaLmo9ODHc5qOYOeee67r27evLYM/LfmrvhMXN2dsr8hrZVlsrbDDEulJipjOVyc9ienskJjO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>

[image2]: <data:image/png;base64,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>

[image3]: <data:image/png;base64,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>

[image4]: <data:image/png;base64,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>

[image5]: <data:image/png;base64,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>

[image6]: <data:image/png;base64,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>