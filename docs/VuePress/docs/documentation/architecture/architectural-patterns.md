## Architectural Patterns used

| Architectural Pattern | Quality requirements it covers |
| :---- | :---- |
| Service-Oriented Architecture (SOA) | Scalability,Availability  |
| Event-Driven Architecture (EDA)  | Performance , security  |
| Load Balancer | Availability ,security,Scalability(the api gateway would also act as a load balancer) |
| API Gateway | Security,Scalability |
| MVVM | Usability |

#### 

## Architectural Design Explanation/Strategies (chapter 13\)

#### Service-Oriented Architecture (SOA)

* Enables the use of heterogeneous services \- not all services need to use the same technologies or protocols, and can be language neutral.
* More manageable than the microservices architecture (events are allowed to directly communicate with one another, if necessary, and have a central database).
    * The same data is required in different aspects (encapsulated by services) of the application. E.g. the notification, navigation, and event management services largely depend on the same data
        * No need to worry about data consistency between services (which would have been an issue when using microservices)
* Has the benefits of horizontal and independent scaling of services \- improving **scalability**
* **Availability** is also improved since services rely less on one another (ideally not at all)
* Two complexities that come with the use of SOA include:
    * (I) communication between services
    * (II) centralised and authorised access of  services

#### Event-Driven Architecture (EDA)

* Chosen for communication between services, as opposed to Enterprise Service Bus (ESB).
    * These patterns are mostly the same as they both facilitate indirect communication of heterogeneous services
    * In both, a service does not need to know about the implementation details of another service
    * The Architectures differ in a few key areas:
        * ESB makes use of messages while EDA makes use of asynchronous events \- this allows services to be able to respond to events in real time \- increasing system **performance**
        * The ESB can incorporate additional functionality such as load balancing and managing **security** policies \- allowing for user authentication and authorization
        * The main advantage of EDA over ESB is that EDA better supports the decoupling of services. ESB creates a bottleneck and a potential single point of failure.
        * ESB’s centralization means that it manages the routing, ensuring messages reach their destination, and possibly transformation of messages between protocols, amongst other potential functionality mentioned above. If this fails, then all the services which rely on the  mediator (Bus) for communication will also be impacted
        * EDA’s decentralisation means that the services themselves are responsible for emitting and reacting to events, rather than it just being the sole responsibility of the mediator (event broker)

####  Load Balancer

* This is used to control and direct traffic to the various services of the system
* This is useful for when instances are experiencing issues or high usage since requests can be distributed evenly to other resources in order to reduce the load experienced by any one service, increasing the system’s fault tolerance (and therefor it’s **availability**)
* The load balancer is also able to filter out any ‘malicious requests’ commonly seen in Denial of Service (DoS) attacks \- again aiding in the **availability**, as well as the **security** of the system.

#### API Gateway

* Allows a single point of entry into the provided API
* Acts as a buffer between clients and the backend services \- ensuring security
* Allows for caching results of previous requests. This alleviates the processing that needs to be done by the services, and most importantly reduces the load needed to be processed by the single database instance
* Gateway offloading can be applied, though will not be used for purposes of this project
* Can, itself, act as a load-balancer \- directing traffic between multiple services
* Introduces a single point of failure \- hence two (or more) can be used

#### MVVM

* Conforms with the restriction of having to use Flutter
* Addresses the concern of **usability** in the application


## Architectural constraints

1. Technology Constraints
* Sync fusion-university might need to switch from the community licence to a software licence if they want to use the analytics tool integrated in the app.

* #### For the WhatsOn@UP **analytics system**, we will initially leverage the Supabase database, Firebase Analytics (free tier), and BigQuery (free tier) to handle our data collection and visualisation needs. This approach is cost-effective and well-suited for our immediate requirements. However, as our data volume grows and analytics needs become more complex, scaling will be necessary. To accommodate future growth, we could implement ETL (Extract, Transform, Load) processes to migrate data from Firebase Analytics into a more scalable data warehouse or data lake, such as Google BigQuery or AWS Redshift. This will facilitate handling larger datasets and performing more sophisticated queries. Additionally, if real-time data analysis becomes crucial, we may incorporate stream processing tools like Google Cloud Dataflow to manage and analyse data in real time.However, it is crucial to keep in mind that just like most tools, Firebase Analytics has limitations. In this scenario, there are limitations on the number of hits per month or complexity in custom reporting.

2. Compatibility Constraints
* The inability to develop for IOS as we did not have the resources to develop as none of the project members had the hardware to develop it.
* Some android version are not compatible with the app .To be specific version ( ).
* Flutter sdk  incompatibility constraint
3. Budget constraint
* Only allocated R1000 for project day set up.

