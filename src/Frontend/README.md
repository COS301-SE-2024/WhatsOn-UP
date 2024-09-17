# **Firebase Analytics and BigQuery Integration Setup**

This README will guide you through setting up the environment for integrating Firebase Analytics and BigQuery into your local development environment. Follow these steps to get everything working locally and understand what will happen during deployment.

## **Prerequisites**

Before you start, ensure you have the following installed on your local machine:

1. **Google Cloud SDK**: Required for interacting with Google Cloud services.  
2. **Flutter**: Needed for running the Flutter application.  
3. **Android Studio** or **Visual Studio Code**: For Flutter development.  
4. **IntelliJ IDEA** (optional): If you’re working on backend integration with Spring Boot and Kotlin.

## **Local Setup**

### **1\. Set Up Google Cloud SDK**

1. **Install Google Cloud SDK**:  
   * Follow the [installation instructions](https://cloud.google.com/sdk/docs/install) to install the Google Cloud SDK on your local machine.  
2. **Initialize Google Cloud SDK**:

Run the following command to initialize the SDK and authenticate with your Google account:  
bash  
Copy code  
`gcloud init`

*   
3. **Configure Application Default Credentials (ADC)**:

If you're using a local shell, create local authentication credentials for your user account by running:  
bash  
Copy code  
`gcloud auth application-default login`

* A sign-in screen will appear. After you sign in, your credentials are stored in a local credential file used by ADC.

### **2\. Configure the Application**

1. **Install Dependencies**:  
   * Run `flutter pub get` to install all necessary Dart packages.  
   * Ensure your `pubspec.yaml` includes dependencies for Firebase and BigQuery integration.