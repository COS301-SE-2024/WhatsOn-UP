import{_ as t,c as a,e as n,o as i}from"./app-3mxE7KKw.js";const s={};function o(r,e){return i(),a("div",null,e[0]||(e[0]=[n(`<h2 id="architectural-design-explanation" tabindex="-1"><a class="header-anchor" href="#architectural-design-explanation"><span>Architectural Design Explanation</span></a></h2><h4 id="_1-service-oriented-architecture-soa" tabindex="-1"><a class="header-anchor" href="#_1-service-oriented-architecture-soa"><span>1. Service-Oriented Architecture (SOA)</span></a></h4><p>1.1 Enables the use of <strong>heterogeneous services</strong> - not all services need to use the same technologies or protocols, and can be language neutral.</p><p>1.2 <strong>More manageable than the microservices architecture</strong> (events are allowed to directly communicate with one another, if necessary, and have a central database).</p><pre><code>    1.2.1 The same data is required in different aspects (encapsulated by services) of the application. E.g. the notification, navigation, and event management services largely depend on the same data.
    1.2.2 No need to worry about data consistency between services (which would have been an issue when using microservices)
</code></pre><p>1.3 The benefits of horizontal and independent scaling of services enhance <strong>scalability</strong>, leading to improved performance and flexibility.</p><p>1.4 <strong>Availability</strong> is also improved since services rely less on one another (ideally not at all).</p><p>1.5 Two complexities that come with the use of SOA include:</p><pre><code>1.5.1 (I) communication between services
1.5.2 (II) centralised and authorised access of  services
</code></pre><h4 id="_2-event-driven-architecture-eda" tabindex="-1"><a class="header-anchor" href="#_2-event-driven-architecture-eda"><span>2. Event-Driven Architecture (EDA)</span></a></h4><p>2.1 Chosen for communication between services, as opposed to Enterprise Service Bus (ESB).</p><pre><code>2.1.1 These patterns are mostly the same as they both facilitate indirect communication of heterogeneous services.
2.1.2 In both, a service does not need to know about the implementation details of another service.

2.1.3 The Architectures differ in a few key areas:
    2.1.3.1 ESB makes use of messages while EDA makes use of asynchronous events - this allows services to be able to respond to events in real time - increasing system performance .
    2.1.3.2  The ESB can incorporate additional functionality such as load balancing and managing security policies - allowing for user authentication and authorization.
    2.1.3.3 The main advantage of EDA over ESB is that EDA better supports the decoupling of services. ESB creates a bottleneck and a potential single point of failure.
    2.1.3.4 ESB’s centralization means that it manages the routing, ensuring messages reach their destination, and possibly transformation of messages between protocols, amongst other potential functionality mentioned above. If this fails, then all the services which rely on the  mediator (Bus) for communication will also be impacted.
    2.1.3.5 EDA’s decentralisation means that the services themselves are responsible for emitting and reacting to events, rather than it just being the sole responsibility of the mediator (event broker).
</code></pre><h4 id="_3-load-balancer-lb" tabindex="-1"><a class="header-anchor" href="#_3-load-balancer-lb"><span>3. Load Balancer (LB)</span></a></h4><p>3.1 This is used to control and direct traffic to the various services of the system.</p><p>3.2 This is useful for when instances are experiencing issues or high usage since requests can be distributed evenly to other resources in order to reduce the load experienced by any one service, increasing the system’s fault tolerance (and therefor it’s <strong>availability</strong>).</p><p>3.3 The load balancer is also able to filter out any ‘malicious requests’ commonly seen in Denial of Service (DoS) attacks - again aiding in the <strong>availability</strong>, as well as the <strong>security</strong> of the system.</p><h4 id="api-gateway" tabindex="-1"><a class="header-anchor" href="#api-gateway"><span>API Gateway</span></a></h4><p>4.1 Allows a single point of entry into the provided API.</p><p>4.2 Acts as a buffer between clients and the backend services - ensuring security.</p><p>4.3 Allows for caching results of previous requests. This alleviates the processing that needs to be done by the services, and most importantly reduces the load needed to be processed by the single database instance.</p><p>4.4 Gateway offloading can be applied, though will not be used for purposes of this project.</p><p>4.5 Can, itself, act as a load-balancer - directing traffic between multiple services.</p><p>4.6 Introduces a single point of failure - hence two (or more) can be used</p><h4 id="_5-model-view-view-model-mvvm" tabindex="-1"><a class="header-anchor" href="#_5-model-view-view-model-mvvm"><span>5. Model view view model (MVVM)</span></a></h4><p>5.1 Conforms with the restriction of having to use Flutter.</p><p>5.2 Addresses the concern of <strong>usability</strong> in the application.</p>`,26)]))}const l=t(s,[["render",o],["__file","architectural-design-strategies.html.vue"]]),h=JSON.parse('{"path":"/documentation/architecture/architectural-design-strategies.html","title":"","lang":"en-US","frontmatter":{},"headers":[{"level":2,"title":"Architectural Design Explanation","slug":"architectural-design-explanation","link":"#architectural-design-explanation","children":[]}],"git":{"updatedTime":1727474067000,"contributors":[{"name":"zdanise","email":"zetdanise89@gmail.com","commits":2}]},"filePathRelative":"documentation/architecture/architectural-design-strategies.md"}');export{l as comp,h as data};
