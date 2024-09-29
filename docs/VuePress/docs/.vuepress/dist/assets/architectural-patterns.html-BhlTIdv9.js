import{_ as t,c as a,e as i,o as s}from"./app-UsG4jlt_.js";const r={};function n(l,e){return s(),a("div",null,e[0]||(e[0]=[i('<h2 id="architectural-patterns-used" tabindex="-1"><a class="header-anchor" href="#architectural-patterns-used"><span>Architectural Patterns used</span></a></h2><table><thead><tr><th style="text-align:left;">Architectural Pattern</th><th style="text-align:left;">Quality requirements it covers</th></tr></thead><tbody><tr><td style="text-align:left;">Service-Oriented Architecture (SOA)</td><td style="text-align:left;">Scalability,Availability</td></tr><tr><td style="text-align:left;">Event-Driven Architecture (EDA)</td><td style="text-align:left;">Performance , security</td></tr><tr><td style="text-align:left;">Load Balancer</td><td style="text-align:left;">Availability ,security,Scalability(the api gateway would also act as a load balancer)</td></tr><tr><td style="text-align:left;">API Gateway</td><td style="text-align:left;">Security,Scalability</td></tr><tr><td style="text-align:left;">MVVM</td><td style="text-align:left;">Usability</td></tr></tbody></table><h4 id="" tabindex="-1"><a class="header-anchor" href="#"><span></span></a></h4><h2 id="architectural-design-explanation-strategies-chapter-13" tabindex="-1"><a class="header-anchor" href="#architectural-design-explanation-strategies-chapter-13"><span>Architectural Design Explanation/Strategies (chapter 13)</span></a></h2><h4 id="service-oriented-architecture-soa" tabindex="-1"><a class="header-anchor" href="#service-oriented-architecture-soa"><span>Service-Oriented Architecture (SOA)</span></a></h4><ul><li>Enables the use of heterogeneous services - not all services need to use the same technologies or protocols, and can be language neutral.</li><li>More manageable than the microservices architecture (events are allowed to directly communicate with one another, if necessary, and have a central database). <ul><li>The same data is required in different aspects (encapsulated by services) of the application. E.g. the notification, navigation, and event management services largely depend on the same data <ul><li>No need to worry about data consistency between services (which would have been an issue when using microservices)</li></ul></li></ul></li><li>Has the benefits of horizontal and independent scaling of services - improving <strong>scalability</strong></li><li><strong>Availability</strong> is also improved since services rely less on one another (ideally not at all)</li><li>Two complexities that come with the use of SOA include: <ul><li>(I) communication between services</li><li>(II) centralised and authorised access of services</li></ul></li></ul><h4 id="event-driven-architecture-eda" tabindex="-1"><a class="header-anchor" href="#event-driven-architecture-eda"><span>Event-Driven Architecture (EDA)</span></a></h4><ul><li>Chosen for communication between services, as opposed to Enterprise Service Bus (ESB). <ul><li>These patterns are mostly the same as they both facilitate indirect communication of heterogeneous services</li><li>In both, a service does not need to know about the implementation details of another service</li><li>The Architectures differ in a few key areas: <ul><li>ESB makes use of messages while EDA makes use of asynchronous events - this allows services to be able to respond to events in real time - increasing system <strong>performance</strong></li><li>The ESB can incorporate additional functionality such as load balancing and managing <strong>security</strong> policies - allowing for user authentication and authorization</li><li>The main advantage of EDA over ESB is that EDA better supports the decoupling of services. ESB creates a bottleneck and a potential single point of failure.</li><li>ESB’s centralization means that it manages the routing, ensuring messages reach their destination, and possibly transformation of messages between protocols, amongst other potential functionality mentioned above. If this fails, then all the services which rely on the mediator (Bus) for communication will also be impacted</li><li>EDA’s decentralisation means that the services themselves are responsible for emitting and reacting to events, rather than it just being the sole responsibility of the mediator (event broker)</li></ul></li></ul></li></ul><h4 id="load-balancer" tabindex="-1"><a class="header-anchor" href="#load-balancer"><span>Load Balancer</span></a></h4><ul><li>This is used to control and direct traffic to the various services of the system</li><li>This is useful for when instances are experiencing issues or high usage since requests can be distributed evenly to other resources in order to reduce the load experienced by any one service, increasing the system’s fault tolerance (and therefor it’s <strong>availability</strong>)</li><li>The load balancer is also able to filter out any ‘malicious requests’ commonly seen in Denial of Service (DoS) attacks - again aiding in the <strong>availability</strong>, as well as the <strong>security</strong> of the system.</li></ul><h4 id="api-gateway" tabindex="-1"><a class="header-anchor" href="#api-gateway"><span>API Gateway</span></a></h4><ul><li>Allows a single point of entry into the provided API</li><li>Acts as a buffer between clients and the backend services - ensuring security</li><li>Allows for caching results of previous requests. This alleviates the processing that needs to be done by the services, and most importantly reduces the load needed to be processed by the single database instance</li><li>Gateway offloading can be applied, though will not be used for purposes of this project</li><li>Can, itself, act as a load-balancer - directing traffic between multiple services</li><li>Introduces a single point of failure - hence two (or more) can be used</li></ul><h4 id="mvvm" tabindex="-1"><a class="header-anchor" href="#mvvm"><span>MVVM</span></a></h4><ul><li>Conforms with the restriction of having to use Flutter</li><li>Addresses the concern of <strong>usability</strong> in the application</li></ul><h2 id="architectural-constraints" tabindex="-1"><a class="header-anchor" href="#architectural-constraints"><span>Architectural constraints</span></a></h2><ol><li>Technology Constraints</li></ol><ul><li><p>Sync fusion-university might need to switch from the community licence to a software licence if they want to use the analytics tool integrated in the app.</p></li><li><h4 id="for-the-whatson-up-analytics-system-we-will-initially-leverage-the-supabase-database-firebase-analytics-free-tier-and-bigquery-free-tier-to-handle-our-data-collection-and-visualisation-needs-this-approach-is-cost-effective-and-well-suited-for-our-immediate-requirements-however-as-our-data-volume-grows-and-analytics-needs-become-more-complex-scaling-will-be-necessary-to-accommodate-future-growth-we-could-implement-etl-extract-transform-load-processes-to-migrate-data-from-firebase-analytics-into-a-more-scalable-data-warehouse-or-data-lake-such-as-google-bigquery-or-aws-redshift-this-will-facilitate-handling-larger-datasets-and-performing-more-sophisticated-queries-additionally-if-real-time-data-analysis-becomes-crucial-we-may-incorporate-stream-processing-tools-like-google-cloud-dataflow-to-manage-and-analyse-data-in-real-time-however-it-is-crucial-to-keep-in-mind-that-just-like-most-tools-firebase-analytics-has-limitations-in-this-scenario-there-are-limitations-on-the-number-of-hits-per-month-or-complexity-in-custom-reporting" tabindex="-1"><a class="header-anchor" href="#for-the-whatson-up-analytics-system-we-will-initially-leverage-the-supabase-database-firebase-analytics-free-tier-and-bigquery-free-tier-to-handle-our-data-collection-and-visualisation-needs-this-approach-is-cost-effective-and-well-suited-for-our-immediate-requirements-however-as-our-data-volume-grows-and-analytics-needs-become-more-complex-scaling-will-be-necessary-to-accommodate-future-growth-we-could-implement-etl-extract-transform-load-processes-to-migrate-data-from-firebase-analytics-into-a-more-scalable-data-warehouse-or-data-lake-such-as-google-bigquery-or-aws-redshift-this-will-facilitate-handling-larger-datasets-and-performing-more-sophisticated-queries-additionally-if-real-time-data-analysis-becomes-crucial-we-may-incorporate-stream-processing-tools-like-google-cloud-dataflow-to-manage-and-analyse-data-in-real-time-however-it-is-crucial-to-keep-in-mind-that-just-like-most-tools-firebase-analytics-has-limitations-in-this-scenario-there-are-limitations-on-the-number-of-hits-per-month-or-complexity-in-custom-reporting"><span>For the WhatsOn@UP <strong>analytics system</strong>, we will initially leverage the Supabase database, Firebase Analytics (free tier), and BigQuery (free tier) to handle our data collection and visualisation needs. This approach is cost-effective and well-suited for our immediate requirements. However, as our data volume grows and analytics needs become more complex, scaling will be necessary. To accommodate future growth, we could implement ETL (Extract, Transform, Load) processes to migrate data from Firebase Analytics into a more scalable data warehouse or data lake, such as Google BigQuery or AWS Redshift. This will facilitate handling larger datasets and performing more sophisticated queries. Additionally, if real-time data analysis becomes crucial, we may incorporate stream processing tools like Google Cloud Dataflow to manage and analyse data in real time.However, it is crucial to keep in mind that just like most tools, Firebase Analytics has limitations. In this scenario, there are limitations on the number of hits per month or complexity in custom reporting.</span></a></h4></li></ul><ol start="2"><li>Compatibility Constraints</li></ol><ul><li>The inability to develop for IOS as we did not have the resources to develop as none of the project members had the hardware to develop it.</li><li>Some android version are not compatible with the app .To be specific version ( ).</li><li>Flutter sdk incompatibility constraint</li></ul><ol start="3"><li>Budget constraint</li></ol><ul><li>Only allocated R1000 for project day set up.</li></ul>',21)]))}const c=t(r,[["render",n],["__file","architectural-patterns.html.vue"]]),d=JSON.parse('{"path":"/documentation/architecture/architectural-patterns.html","title":"","lang":"en-US","frontmatter":{},"headers":[{"level":2,"title":"Architectural Patterns used","slug":"architectural-patterns-used","link":"#architectural-patterns-used","children":[]},{"level":2,"title":"Architectural Design Explanation/Strategies (chapter 13)","slug":"architectural-design-explanation-strategies-chapter-13","link":"#architectural-design-explanation-strategies-chapter-13","children":[]},{"level":2,"title":"Architectural constraints","slug":"architectural-constraints","link":"#architectural-constraints","children":[]}],"git":{"updatedTime":null,"contributors":[]},"filePathRelative":"documentation/architecture/architectural-patterns.md"}');export{c as comp,d as data};
