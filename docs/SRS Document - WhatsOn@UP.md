**DevForce**  
COS 301  
University of Pretoria

                                                                            

                   ![][image1]

# 

# **WhatsOn@UP SRS** 

##                                  **Contact:** [devforce.capstone@gmail.com](mailto:devforce.capstone@gmail.com)

#### Important Links

Repository: [COS301-SE-2024/WhatsOn-UP (github.com)](https://github.com/COS301-SE-2024/WhatsOn-UP) 

Demo 4 Slides: 

Wireframes:[https://drive.google.com/file/d/1qSlPJPVNYl5rjaByyzo5KBY\_vjX\_63GY/view?usp=drive\_link](https://drive.google.com/file/d/1qSlPJPVNYl5rjaByyzo5KBY_vjX_63GY/view?usp=drive_link) 

Wow factor: [https://docs.google.com/document/d/10TdaP6HRqv-BXIyL-A\_9yKit\_kCA3R7LdEa\_E3kAtfg/edit](https://docs.google.com/document/d/10TdaP6HRqv-BXIyL-A_9yKit_kCA3R7LdEa_E3kAtfg/edit)

Testing Documentation: [https://docs.google.com/document/d/1SfIxE-KDSOgc1vl41UrfoCZFlWVLJbdIIYWA4zPoOc0/edit?usp=drive\_link](https://docs.google.com/document/d/1SfIxE-KDSOgc1vl41UrfoCZFlWVLJbdIIYWA4zPoOc0/edit?usp=drive_link) 

Technologies Research: [https://docs.google.com/document/d/1i5oyOKCl6RR43fGU84T-jpH3FCVdWkCGCwjNLkaaPE4/edit?usp=drive\_link](https://docs.google.com/document/d/1i5oyOKCl6RR43fGU84T-jpH3FCVdWkCGCwjNLkaaPE4/edit?usp=drive_link) 

contract:[https://documenter.getpostman.com/view/33979686/2sAXjPzpPJ](https://documenter.getpostman.com/view/33979686/2sAXjPzpPJ)

Github Ruleset Research: [CI/CD \- Google Docs](https://docs.google.com/document/d/1Ig4SYOKnw4ZOrzP6SjYiHuW31lKe9OM7teOcSr8CBp4/edit#heading=h.lt3dnkdyw0h7)

#### 

#### 

#### Project Vision

Students often miss out on enriching experiences beyond academics due to the difficulty in finding and managing various campus events. Current methods rely on scattered sources, making it challenging for students and even university guests to stay informed and involved. The proposed WhatsOn@UP software system aims to be the central hub for all events happening at the University of Pretoria, with the vision of expanding to encompass other universities at a later stage.

Imagine a centralised hub where all university events are readily discoverable. Students and guests can effortlessly browse public events or search for specific interests using clear filters. Need to navigate to an event? A built-in map ensures you remain on course. Adding events to your personal calendar? Just a single tap keeps you organised. The aim is to design an intuitive and user-friendly application that puts all the information users need at their fingertips.

Behind the scenes, our developers will not only prioritise a user-friendly experience but also ensure robust security measures are built in to safeguard the university's integrity and reputation. We, as DevForce, are invested in the initiative to revolutionise the way students engage with their university communities.

#### Project Objectives

The high-level objectives for the WhatsOn@UP project are:

1. **Centralised Event Management:**

   Develop a comprehensive mobile application to serve as a central hub for all events at the University of Pretoria, ensuring ease of event discovery and participation for students and guests.

2. **Enhanced User Engagement:**

   Increase engagement with campus events by providing an intuitive interface that allows users to browse, search, and filter events based on their interests.

3. **Seamless Navigation and Calendar Integration:**

   Integrate a built-in navigation system to help users easily locate event venues and ensure seamless integration with the built-in calendar for streamlined event management.

4. **User-Friendly Experience:**

   Focus on creating an intuitive and user-friendly application that is accessible to all users, regardless of their technical proficiency, to promote frequent usage and engagement.

5. **Robust Security Measures:**

   Implement strong security protocols to protect user data, including secure user authentication, data encryption, and role-based access control to prevent unauthorised access and safeguard the university’s reputation.

6. **Scalability and Future Expansion:**

   Design the application with scalability in mind, allowing for future expansion to other universities and the addition of new features and functionalities as needed.

7. **Personalised Event Recommendations:**

   Utilise data analytics to analyse user behaviour and preferences, providing personalised event recommendations to enhance user experience and event participation.

8. **Community Building:**

   Foster a vibrant and interactive university culture by promoting events and facilitating user engagement through features like event invitations, RSVPs, and notifications, and event broadcasts.

9. **Big Data Analytics**:

   Incorporate big data analytics to generate insights and trends on user engagement and event popularity, helping event organisers to optimise event planning and logistics.

   

10. **Notification and Communication Features:**

    Provide users with notifications about upcoming events, changes to events they are interested in, and invitations to private events, ensuring they stay informed and connected.In addition if any important announcements the host wants to communicate to their attendees, they can simply broadcast that message with a click of a button.The admin also has a broadcasting feature however this broadcast would be received by every individual registered in the app with the purpose of announcing urgent messages that would be beneficial to all users.  

Using modern mobile application technology, WhatsOn@UP aims to revolutionise the way students and guests interact with university events. By creating a centralised, secure, and user-friendly platform, the project seeks to enhance campus life and build a stronger university community. The scope of WhatsOn@UP includes developing a cross-platform mobile application using Flutter, with a backend implemented in Spring Boot (using Kotlin), NestJS  and a PostgreSQL database. The system will be hosted on  AWS to ensure scalability and reliability.

#### 

#### 

#### 

#### 

User Characteristics

1. **Guest User**

A **Guest User** refers to an individual who is not affiliated with the University of Pretoria (such as non-students or non-staff members). This user may be interested in quickly browsing through public events hosted by the university. The guest user might use the app to explore available events and find specific details or directions to these events on campus. Their goal is typically to gain quick access to event information without needing full access to other university-specific features.

2. **General User**

The **General User** of the **WhatsOn@UP** platform has several key capabilities to engage with and manage events. They can easily log into the platform using their registered email and password, ensuring secure access to their account . Once logged in, they can search for and browse through a variety of public events hosted by the university, keeping them informed about what’s happening on campus .

In addition, the user can add events to their personal calendar, allowing them to organise and manage their event schedule efficiently . For private events, if they receive an invitation from the host, they have the ability to RSVP, ensuring they can attend exclusive gatherings .

Beyond these core features, the user benefits from timely notifications about upcoming events. This ensures they remain informed about new or emerging events on campus, keeping them engaged with the platform through real-time updates on events they may wish to attend.If a General User wishes to become a host, they can apply for hosting privileges. Once approved by the admin, they gain the ability to create and manage their own events on the platform, expanding their involvement beyond just attending events .

3. **Host User**

The **Host User**  is capable of creating and managing events. They can create new events by providing key details such as the event name, description, date, time, location, and whether the event is public or private. Once created, the user has full control over their events, allowing them to edit details or cancel events when necessary .

For private events, this user can send invitations to specific individuals, ensuring that only invited users can RSVP and attend . Additionally, the organiser has access to tools for viewing RSVPs and managing the attendee list, giving them oversight of who will be attending .

The user also benefits from analytics and insights related to their hosted events, including data on attendance rates and user engagement. This feature allows them to gauge the success of their events and make data-driven decisions for future planning .

4. **Admin User**

The **Admin User** on the **WhatsOn@UP** platform plays a critical role in overseeing the system and maintaining its operational standards. One of their key responsibilities is reviewing and approving host applications submitted by General Users. Admins can grant these hosting privileges for a limited time and have the authority to revoke them as needed to ensure proper platform usage .In addition, the Admin monitors all events within the system to ensure they comply with platform guidelines and policies, maintaining the integrity of the events hosted on the platform . They also manage crucial system settings and configurations, such as security settings, notification preferences, and feature toggles, ensuring that the platform remains secure and user-friendly .Beyond event and system management, Admins have the ability to generate comprehensive reports and analytics, providing insights into user engagement, event trends, and overall system usage. This data helps with strategic planning and decision-making, ensuring the platform continues to meet the needs of its users .

#### User Stories 

1. **As a Guest User:**

   **1.1**  I can browse public events on the WhatsOn@UP platform without needing to create an account.

   1.2 I can utilise search and filter functionalities to find events of interest based on categories, dates, and locations.

   1.3 I can view detailed information about each event, including its name, description, date, time, and location.

   1.4 I can use the built-in map feature to navigate to event venues.

   1.5 I can add public events to my personal calendar directly from the app.

2. **As a General User:**

   2.1  I can register an account with WhatsOn@UP using my email address.

   2.2 I can log into the WhatsOn@UP system using my registered email and password.

   2.3 I can search for and view public events on the platform.

   2.4 I can add events to my personal calendar, the apps calendar, and manage my event schedule.

   2.5 I can RSVP to private events if invited by the host.

   2.6 I can submit an application to the Admin to gain access to host privileges.

   2.7 I can create and manage my events after my host application to the admin has been approved.

   2.8 I can save events that interest me and revisit them later on to see if I want to RSVP

   2.9 I can view personalised event recommendations, making it easier for me to find events I'm most likely to attend.

3. **As a Host User:**

   **3.1**  I can create new events by providing details such as event name, description, date, time, location, and category (public or private).

   3.2 I can edit and manage events I have created, including updating event details and cancelling events if necessary.

   3.3 I can invite users to private events by sending them event invitations.

   3.4 I can view RSVPs and manage attendee lists for private events.

   3.5 I can access analytics and insights about my hosted events, such as attendance rates and user engagement metrics.This would allow me to make informed decisions on the next event I want to host. In addition to that, I can use a smart recommendation feature that would recommend the time,description,date ,venue based on my past analytics on my events.

4.  **As an Admin User:**

   4.1 I can review and approve host applications requests submitted by general users for a limited time.I can also revoke privileges whenever I see fit.

   4.2 With the possibility of having multiple Admin I can view the admin that dealt with a host application if needed.

   4.3 I will receive notifications on new host applications so that I can be easily informed and reminded to review and process applications.

   4.4 I can monitor all events within the WhatsOn@UP system and ensure compliance with platform guidelines and policies.

   4.5 I can  view analytics on user engagement, event trends, and system usage for strategic planning and decision-making purposes.

### 

### Functional Requirements 

## **Use Case Diagram** 

## 

## **Requirements implemented**			Technical Requirements

1. **User Registration, Authentication, and Access Control:**  
   1. Users should be able to log into their accounts.  
   2. Users should be able to create new accounts.  
   3. Users should be able to view some parts of the app without creating or signing into an account.  
   4. User should be assigned roles (Guest, General, Host, Admin):  
      1. Users should only be able to access specific features and content based on their assigned roles.  
      2. Admin users should be able to grant/revoke Host status to General users.  
2. **Create, Edit, Delete, RSVP Events,Past Events:**  
   1. Host and Admin users should be able to manage events:  
      1. Host and Admin users should be able to create new events.  
      2. Host and Admin users should be able to edit existing events.  
      3. Host and Admin users should be able to delete existing events.  
      4. Host and Admin users should be able to view their past events however the Admin can view all past events.  
   2. General, Host and Admin users should be able to add public events to their calendars.  
   3. Host and Admin users should be able to invite specific users to a private event.  
3. **Discovering and browsing events:**  
   1. Users should be able to discover new events based on their interests(Recommendation system).  
   2. Users should be able to search for events.  
   3. Users should be able to filter events.  
4.  **navigate via a google-maps-like interface to the location**

   4.1Users should be able to navigate to the event location using a Google Maps-style interface.

   4.2 There should also be clear, easy-to-follow directions to event venues.

   

5. **User Role Management:**

   4.3 Admin users should have the ability to grant or revoke Host status for General users.

## Non-technical Requirements

1. **The app should be user-friendly:**  
   1. The design should maintain a consistent layout and navigation structure.  
   2. The design should be visually appealing.

Subsystems 

1. User Registration and Authentication Subsystem  
2. User Management Subsystem  
3. Event Management Subsystem  
4. Calendar Integration Subsystem   
5. Navigation and Mapping Subsystem  
6. Notification Subsystem Subsystem   
7. Analytics and Recommendations Subsystem

### **System Overview**

#### **1\. User Registration and Authentication Subsystem**

* Manages user sign-up, login, and authentication processes.

#### **2\. User Management Subsystem**

* Handles user roles, permissions, and profile management.

#### **3\. Event Management Subsystem**

* Enables creation, editing, deletion, and RSVP for events.  
* Includes features for viewing past events ,attendees and inviting users to private events and taking attendance by exporting attendance list .

#### **4\. Calendar Integration Subsystem**

* Allows users to add public events to their calendars.

#### **5\. Navigation and Mapping Subsystem**

* Provides location services and Google Maps-like interface for navigating to event venues.  
* Offers intuitive directions to event locations.

#### **6\. Notification Subsystem**

* Sends alerts and reminders for events, invites, and updates and general broadcast from the Host or Admin.

#### **7\. Analytics and Recommendations Subsystem**

* Analyses user preferences to recommend events.  
* Provides data-driven insights for users and event hosts.


## Quality requirements

1. ## **Usability**

   1.1 The application should have an intuitive user interface, easy navigation, and clear event categorization to ensure users can quickly find and engage with events of interest.  
   **Strategy:**   
* Designing a simple Intuitive layout that allows for easy navigation between pages.

 **Implementation:**

* We used Interface metaphors which have the ability to make learning the system much easier,this helps the users to understand underlying conceptual models.


             **Examples:**

**(These examples are not comprehensive; they merely demonstrate the concepts utilised in the project.)**

| Material interface metaphors | Conceptual understanding |
| :---- | :---- |
| **Home Icon** (very common in websites or apps for navigation to the introductory page) | Users understand that pressing "home" will take them back to a familiar or central point in the app or website |
| **Icon of Multiple People** (used to represent groups, teams) | Users understand that clicking on this icon will take them to a section where they can connect with people, view attendees, or manage groups.(You would see this in broadcast and event Manage events where the Admin or Host is able to manage administration tasks that can affect a group of people)  |
| **Tiles Describing Event Categories** (used in event management platforms and filter tiles):  |  Users understand that each tile represents a distinct event category (e.g., music, sports, workshops), much like how they’d see categories or schedules in a physical event venue.  |
| **Loading circles** | Users understand that they need to wait while the process completes, just as they would wait for a task to finish in real life.This allows the user to stay informed of changes in the app. |

2. ## **Performance**

   2.1 The application should respond quickly to user interactions, with fast loading times for event listings, calendar views, and navigation features.  
   **Strategy:**  
* Making use of state management tools  
* The use of performance testing tools

**Implementation:**

* Currently we are using the following tools to test performance  
  * Google Lighthouse  
  * Load and stress metre  
  * Flutter integration testing would give us an indication of performance progression.  
* Current state management tools being used   
  * Flutter providers-helps in managing state and sharing data across an application .How this helps with performance is that it allows data to be passed down the widget tree and notifying dependent widgets when data changes creating a fast seamless experience for the user in terms of latency .The concept of providers is similar to the Observer pattern.                                                                                            Image: (Sánchez, 2022\)

    

* Cloud run provides built-in load balancing and global distribution mechanisms that reduce latency and improve performance during high traffic.The use of joins rather than hibernate functions because joins are handled directly by the database, which is optimised for query execution. Whilst hibernate functions are handled in the services layer (this is meant to separate the database logic from the application). Another reason why joins provide better performance is because the database retrieves the data from multiple tables in a single query. This reduces the number of round trips between your application and the database. Whilst hibernate uses object-relational mapping (ORM), which often involves multiple SQL queries to fetch data from related tables. This often results in the N+1 problem, where multiple queries are executed to load related entities, resulting in slower performance.  
* Automatic Scaling: Cloud Run automatically scales up and down based on the incoming traffic. (scalability) This means that it can handle sudden traffic spikes by dynamically adjusting the number of container instances, and it can also scale down to zero when there’s no traffic, optimising resource usage. 

3. ## **Security**

   3.1 User data should be securely stored and transmitted, with measures in place to prevent unauthorised access, data breaches, and malicious activities.  
   **Strategy :**   
* Make use of token-based authorization and use role based security in the services   
* Making use of role-based access control

**Implementation**:

* We implemented JWT for user authentication across the services. Each service verifies the validity of the JWT, and if it is valid, the service proceeds with the request.

## **Role-based access control (Frontend)**

Currently, the system employs **four user roles**: **guest**, **general**, **host**, and **admin**, each providing distinct application views and varying levels of privileges.

* **Guest**: Has the most limited access, primarily able to view public content.  
* **General**: Has access to additional features beyond a guest, such as interacting with content, but still with limited control.  
* **Host**: Can manage events, create content,broadcast any information that needs to be communicated to their attendees (this is limited only to the events they have created not other hosts/users events).  
* **Admin**: Has full control over the system, including managing users, content, and application settings.

## Access control matrix to illustrate different privileges 

| Functionality | Guest users  | General users  | Host users | Admin users |
| :---- | :---- | :---- | :---- | :---- |
| Create event | no | no | Yes | Yes |
| Update event | no | no | Yes | Yes |
| Delete event | no | no | Yes | Yes |
| Read Event | Yes | Yes | Yes | yes |
| Update Profile | no | Yes | Yes | Yes |
| Broadcast on events | no | no | Yes (only events they specifically host) | Yes (all events even the ones they don’t host) |
| Broadcast to all users | no | no | no | yes |
| View Recommended Events | no | Yes | yes | Yes |
| View Analytics | no | no | Yes | Yes |
| Save Events | no | Yes | Yes | Yes |
| Manage Attendees  | no | no | Yes (only on events they specifically host) | Yes |
| RSVP event | no | Yes | Yes | Yes |
| View all private events | no | (only if they are invited to the private event) | (only if they are invited to the private event /they created the event) | yes |
| View public events | Yes | Yes | Yes | Yes |
| Application for Host privileges  | no | Yes | no | no |

## **Role based security in the services(Backend)**

**Example :** 

We have ensured that users can only access the endpoints permitted by their assigned role. Below is an example of a general user attempting to delete an event. **(In the actual UI, the user wouldn't have the option to delete an event—this is simply a demonstration using Postman to show what happens when a user tries to access an endpoint they are not authorised to use based on their role.)**

4. ## **Accessibility**

4.1 The application should be accessible to users with disabilities.

**Strategy:** 

* The application must be screen reader friendly.   
* Addition of dark mode and light mode.

**Implementation:** 

We integrated the device's screen reader features to ensure compatibility with our app.

5. ## **Scalability**

   5.1 The application infrastructure should be able to handle increasing numbers of users and events without degradation in performance or reliability.  
   **Strategy:**   
   1. Using auto scaling groups in cloud environments.   
      2. Incoming traffic should be distributed evenly across server instances.

   **Implementation:** 

      Scaling Groups

* We are currently using Google Cloud for our services.How it does this is as the load increases or the services increase each service can scale horizontally to ensure that no one service is overloaded with requests.  
* The use of Joins rather than Hibernate functions, because joins are handled directly by the database, which is optimized for query execution. Whilst hibernate functions are handled in the services layer (this is meant to separate the database logic from the application). Another reason why joins provide better performance is because the database retrieves the data from multiple tables in a single query. This reduces the number of round trips between your application and the database. Whilst hibernate uses object-relational mapping (ORM), which often involves multiple SQL queries to fetch data from related tables. This often results in the N+1 problem, where multiple queries are executed to load related entities, resulting in slower performance.  
* Cloud run provides built-in load balancing and global distribution mechanisms that reduce latency and improve performance during high traffic. 


  





#### Architectural Patterns

| Architectural Pattern | Quality requirements it covers |
| :---- | :---- |
| Service-Oriented Architecture (SOA) | Scalability,Availability  |
| Event-Driven Architecture (EDA)  | Performance   |
| Load Balancer | Availability ,security,Scalability(the API gateway would also act as a load balancer) |
| API Gateway | Security,Scalability |
| Model view view model (MVVM) | Usability |

## Design choices explanations

1. #### Service-Oriented Architecture (SOA)

   1.1 Enables the use of **heterogeneous services** \- not all services need to use the same technologies or protocols, and can be language neutral.  
   1.2 **More manageable than the micro-services architecture** (events are allowed to directly communicate with one another, if necessary, and have a central database).

   1.2.1 **The same data is required in different aspects** (encapsulated by services) of the application. E.g. the notification, navigation, and event management services largely depend on the same data

   1.2.1.1 No need to worry about data consistency between services (which would have been an issue when using microservices)

   1.3 The benefits of horizontal and independent scaling of services enhance **\*\*scalability**, leading to improved performance and flexibility  
     
   1.4 **Availability** is also improved since **services rely less on one anothe**r (ideally not at all)   
   1.5 Two complexities that come with the use of SOA include:

   1.5.1 (I) communication between services  
   1.5.2(II) centralised and authorised access of  services

2. #### Event-Driven Architecture (EDA)

   2.1 Chosen for communication between services, as opposed to Enterprise Service Bus (ESB). 

   2.1.1 These patterns are mostly the same as they both facilitate indirect communication of heterogeneous services  
   2.1.2 In both, a service does not need to know about the implementation details of another service  
     
   2.1.3 The Architectures differ in a few key areas:

   2.1.3.1 ESB makes use of messages while EDA makes use of **asynchronous events** \- this allows services to be able to **respond to events in real time** \- increasing system **performance**  
   2.1.3.2 The ESB can incorporate additional functionality such as load balancing and managing security policies \- allowing for user authentication and authorization  
   2.1.3.3 The main advantage of EDA over ESB is that **EDA better supports the decoupling of services.** ESB creates a bottleneck and a potential single point of failure.  
   2.1.3.4 ESB’s centralization means that it manages the routing, ensuring messages reach their destination, and possibly transformation of messages between protocols, amongst other potential functionality mentioned above. If this fails, then all the services which rely on the  mediator (Bus) for communication will also be impacted  
   2.1.3.5 EDA’s decentralisation means that the services themselves are responsible for emitting and reacting to events, rather than it just being the sole responsibility of the mediator (event broker)

3. #### Load Balancer(LB)

   3.1 This is used to control and direct traffic to the various services of the system  
   3.2 This is useful for when instances are experiencing issues or high usage since requests can be distributed evenly to other resources in order to reduce the load experienced by any one service, increasing the system’s fault tolerance (and therefore it’s **availability**)  
   3.3 The load balancer is also able to filter out any ‘malicious requests’ commonly seen in **Denial of Service (DoS) attacks** \- again aiding in the **availability**, as well as the **security** of the system.

4. #### API Gateway

   4.1 Allows a single point of entry into the provided API  
   4.2 Acts as a buffer between clients and the backend services \- ensuring security  
   4.3 Allows for caching results of previous requests. This alleviates the processing that needs to be done by the services, and most importantly reduces the load needed to be processed by the single database instance  
   4.4 Gateway offloading can be applied, though will not be used for purposes of this project  
   4.5 Can, itself, act as a load-balancer \- directing traffic between multiple services  
   4.6 Introduces a single point of failure \- hence two (or more) can be used

5. #### Model view view model (MVVM)

   5.1 Conforms with the restriction of having to use Flutter  
   5.2 Addresses the concern of **usability** in the application  
   

## Architectural constraints

#### **1\. Technology Constraints**

* **Syncfusion License**: The university may need to upgrade from the community licence to a software licence to access the analytics tools integrated into the app.  
* **Analytics System**: For the WhatsOn@UP app, we will initially utilise Supabase, Firebase Analytics (free tier), and BigQuery (free tier) for data collection and visualisation. This setup is cost-effective and fits our immediate needs. However, as the data volume grows and the analytics requirements become more complex, we will need to scale.  
  * In the future, we may implement ETL (Extract, Transform, Load) processes to migrate data from Firebase Analytics to a more scalable solution like Google BigQuery or AWS Redshift, allowing for larger datasets and more advanced queries.  
  * If real-time data analysis becomes a priority, tools such as Google Cloud Dataflow could be integrated to manage and analyse real-time data streams.  
  * It's important to note that Firebase Analytics has limitations, such as hit limits per month and complexity in generating custom reports.

#### **2\. Compatibility Constraints**

* **iOS Development Limitations**: Due to the lack of necessary hardware, we were unable to develop or test the app for iOS.  
* **Android Version Compatibility**: Certain older versions of Android (specifically version \_\_\_) are incompatible with the app, which affects its functionality on these devices.  
* **Flutter SDK Compatibility**: The app encountered compatibility challenges due to specific limitations of the Flutter SDK version used during development.


## Architectural structure

# 

# 

#### 

#### Technology choices

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

![][image2]

#### 

#### 

#### 

#### 

#### 

#### 

#### 

#### 

#### **Project Development Methodology**

Our team will be using the Agile Process which focuses primarily on the implementation of the system, where just enough, digestible documentation is provided to keep all stakeholders on the same page. This process will be used alongside the Scrum Methodology in order to deliver customer value, remain flexible to any changes, and maintain transparency with stakeholders.

As such, the development process will be broken up into 2-week sprints where a minimum viable product will be produced. In these two weeks, we will have short daily stand-up meetings (daily Scrums) to report progress and voice any concerns in order to ensure consistent progress. Before such a sprint, tasks will be taken from the Product Backlog (produced from the MVP being broken up into features) based on story points assigned to such tasks \- as opposed to using fixed time-block estimation. 

During a given sprint, backlog refinement will be performed to ensure that features wanted by the customer and needed by the client are efficiently prioritised. This will be done to help organize and plan upcoming sprints. 

After each 2-week period, there will be a Sprint Retrospection where what worked, what did not work, and what should be changed for future sprints will all be evaluated.

#### 

WOW FACTOR

# WOW FACTORS

## Recommendation System

Recommendation algorithm used: **Content-based filtering**

**Description:**  
The method is supposed to use attributes of an item and through the interaction the user has with the item the algorithm would decide what content to recommend to the user.

**Implementation:**  
The attributes that we are looking at would be the categories of the event.The user would initially give us their preferences through a survey as they sign up on the app.As the user Saves or even RSVP’s an event it would give us a more refined understanding overtime what events the user has an affinity for.

### **Algorithm**

1. **Preference scoring**  
   1. Initial rating is obtained in the survey in which the user chooses a category they would be interested in .The categories chosen will be rated by the user.  
   2. We also have an interaction value in which will give us a more confidence on what events really interests users we get these values through rsvping and saving of events by the user  
   3. If no interaction has been recorder the categories that have been rated initially would be picked  
   4. If we have the preference value and interaction value we can produce the final rating/predicted ratings rating=(interaction preference+survey preference)×binary digit  
2. **Sorting Events**  
   1. All events are then sorted in a descending order all events with higher predicted ratings(based on category they fall in) would appear first  
2. **Roulette Wheel selection algorithm**  
   1. The fitness will then be determined of each category using the predicted preference scoring of the categories producing a total fitness.(addition of all ratings)  
   2. A random number is generated between 0 to total fitness then the algorithm will iterate over the sorted events adding up their ratings until the sum exceeds the random value.where this occurs that event gets selected  
   3. Special case would be if all the event fitness have a rating of 0 the algorithm will then select random events without using rations  
   4. After selection the event is removed from a list and the process is is repeated until an number of events are selected

### **How is this algorithm progressing overtime to create a better user experience?**

Through continuous interaction with events in the app the proportion in the context of the total fitness for a certain category will increase the more the user interacts with the category, also affecting the fitness to be weaker for other categories that are not being interacted with.

# 

# 

## Analytics System

# **Analytics Overview**

#### **Admin Access**

* Admin users have access to analytics for all events within the platform.  
* They can also view analytics for specific hosts' events, providing insights into overall performance and user engagement.

#### **Host Access**

* Hosts can view analytics specifically for their own events, allowing them to track performance metrics and attendee feedback.

#### **Insights and Recommendations**

* The analytics feature can assist hosts in selecting the optimal venue, time, and date for future events by leveraging insights from past event data and performance trends. This guidance is provided through the Smart Suggestion feature during event creation.  
* Analytics can help the host view user feedback on their events and give a summary of overall feedback of events.

# 

# 

# 

#### **Key Analytics Metrics**

**Admin View for all events:**

1. Average Rating over time  
   Shows the average rating of all events for each month over time.  
   Could be used for:

   * Track overall event quality trends.

   * See periods of improvement or decline in event satisfaction.

2. Capacity and Attendance rations  
   Shows 2 ratios for each month: Capacity ratio which shows how much of the venue was filled and the Attendance ratio which shows how many people who rsvpd to the event actually showed up.  
   Could be used for:

   * See the efficiency of venue utilisation.

   * Identify overbooking/underbooking issues.

   * Optimise locations for future events.

3. Feedback ratio over time  
   Shows the percentage of people who provided feedback after each event  
   Could be used for:  
   * See user engagement for the app and events.

4. RSVP ratio over time  
   Shows the proportion of rsvps relative to the total number of potential attendees  
   Could be used for:

   * See how compelling events are to potential attendees.

   * See how effective event invitations are.

   * See which events were more popular among users.

5. Total event duration per month  
   Shows the total number of hours of event durations of all events that occurred each month  
   Could be used for:

   * Track overall volume of events on the app

   * See seasonal trends in scheduling.

   * See app growth and usage over time.

6. Rating distribution  
   Shows the highest, median, and lowest ratings for all events each month  
   Could be used for:

   * Identify outliers.

   * Understand the range and distribution of event quality.

7. Skewness over time  
   Indicates whether ratings tend to be concentrated on the more positive or negative side for each month for all events  
   Could be used for:

   * See the distribution of ratings besides just the average.

   * See if there’s a consistent bias towards higher or lower ratings.

   * Detect changes in rating patterns.

**Admin view for specific host:**

1. Average rating over time  
   Shows the average rating of all events hosted by that user for each month  
   Could be used for:

   * Track host’s performance trends

   * Identify hosts that consistently get high or low ratings

   * Compare the host’s performance against the over platform

2. Rating distribution  
   Shows the highest, median and lowest ratings for all events by the specific host each month  
   Could be used for:

   * Understand the range and consistency of a host’s event quality

   * Identify if the host has consistent bad events or good events

   * See patterns in host’s performance (improvement over time, etc.)

3. Feedback distribution  
   Shows the percentage of attendees who provided feedback after the event ended  
   Could be used for:

   * See if the host has the ability to encourage feedback

   * See overall engagement levels for the host

### **Benefits of Analytics**

#### **For Admin:**

* **Comprehensive Oversight**: Admins can monitor the overall performance of events, ensuring quality and engagement across the platform.  
* **Data-Driven Decision Making**: Access to detailed analytics enables admins to identify trends, assess user behaviour, and make informed decisions regarding platform improvements.

#### **For Host:**

* **Enhanced Event Planning**: Hosts can utilise performance insights to optimise future events, enhancing attendee experience and satisfaction.  
* **Targeted Improvements**: By understanding attendee preferences and feedback, hosts can make data-driven adjustments to their event strategies, leading to increased attendance and positive ratings.

**Implementation**

## APPROACH 1 “EXTERNAL  ANALYTICS SYSTEM”:

**Description:**  
This approach leverages Google Analytics for data collection, Firebase dashboard for visualisation, and integrates with other tools for enhanced data management and analysis.

**Implementation:**

#### **Types of Data to be Collected**

## 

**1\. User Engagement Metrics:**

1.1 Active Users\*\*: Measures the number of unique users engaging with the app daily/weekly. 

**Implementation:**

Automatically tracked by Firebase analytics through user identifiers.

1.2 Session Duration\*\*: Tracks the average time users spend on the app per session. 

# 

**Implementation:**

Automatically tracked by Firebase analytics.

## 

**2\. Event Interactions:**

# 

2.1 Clicks, Views, and RSVPs\*\*: Logs the number of interactions users have with events, such as clicking on event details, viewing event pages, or responding to invitations.

**Implementation:**

Custom events logged using Firebase analytics. Example events might include `new_vs_returning_users`,`user_retention`, and `detailed_event_clicks`.

# 

2.2 Cancellations\*\*: Records the number of times users cancel their event RSVPs. 

**Implementation:**

Custom event for cancellations, e.g.,`event_cancellations`

## 

**3\. Event Popularity Metrics:**

**All of these below would be tracked as custom events in google analytics**

* **Event Views**: Measures the number of views or clicks on event details, providing insights into event interest.

#### **Scalability Considerations**

* For the WhatsOn@UP analytics system, we will initially leverage the Supabase database, Firebase Analytics (free tier), and BigQuery (free tier) to handle our data collection and visualisation needs. This approach is cost-effective and well-suited for our immediate requirements. However, as our data volume grows and analytics needs become more complex, scaling will be necessary. To accommodate future growth, we could implement ETL (Extract, Transform, Load) processes to migrate data from Firebase Analytics into a more scalable data warehouse or data lake, such as Google BigQuery or AWS Redshift. This will facilitate handling larger datasets and performing more sophisticated queries. Additionally, if real-time data analysis becomes crucial, we may incorporate stream processing tools like Google Cloud Dataflow to manage and analyse data in real time.

* However, it is crucial to keep in mind that just like most tools, Firebase Analytics has limitations. In this scenario, there are limitations on the number of hits per month or complexity in custom reporting.Nonetheless, if we manage to keep the hits down then we should be able to cater to the 50 000 users requirement for out project See below:

#### **Visualization and Rendering of Analytics**

**Visualisation Tools:**

## 

1. **Google Data Studio**:  
   * **Features**: Free and integrates with Google Analytics. Allows for the creation of interactive dashboards and detailed reports.  
   * **Visualisations**: Includes line charts for active users, histograms for session duration, bar charts for event interactions, and pie charts for event popularity metrics.

   ## 

2. **FL Chart (Flutter Package)**:  
   * **Features**: Provides customizable charts directly within the Flutter app for real-time data visualisation.  
   * **Usage**: Suitable for embedding interactive charts into the app’s analytics dashboard.

   ## 

3. **Syncfusion Flutter Charts (Flutter Package)**:  
   * **Features**: Offers advanced charting capabilities for more complex visualisations within the app.  
   * **Usage**: Ideal for detailed data visualisations and complex reporting needs

   ## 

Approach 1 External implementation DFD

## APPROACH 2 “IN-HOUSE ANALYTICS SYSTEM”:

#### **1\. Data Collection**

**Backend Services (Spring Boot/Kotlin)**:

* **Event Tracking**: Implement event tracking in backend services. Each time an event of interest occurs (e.g., user interaction, event RSVP, cancellation), log this event to your database.

* **API Endpoints**: Create API endpoints to capture analytics data. For instance, endpoints to record user interactions, event RSVPs, or session durations.

  Table showing the endpoints associated with approach 1 and 2 implementation

| Functionality | Endpoint name | Endpoint url | Host | Admin |
| :---- | :---- | :---- | :---- | :---- |
|  | get past events | *({{host}}:8084/analytics/host/get\_past\_events)* | x |  |
|  | get aggregate data | *({{host}}:8084/analytics/host/get\_aggregate\_data)* | x |  |
|  | get | *({{host}}:8084/analytics/host/get)* | x |  |
|  | get past events by host | ({{host}}:8084/analytics/admin/get\_past\_events\_by\_host/69ae72bc-8e2b-4400-b608-29f048d4f8c7) |  | x |
|  | get aggregate data by host | *({{host}}:8084/analytics/admin/get\_aggregate\_data\_by\_host/69ae72bc-8e2b-4400-b608-29f048d4f8c7)* |  | x |
|  | get by host | *({{host}}:8084/analytics/admin/get\_by\_host/69ae72bc-8e2b-4400-b608-29f048d4f8c7)* |  | x |
|  | get all past info for all hosts | *({{host}}:8084/analytics/admin/get\_for\_all\_hosts)* |  | x |
|  | get for all events | *({{host}}:8084/analytics/admin/get\_all\_events)* |  | x |
|  | get aggregate for all events | *get aggregate for all events* |  | x |

**Frontend (Flutter)**:

* **Instrumentation**: Add code in Flutter app to capture user interactions and send this data to the backend through the MVVM. This could include tracking button clicks, screen views, session durations, etc.  
* **Data Submission**: Use HTTP requests to send captured data from the frontend to backend API endpoints.

#### **2\. Data Storage**

**Supabase DB**:

* **Database Design**: Design database schemas in Supabase to store various types of analytics data. For example, tables for user interactions, event data, and session logs.  
* **Data Ingestion**: Ensure that your backend services insert data into the Supabase database correctly, capturing all necessary metrics.

#### **3\. Data Processing**

**Backend Services**:

* **Data Aggregation**: Implement logic to aggregate and process the raw data stored in Supabase. This could involve calculating metrics such as active users, average session duration, and event popularity.

#### **4\. Data Visualization and Reporting**

**Custom Dashboard**:

* **Frontend Integration**: Build a custom dashboard within our existing application to visualise the processed data. We can use Flutter for web development or other frameworks compatible with our tech stack.  
* **Visualisation Tools**: Utilise libraries like `syncfusion_flutter_charts` in Flutter to create charts and graphs for your dashboard

#### **5\. Scalability Considerations**

**Database Scaling**:

* **Indexes**: Use indexes in Supabase to optimise query performance for large datasets.  
* **Partitioning**: Implement database partitioning if necessary to handle large volumes of data efficiently.

**Backend Scaling**:

* **Horizontal Scaling**: Ensure that your Spring Boot/Kotlin services are capable of horizontal scaling to handle increased load.  
* **Caching**: Implement caching strategies to reduce database load and improve performance.

[image1]: <data:image/png;base64,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INv5yOSufOrVLhMplWNdf2egymF5sM3pKMeVPxyzLl03yuSa0b/YwfpYmfjAtqLXYOVOgv2peslEGOrV9nFz2ffvf+Cp9Zv+q42DigonqOg+wi8vw79ifPH1bf/ivmc3fGDh+FNzLlh631NnLb57y7S+kcnwQy/+vAMhEkqPbR4knhK55bKUR3pCwEBioOcQ5UCiaE/50jpEmlxmv/YLsPUyepaoy8dcjsvqOwUFK+frkLYKoIf1qT3Tndu0hSMTl971wNptu/b8su33igqCE1RUAI4KbwO1JPKLT7y86U+W3v/MBVevfOTvzrn1nldnDIzvSxNBwrS4ykwPjmUlLJMBEj8dcYsJ00ykSICWDAdgoqB8tG98uXRhAlGI9ZDzVCe529D29N1Fqf44OdDExCSu7OEdjc6XOyu8ExkN387Zcfuap6+qD2kr3iycoKLi7aAlnffs2rvv7z//2tY/WPHoi6fOH3nipvNvW/PszEWje6b1jU7GbaW8KqXVaSJ787E2gF3JK4Jkcuy919+zfK98IFwielsmyUryBHU3lCFELltl6c4J6p99iu/w1s1ohORRG402Zywa3f3Q8xuPbupnFCreBpygouKdRniguHPP3p995tUtfzT65PrPzR167NavLVnz0lcWj+8MPxqi1T4RHhGc21aCNOninQTebdDkgroR0W4mY5oocMLgtCFwRb56shHCpnOZ1NC/18tETn6hvKpPi2mt7lfaSbR/9Im+17ft/EdNJfyKA4ATVFS8izhqz76Jn3x50/bfefD5jX+56O6nr7rgjvseP/vme7ZMzxNEunMgkpeVMxElEyuRJuTh3r+sngE5j/S0XdEXIgcdtJH1cfXuyJxknKbJrr3GvpHJ79x1/2MPPbfx6K07d/9KoZ0qKg4ITlBRcRjgqH0TE+/duXvvzz/9yub/cOeDz5577apH7zhnyZr10wfG9gXipIfSvKVkiR7JGs/hKHcPMKGoYyJ32o4JCGlc2QvkDoXRyr66eGzbkjVPX/7sq5v/OGyXFa61ouIdhxNUVBzmOGrvxMSPbd21532PvfT6n91277rvXrvyke+df/u9T5+1aHzLzEVju6ctpNdZ88TQD28xESkvlAfVaeKQiYC2oCgP7zqI1Ol12YCZC8f3ffWW8U3fWnrfU/OGHr95+LEXT3p2w5Y/2r13308X6l9RMeVwgoqKIxXhNdfwv4nbO4mf27Jj969u3r7r117fvuvXN27d+Y83bNnx269s3v476zdt/+cvvr7t95/fuPUPn9uw5d+ue3Xzf1j3yub/2Or8VnhFNv9Aqu6/VxzScIKKioqKim7DCSoqKioqug0nqKioqKjoNpygoqKioqLbcIKKioqKim7DCSoqKioqug0nqKioqKjoNpygoqKioqLbcIKKioqKim7DCSoqKioqug0nqKioqKjoNpygoqKioqLbcIKKioqKim7DCSoqKioqug0nqKioqKjoNpygoqKioqLbcIKKioqKim7DCSoqKioqug0nqKioqKjoNpygoqKioqLbcIKKioqKim7DCSoqKioqug0nqKioqKjoNpygoqKioqLbcIKKioqKim7DCSoqKioqug0nqKioqKjoNpygoqKioqLbcIKKioqKim7j/wc0oiuybu+38AAAAABJRU5ErkJggg==>

[image2]: <data:image/png;base64,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>