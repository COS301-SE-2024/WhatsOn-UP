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


