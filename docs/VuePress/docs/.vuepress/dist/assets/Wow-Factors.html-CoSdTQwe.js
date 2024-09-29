import{_ as i,c as o,e as n,a as t,t as s,o as r}from"./app-3mxE7KKw.js";const l="/assets/Recom-D2MObTjr.png",d="/assets/SmartSuggestion-CI7FhwPy.png",h="/assets/Feedback-CuaMERhI.png",g="/assets/graph1-BszNS2sk.png",p="/assets/graph2-lEhgpo6g.png",c="/assets/graph3-Bh6I6NO7.png",u="/assets/graph4-Dwl9OeLe.png",m="/assets/graph5-1eeStb-B.png",f="/assets/graph6-DpbureFY.png",v="/assets/graph7-D-4BZWPC.png",y="/assets/graph8-CWiK5S6W.png",b="/assets/graph9-G-NlIdNg.png",w="/assets/graph10-DvL3cpBu.png",x="/assets/Picture11-OAwTen3V.png",S="/assets/Picture12-DH-yfsGn.png",k={},A={style:{"text-align":"left"}},T={style:{"text-align":"left"}},C={style:{"text-align":"left"}},I={style:{"text-align":"left"}},F={style:{"text-align":"left"}},D={style:{"text-align":"left"}},P={style:{"text-align":"left"}},E={style:{"text-align":"left"}};function R(a,e){return r(),o("div",null,[e[34]||(e[34]=n('<h1 id="wow-factors" tabindex="-1"><a class="header-anchor" href="#wow-factors"><span>WOW FACTORS</span></a></h1><h2 id="recommendation-system" tabindex="-1"><a class="header-anchor" href="#recommendation-system"><span>Recommendation System</span></a></h2><p>Recommendation algorithm used: <strong>Content-based filtering</strong></p><p><strong>Description:</strong><br> The method is supposed to use attributes of an item and through the interaction the user has with the item the algorithm would decide what content to recommend to the user.</p><p><strong>Implementation:</strong><br> The attributes that we are looking at would be the categories of the event.The user would initially give us their preferences through a survey as they sign up on the app.As the user Saves or even RSVP’s an event it would give us a more refined understanding overtime what events the user has an affinity for.</p><h3 id="algorithm" tabindex="-1"><a class="header-anchor" href="#algorithm"><span>Algorithm</span></a></h3><ol><li><strong>Preference scoring</strong><ol><li>Initial rating is obtained in the survey in which the user chooses a category they would be interested in .The categories chosen will be rated by the user.</li><li>We also have an interaction value in which will give us a more confidence on what events really interests users we get these values through rsvping and saving of events by the user</li><li>If no interaction has been recorder the categories that have been rated initially would be picked</li><li>If we have the preference value and interaction value we can produce the final rating/predicted ratings rating=(interaction preference+survey preference)×binary digit</li></ol></li><li><strong>Sorting Events</strong><ol><li>All events are then sorted in a descending order all events with higher predicted ratings(based on category they fall in) would appear first</li></ol></li><li><strong>Roulette Wheel selection algorithm</strong><ol><li>The fitness will then be determined of each category using the predicted preference scoring of the categories producing a total fitness.(addition of all ratings)</li><li>A random number is generated between 0 to total fitness then the algorithm will iterate over the sorted events adding up their ratings until the sum exceeds the random value.where this occurs that event gets selected</li><li>Special case would be if all the event fitness have a rating of 0 the algorithm will then select random events without using rations</li><li>After selection the event is removed from a list and the process is is repeated until an number of events are selected</li></ol></li></ol><h3 id="how-is-this-algorithm-progressing-overtime-to-create-a-better-user-experience" tabindex="-1"><a class="header-anchor" href="#how-is-this-algorithm-progressing-overtime-to-create-a-better-user-experience"><span>How is this algorithm progressing overtime to create a better user experience?</span></a></h3><p>Through continuous interaction with events in the app the proportion in the context of the total fitness for a certain category will increase the more the user interacts with the category, also affecting the fitness to be weaker for other categories that are not being interacted with.</p><p><img src="'+l+'" alt="Flow Diagram"></p><h1 id="" tabindex="-1"><a class="header-anchor" href="#"><span></span></a></h1><h1 id="-1" tabindex="-1"><a class="header-anchor" href="#-1"><span></span></a></h1><h2 id="analytics-system" tabindex="-1"><a class="header-anchor" href="#analytics-system"><span>Analytics System</span></a></h2><h1 id="analytics-overview" tabindex="-1"><a class="header-anchor" href="#analytics-overview"><span><strong>Analytics Overview</strong></span></a></h1><h4 id="admin-access" tabindex="-1"><a class="header-anchor" href="#admin-access"><span>Admin Access</span></a></h4><ul><li>Admin users have access to analytics for all events within the platform.</li><li>They can also view analytics for specific hosts&#39; events, providing insights into overall performance and user engagement.</li></ul><h4 id="host-access" tabindex="-1"><a class="header-anchor" href="#host-access"><span>Host Access</span></a></h4><ul><li>Hosts can view analytics specifically for their own events, allowing them to track performance metrics and attendee feedback.</li></ul><h4 id="insights-and-recommendations" tabindex="-1"><a class="header-anchor" href="#insights-and-recommendations"><span><strong>Insights and Recommendations</strong></span></a></h4><ul><li>The analytics feature can assist hosts in selecting the optimal venue, time, and date for future events by leveraging insights from past event data and performance trends. This guidance is provided through the Smart Suggestion feature during event creation.</li><li>Analytics can help the host view user feedback on their events and give a summary of overall feedback of events.</li></ul><h1 id="-2" tabindex="-1"><a class="header-anchor" href="#-2"><span></span></a></h1><p><img src="'+d+'" alt="screenshot of smart suggestion"></p><h1 id="-3" tabindex="-1"><a class="header-anchor" href="#-3"><span></span></a></h1><p><img src="'+h+'" alt="screenshot of Feedback section"></p><h1 id="-4" tabindex="-1"><a class="header-anchor" href="#-4"><span></span></a></h1><h4 id="key-analytics-metrics" tabindex="-1"><a class="header-anchor" href="#key-analytics-metrics"><span><strong>Key Analytics Metrics</strong></span></a></h4><p><strong>Admin View for all events:</strong></p><ol><li><p>Average Rating over time<br> Shows the average rating of all events for each month over time.<br> Could be used for:</p><ul><li><p>Track overall event quality trends.</p></li><li><p>See periods of improvement or decline in event satisfaction.</p></li></ul></li></ol><p><img src="'+g+'" alt="graph 1"></p><ol start="2"><li><p>Capacity and Attendance rations<br> Shows 2 ratios for each month: Capacity ratio which shows how much of the venue was filled and the Attendance ratio which shows how many people who rsvpd to the event actually showed up.<br> Could be used for:</p><ul><li><p>See the efficiency of venue utilisation.</p></li><li><p>Identify overbooking/underbooking issues.</p></li><li><p>Optimise locations for future events.</p></li></ul></li></ol><p><img src="'+p+'" alt="graph 2"></p><ol start="3"><li><p>Feedback ratio over time<br> Shows the percentage of people who provided feedback after each event<br> Could be used for:</p><ul><li>See user engagement for the app and events.</li></ul></li></ol><p><img src="'+c+'" alt="graph 3"></p><ol start="4"><li><p>RSVP ratio over time<br> Shows the proportion of rsvps relative to the total number of potential attendees<br> Could be used for:</p><ul><li><p>See how compelling events are to potential attendees.</p></li><li><p>See how effective event invitations are.</p></li><li><p>See which events were more popular among users.</p></li></ul></li></ol><p><img src="'+u+'" alt="graph 4"></p><ol start="5"><li><p>Total event duration per month<br> Shows the total number of hours of event durations of all events that occurred each month<br> Could be used for:</p><ul><li><p>Track overall volume of events on the app</p></li><li><p>See seasonal trends in scheduling.</p></li><li><p>See app growth and usage over time.</p></li></ul></li></ol><p><img src="'+m+'" alt="graph 5"></p><ol start="6"><li><p>Rating distribution<br> Shows the highest, median, and lowest ratings for all events each month<br> Could be used for:</p><ul><li><p>Identify outliers.</p></li><li><p>Understand the range and distribution of event quality.</p></li></ul></li></ol><p><img src="'+f+'" alt="graph 6"></p><ol start="7"><li><p>Skewness over time<br> Indicates whether ratings tend to be concentrated on the more positive or negative side for each month for all events<br> Could be used for:</p><ul><li><p>See the distribution of ratings besides just the average.</p></li><li><p>See if there’s a consistent bias towards higher or lower ratings.</p></li><li><p>Detect changes in rating patterns.</p></li></ul></li></ol><p><img src="'+v+'" alt="graph 7"></p><p><strong>Admin view for specific host:</strong></p><ol><li><p>Average rating over time<br> Shows the average rating of all events hosted by that user for each month<br> Could be used for:</p><ul><li><p>Track host’s performance trends</p></li><li><p>Identify hosts that consistently get high or low ratings</p></li><li><p>Compare the host’s performance against the over platform</p></li></ul></li></ol><p><img src="'+y+'" alt="graph 8"></p><ol start="2"><li><p>Rating distribution<br> Shows the highest, median and lowest ratings for all events by the specific host each month<br> Could be used for:</p><ul><li><p>Understand the range and consistency of a host’s event quality</p></li><li><p>Identify if the host has consistent bad events or good events</p></li><li><p>See patterns in host’s performance (improvement over time, etc.)</p></li></ul></li></ol><p><img src="'+b+'" alt="graph 9"></p><ol start="3"><li><p>Feedback distribution<br> Shows the percentage of attendees who provided feedback after the event ended<br> Could be used for:</p><ul><li><p>See if the host has the ability to encourage feedback</p></li><li><p>See overall engagement levels for the host</p></li></ul></li></ol><p><img src="'+w+`" alt="graph 10"></p><h3 id="benefits-of-analytics" tabindex="-1"><a class="header-anchor" href="#benefits-of-analytics"><span><strong>Benefits of Analytics</strong></span></a></h3><h4 id="for-admin" tabindex="-1"><a class="header-anchor" href="#for-admin"><span>For Admin:</span></a></h4><ul><li><strong>Comprehensive Oversight</strong>: Admins can monitor the overall performance of events, ensuring quality and engagement across the platform.</li><li><strong>Data-Driven Decision Making</strong>: Access to detailed analytics enables admins to identify trends, assess user behaviour, and make informed decisions regarding platform improvements.</li></ul><h4 id="for-host" tabindex="-1"><a class="header-anchor" href="#for-host"><span>For Host:</span></a></h4><ul><li><strong>Enhanced Event Planning</strong>: Hosts can utilise performance insights to optimise future events, enhancing attendee experience and satisfaction.</li><li><strong>Targeted Improvements</strong>: By understanding attendee preferences and feedback, hosts can make data-driven adjustments to their event strategies, leading to increased attendance and positive ratings.</li></ul><p><strong>Implementation</strong></p><h2 id="approach-1-external-analytics-system" tabindex="-1"><a class="header-anchor" href="#approach-1-external-analytics-system"><span>APPROACH 1 “EXTERNAL ANALYTICS SYSTEM”:</span></a></h2><p><strong>Description:</strong><br> This approach leverages Google Analytics for data collection, Firebase dashboard for visualisation, and integrates with other tools for enhanced data management and analysis.</p><p><strong>Implementation:</strong></p><h4 id="types-of-data-to-be-collected" tabindex="-1"><a class="header-anchor" href="#types-of-data-to-be-collected"><span><strong>Types of Data to be Collected</strong></span></a></h4><h2 id="-5" tabindex="-1"><a class="header-anchor" href="#-5"><span></span></a></h2><p><strong>1. User Engagement Metrics:</strong></p><pre><code>1.1 Active Users**: Measures the number of unique users engaging with the app daily/weekly. 
</code></pre><p><strong>Implementation:</strong></p><p>Automatically tracked by Firebase analytics through user identifiers.</p><pre><code>1.2 Session Duration**: Tracks the average time users spend on the app per session. 
</code></pre><h1 id="-6" tabindex="-1"><a class="header-anchor" href="#-6"><span></span></a></h1><p><strong>Implementation:</strong></p><p>Automatically tracked by Firebase analytics.</p><h2 id="-7" tabindex="-1"><a class="header-anchor" href="#-7"><span></span></a></h2><p><strong>2. Event Interactions:</strong></p><h1 id="-8" tabindex="-1"><a class="header-anchor" href="#-8"><span></span></a></h1><pre><code>2.1 Clicks, Views, and RSVPs**: Logs the number of interactions users have with events, such as clicking on event details, viewing event pages, or responding to invitations.
</code></pre><p><strong>Implementation:</strong></p><p>Custom events logged using Firebase analytics. Example events might include <code>new_vs_returning_users</code>,<code>user_retention</code>, and <code>detailed_event_clicks</code>.</p><h1 id="-9" tabindex="-1"><a class="header-anchor" href="#-9"><span></span></a></h1><pre><code>2.2 Cancellations**: Records the number of times users cancel their event RSVPs. 
</code></pre><p><strong>Implementation:</strong></p><p>Custom event for cancellations, e.g.,<code>event_cancellations</code></p><h2 id="-10" tabindex="-1"><a class="header-anchor" href="#-10"><span></span></a></h2><p><strong>3. Event Popularity Metrics:</strong></p><p><strong>All of these below would be tracked as custom events in google analytics</strong></p><ul><li><strong>Event Views</strong>: Measures the number of views or clicks on event details, providing insights into event interest.</li></ul><h4 id="scalability-considerations" tabindex="-1"><a class="header-anchor" href="#scalability-considerations"><span><strong>Scalability Considerations</strong></span></a></h4><ul><li><p>For the WhatsOn@UP analytics system, we will initially leverage the Supabase database, Firebase Analytics (free tier), and BigQuery (free tier) to handle our data collection and visualisation needs. This approach is cost-effective and well-suited for our immediate requirements. However, as our data volume grows and analytics needs become more complex, scaling will be necessary. To accommodate future growth, we could implement ETL (Extract, Transform, Load) processes to migrate data from Firebase Analytics into a more scalable data warehouse or data lake, such as Google BigQuery or AWS Redshift. This will facilitate handling larger datasets and performing more sophisticated queries. Additionally, if real-time data analysis becomes crucial, we may incorporate stream processing tools like Google Cloud Dataflow to manage and analyse data in real time.</p></li><li><p>However, it is crucial to keep in mind that just like most tools, Firebase Analytics has limitations. In this scenario, there are limitations on the number of hits per month or complexity in custom reporting.Nonetheless, if we manage to keep the hits down then we should be able to cater to the 50 000 users requirement for out project See below:</p></li></ul><p><img src="`+x+'" alt="picture"></p><h4 id="visualization-and-rendering-of-analytics" tabindex="-1"><a class="header-anchor" href="#visualization-and-rendering-of-analytics"><span><strong>Visualization and Rendering of Analytics</strong></span></a></h4><p><strong>Visualisation Tools:</strong></p><h2 id="-11" tabindex="-1"><a class="header-anchor" href="#-11"><span></span></a></h2><ol><li><strong>Google Data Studio</strong>: <ul><li><strong>Features</strong>: Free and integrates with Google Analytics. Allows for the creation of interactive dashboards and detailed reports.</li><li><strong>Visualisations</strong>: Includes line charts for active users, histograms for session duration, bar charts for event interactions, and pie charts for event popularity metrics.</li></ul><h2 id="-12" tabindex="-1"><a class="header-anchor" href="#-12"><span></span></a></h2></li><li><strong>FL Chart (Flutter Package)</strong>: <ul><li><strong>Features</strong>: Provides customizable charts directly within the Flutter app for real-time data visualisation.</li><li><strong>Usage</strong>: Suitable for embedding interactive charts into the app’s analytics dashboard.</li></ul><h2 id="-13" tabindex="-1"><a class="header-anchor" href="#-13"><span></span></a></h2></li><li><strong>Syncfusion Flutter Charts (Flutter Package)</strong>: <ul><li><strong>Features</strong>: Offers advanced charting capabilities for more complex visualisations within the app.</li><li><strong>Usage</strong>: Ideal for detailed data visualisations and complex reporting needs</li></ul><h2 id="-14" tabindex="-1"><a class="header-anchor" href="#-14"><span></span></a></h2></li></ol><p>Approach 1 External implementation DFD</p><p><img src="'+S+'" alt="Image showing the data flow in the analytics system"></p><h2 id="approach-2-in-house-analytics-system" tabindex="-1"><a class="header-anchor" href="#approach-2-in-house-analytics-system"><span>APPROACH 2 “IN-HOUSE ANALYTICS SYSTEM”:</span></a></h2><h4 id="_1-data-collection" tabindex="-1"><a class="header-anchor" href="#_1-data-collection"><span><strong>1. Data Collection</strong></span></a></h4><p><strong>Backend Services (Spring Boot/Kotlin)</strong>:</p><ul><li><p><strong>Event Tracking</strong>: Implement event tracking in backend services. Each time an event of interest occurs (e.g., user interaction, event RSVP, cancellation), log this event to your database.</p></li><li><p><strong>API Endpoints</strong>: Create API endpoints to capture analytics data. For instance, endpoints to record user interactions, event RSVPs, or session durations.</p><p>Table showing the endpoints associated with approach 1 and 2 implementation</p></li></ul>',94)),t("table",null,[e[33]||(e[33]=t("thead",null,[t("tr",null,[t("th",{style:{"text-align":"left"}},"Functionality"),t("th",{style:{"text-align":"left"}},"Endpoint name"),t("th",{style:{"text-align":"left"}},"Endpoint url"),t("th",{style:{"text-align":"left"}},"Host"),t("th",{style:{"text-align":"left"}},"Admin")])],-1)),t("tbody",null,[t("tr",null,[e[0]||(e[0]=t("td",{style:{"text-align":"left"}},null,-1)),e[1]||(e[1]=t("td",{style:{"text-align":"left"}},"get past events",-1)),t("td",A,[t("em",null,"("+s(a.host)+":8084/analytics/host/get_past_events)",1)]),e[2]||(e[2]=t("td",{style:{"text-align":"left"}},"x",-1)),e[3]||(e[3]=t("td",{style:{"text-align":"left"}},null,-1))]),t("tr",null,[e[4]||(e[4]=t("td",{style:{"text-align":"left"}},null,-1)),e[5]||(e[5]=t("td",{style:{"text-align":"left"}},"get aggregate data",-1)),t("td",T,[t("em",null,"("+s(a.host)+":8084/analytics/host/get_aggregate_data)",1)]),e[6]||(e[6]=t("td",{style:{"text-align":"left"}},"x",-1)),e[7]||(e[7]=t("td",{style:{"text-align":"left"}},null,-1))]),t("tr",null,[e[8]||(e[8]=t("td",{style:{"text-align":"left"}},null,-1)),e[9]||(e[9]=t("td",{style:{"text-align":"left"}},"get",-1)),t("td",C,[t("em",null,"("+s(a.host)+":8084/analytics/host/get)",1)]),e[10]||(e[10]=t("td",{style:{"text-align":"left"}},"x",-1)),e[11]||(e[11]=t("td",{style:{"text-align":"left"}},null,-1))]),t("tr",null,[e[12]||(e[12]=t("td",{style:{"text-align":"left"}},null,-1)),e[13]||(e[13]=t("td",{style:{"text-align":"left"}},"get past events by host",-1)),t("td",I,"("+s(a.host)+":8084/analytics/admin/get_past_events_by_host/69ae72bc-8e2b-4400-b608-29f048d4f8c7)",1),e[14]||(e[14]=t("td",{style:{"text-align":"left"}},null,-1)),e[15]||(e[15]=t("td",{style:{"text-align":"left"}},"x",-1))]),t("tr",null,[e[16]||(e[16]=t("td",{style:{"text-align":"left"}},null,-1)),e[17]||(e[17]=t("td",{style:{"text-align":"left"}},"get aggregate data by host",-1)),t("td",F,[t("em",null,"("+s(a.host)+":8084/analytics/admin/get_aggregate_data_by_host/69ae72bc-8e2b-4400-b608-29f048d4f8c7)",1)]),e[18]||(e[18]=t("td",{style:{"text-align":"left"}},null,-1)),e[19]||(e[19]=t("td",{style:{"text-align":"left"}},"x",-1))]),t("tr",null,[e[20]||(e[20]=t("td",{style:{"text-align":"left"}},null,-1)),e[21]||(e[21]=t("td",{style:{"text-align":"left"}},"get by host",-1)),t("td",D,[t("em",null,"("+s(a.host)+":8084/analytics/admin/get_by_host/69ae72bc-8e2b-4400-b608-29f048d4f8c7)",1)]),e[22]||(e[22]=t("td",{style:{"text-align":"left"}},null,-1)),e[23]||(e[23]=t("td",{style:{"text-align":"left"}},"x",-1))]),t("tr",null,[e[24]||(e[24]=t("td",{style:{"text-align":"left"}},null,-1)),e[25]||(e[25]=t("td",{style:{"text-align":"left"}},"get all past info for all hosts",-1)),t("td",P,[t("em",null,"("+s(a.host)+":8084/analytics/admin/get_for_all_hosts)",1)]),e[26]||(e[26]=t("td",{style:{"text-align":"left"}},null,-1)),e[27]||(e[27]=t("td",{style:{"text-align":"left"}},"x",-1))]),t("tr",null,[e[28]||(e[28]=t("td",{style:{"text-align":"left"}},null,-1)),e[29]||(e[29]=t("td",{style:{"text-align":"left"}},"get for all events",-1)),t("td",E,[t("em",null,"("+s(a.host)+":8084/analytics/admin/get_all_events)",1)]),e[30]||(e[30]=t("td",{style:{"text-align":"left"}},null,-1)),e[31]||(e[31]=t("td",{style:{"text-align":"left"}},"x",-1))]),e[32]||(e[32]=t("tr",null,[t("td",{style:{"text-align":"left"}}),t("td",{style:{"text-align":"left"}},"get aggregate for all events"),t("td",{style:{"text-align":"left"}},[t("em",null,"get aggregate for all events")]),t("td",{style:{"text-align":"left"}}),t("td",{style:{"text-align":"left"}},"x")],-1))])]),e[35]||(e[35]=n('<p><strong>Frontend (Flutter)</strong>:</p><ul><li><strong>Instrumentation</strong>: Add code in Flutter app to capture user interactions and send this data to the backend through the MVVM. This could include tracking button clicks, screen views, session durations, etc.</li><li><strong>Data Submission</strong>: Use HTTP requests to send captured data from the frontend to backend API endpoints.</li></ul><h4 id="_2-data-storage" tabindex="-1"><a class="header-anchor" href="#_2-data-storage"><span><strong>2. Data Storage</strong></span></a></h4><p><strong>Supabase DB</strong>:</p><ul><li><strong>Database Design</strong>: Design database schemas in Supabase to store various types of analytics data. For example, tables for user interactions, event data, and session logs.</li><li><strong>Data Ingestion</strong>: Ensure that your backend services insert data into the Supabase database correctly, capturing all necessary metrics.</li></ul><h4 id="_3-data-processing" tabindex="-1"><a class="header-anchor" href="#_3-data-processing"><span><strong>3. Data Processing</strong></span></a></h4><p><strong>Backend Services</strong>:</p><ul><li><strong>Data Aggregation</strong>: Implement logic to aggregate and process the raw data stored in Supabase. This could involve calculating metrics such as active users, average session duration, and event popularity.</li></ul><h4 id="_4-data-visualization-and-reporting" tabindex="-1"><a class="header-anchor" href="#_4-data-visualization-and-reporting"><span><strong>4. Data Visualization and Reporting</strong></span></a></h4><p><strong>Custom Dashboard</strong>:</p><ul><li><strong>Frontend Integration</strong>: Build a custom dashboard within our existing application to visualise the processed data. We can use Flutter for web development or other frameworks compatible with our tech stack.</li><li><strong>Visualisation Tools</strong>: Utilise libraries like <code>syncfusion_flutter_charts</code> in Flutter to create charts and graphs for your dashboard</li></ul><h4 id="_5-scalability-considerations" tabindex="-1"><a class="header-anchor" href="#_5-scalability-considerations"><span><strong>5. Scalability Considerations</strong></span></a></h4><p><strong>Database Scaling</strong>:</p><ul><li><strong>Indexes</strong>: Use indexes in Supabase to optimise query performance for large datasets.</li><li><strong>Partitioning</strong>: Implement database partitioning if necessary to handle large volumes of data efficiently.</li></ul><p><strong>Backend Scaling</strong>:</p><ul><li><strong>Horizontal Scaling</strong>: Ensure that your Spring Boot/Kotlin services are capable of horizontal scaling to handle increased load.</li><li><strong>Caching</strong>: Implement caching strategies to reduce database load and improve performance.</li></ul>',16))])}const O=i(k,[["render",R],["__file","Wow-Factors.html.vue"]]),V=JSON.parse('{"path":"/documentation/srs/Wow-Factors.html","title":"WOW FACTORS","lang":"en-US","frontmatter":{},"headers":[{"level":2,"title":"Recommendation System","slug":"recommendation-system","link":"#recommendation-system","children":[{"level":3,"title":"Algorithm","slug":"algorithm","link":"#algorithm","children":[]},{"level":3,"title":"How is this algorithm progressing overtime to create a better user experience?","slug":"how-is-this-algorithm-progressing-overtime-to-create-a-better-user-experience","link":"#how-is-this-algorithm-progressing-overtime-to-create-a-better-user-experience","children":[]}]},{"level":2,"title":"Analytics System","slug":"analytics-system","link":"#analytics-system","children":[{"level":3,"title":"Benefits of Analytics","slug":"benefits-of-analytics","link":"#benefits-of-analytics","children":[]}]},{"level":2,"title":"APPROACH 1 “EXTERNAL  ANALYTICS SYSTEM”:","slug":"approach-1-external-analytics-system","link":"#approach-1-external-analytics-system","children":[]},{"level":2,"title":"","slug":"-5","link":"#-5","children":[]},{"level":2,"title":"","slug":"-7","link":"#-7","children":[]},{"level":2,"title":"","slug":"-10","link":"#-10","children":[]},{"level":2,"title":"","slug":"-11","link":"#-11","children":[]},{"level":2,"title":"APPROACH 2 “IN-HOUSE ANALYTICS SYSTEM”:","slug":"approach-2-in-house-analytics-system","link":"#approach-2-in-house-analytics-system","children":[]}],"git":{"updatedTime":1727479678000,"contributors":[{"name":"zdanise","email":"zetdanise89@gmail.com","commits":2}]},"filePathRelative":"documentation/srs/Wow-Factors.md"}');export{O as comp,V as data};
