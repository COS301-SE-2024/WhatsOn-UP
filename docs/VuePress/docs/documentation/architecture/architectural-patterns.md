## Architectural Patterns used

| Architectural Pattern | Quality requirements it covers |
| :---- | :---- |
| Service-Oriented Architecture (SOA) | Scalability,Availability  |
| Event-Driven Architecture (EDA)  | Performance   |
| Load Balancer | Availability ,security,Scalability(the api gateway would also act as a load balancer) |
| API Gateway | Security,Scalability |
| MVVM | Usability |

#### 

## Architectural Design Explanation 

#### 1. Service-Oriented Architecture (SOA)

1.1 Enables the use of **heterogeneous services** \- not all services need to use the same technologies or protocols, and can be language neutral.

1.2 **More manageable than the microservices architecture** (events are allowed to directly communicate with one another, if necessary, and have a central database).

        1.2.1 The same data is required in different aspects (encapsulated by services) of the application. E.g. the notification, navigation, and event management services largely depend on the same data.
        1.2.2 No need to worry about data consistency between services (which would have been an issue when using microservices)
1.3 The benefits of horizontal and independent scaling of services enhance **scalability**, leading to improved performance and flexibility.

1.4 **Availability** is also improved since services rely less on one another (ideally not at all).

1.5 Two complexities that come with the use of SOA include:

    1.5.1 (I) communication between services
    1.5.2 (II) centralised and authorised access of  services

#### 2. Event-Driven Architecture (EDA)

2.1 Chosen for communication between services, as opposed to Enterprise Service Bus (ESB).

    2.1.1 These patterns are mostly the same as they both facilitate indirect communication of heterogeneous services.
    2.1.2 In both, a service does not need to know about the implementation details of another service.

    2.1.3 The Architectures differ in a few key areas:
        2.1.3.1 ESB makes use of messages while EDA makes use of asynchronous events - this allows services to be able to respond to events in real time - increasing system performance .
        2.1.3.2  The ESB can incorporate additional functionality such as load balancing and managing security policies - allowing for user authentication and authorization.
        2.1.3.3 The main advantage of EDA over ESB is that EDA better supports the decoupling of services. ESB creates a bottleneck and a potential single point of failure.
        2.1.3.4 ESB’s centralization means that it manages the routing, ensuring messages reach their destination, and possibly transformation of messages between protocols, amongst other potential functionality mentioned above. If this fails, then all the services which rely on the  mediator (Bus) for communication will also be impacted.
        2.1.3.5 EDA’s decentralisation means that the services themselves are responsible for emitting and reacting to events, rather than it just being the sole responsibility of the mediator (event broker).

####  3. Load Balancer (LB)

3.1 This is used to control and direct traffic to the various services of the system.

3.2 This is useful for when instances are experiencing issues or high usage since requests can be distributed evenly to other resources in order to reduce the load experienced by any one service, increasing the system’s fault tolerance (and therefor it’s **availability**).

3.3 The load balancer is also able to filter out any ‘malicious requests’ commonly seen in Denial of Service (DoS) attacks \- again aiding in the **availability**, as well as the **security** of the system.

#### API Gateway

4.1 Allows a single point of entry into the provided API.

4.2 Acts as a buffer between clients and the backend services - ensuring security.

4.3 Allows for caching results of previous requests. This alleviates the processing that needs to be done by the services, and most importantly reduces the load needed to be processed by the single database instance.

4.4 Gateway offloading can be applied, though will not be used for purposes of this project.

4.5 Can, itself, act as a load-balancer - directing traffic between multiple services.

4.6 Introduces a single point of failure - hence two (or more) can be used


#### 5. Model view view model (MVVM)
5.1 Conforms with the restriction of having to use Flutter.

5.2 Addresses the concern of **usability** in the application.

## Architectural constraints

### 1. Technology Constraints
1.1  Sync fusion-university might need to switch from the community licence to a software licence if they want to use the analytics tool integrated in the app.

1.2  Analytics System: For the WhatsOn@UP app, we will initially utilise Supabase, Firebase Analytics (free tier), and BigQuery (free tier) for data collection and visualisation. This setup is cost-effective and fits our immediate needs. However, as the data volume grows and the analytics requirements become more complex, we will need to scale.

         1.2.1 In the future, we may implement ETL (Extract, Transform, Load) processes to migrate data from Firebase Analytics to a more scalable solution like Google BigQuery or AWS Redshift, allowing for larger datasets and more advanced queries.
         1.2.2 If real-time data analysis becomes a priority, tools such as Google Cloud Dataflow could be integrated to manage and analyse real-time data streams.
         1.2.3 It's important to note that Firebase Analytics has limitations, such as hit limits per month and complexity in generating custom reports.

### 2. Compatibility Constraints
 
 2.1 iOS Development Limitations: Due to the lack of necessary hardware, we were unable to develop or test the app for iOS.

 2.2 Android Version Compatibility: Certain older versions of Android (specifically version ___) are incompatible with the app, which affects its functionality on these devices.
 
 2.3 Flutter SDK Compatibility: The app encountered compatibility challenges due to specific limitations of the Flutter SDK version used during development.


