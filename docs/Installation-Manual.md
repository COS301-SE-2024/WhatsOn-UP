<!-----

You have some errors, warnings, or alerts. If you are using reckless mode, turn it off to see inline alerts.
* ERRORs: 0
* WARNINGs: 0
* ALERTS: 2

Conversion time: 1.094 seconds.


Using this Markdown file:

1. Paste this output into your source file.
2. See the notes and action items below regarding this conversion run.
3. Check the rendered output (headings, lists, code blocks, tables) for proper
   formatting and use a linkchecker before you publish this page.

Conversion notes:

* Docs to Markdown version 1.0β37
* Mon Aug 12 2024 00:46:37 GMT-0700 (PDT)
* Source doc: Technical Installation Manual
* Tables are currently converted to HTML tables.
* This document has images: check for >>>>>  gd2md-html alert:  inline image link in generated source and store images to your server. NOTE: Images in exported zip file from Google Docs may not appear in  the same order as they do in your doc. Please check the images!

----->


<p style="color: red; font-weight: bold">>>>>>  gd2md-html alert:  ERRORs: 0; WARNINGs: 0; ALERTS: 2.</p>
<ul style="color: red; font-weight: bold"><li>See top comment block for details on ERRORs and WARNINGs. <li>In the converted Markdown or HTML, search for inline alerts that start with >>>>>  gd2md-html alert:  for specific instances that need correction.</ul>

<p style="color: red; font-weight: bold">Links to alert messages:</p><a href="#gdcalert1">alert1</a>
<a href="#gdcalert2">alert2</a>

<p style="color: red; font-weight: bold">>>>>> PLEASE check and correct alert issues and delete this message and the inline alerts.<hr></p>



# **Technical Installation Manual**


## **Introduction**

This manual provides detailed instructions for cloning and configuring the system. Our application consists of a frontend mobile application, a backend service, smaller services such as storage and notification plugins, and a gateway service. The backend and gateway are built with Spring Boot and Gradle, while the storage and notification services use NestJS. The frontend is developed using Flutter and Dart. All components, except the mobile frontend, are deployed as a single Docker container. The backend can be installed and run in 2 ways. As a docker container or as individual modules.


## **Prerequisites**

Before installing the system, ensure that the following prerequisites are met:



1. **Git**: For cloning the repository.
2. **Docker**: For running the containerized backend services. (Depending on your choice of running the backend).
3. **Flutter SDK**: For building and running the mobile frontend.
4. **Node.js and Java jdk 21**: Required for running NestJS services and backend and gateway services.(Depending on your choice of running the backend)


### **Installation of Prerequisites**


#### **Git**



* **Windows**: Download and install Git from[ Git for Windows](https://gitforwindows.org/). Follow the installation prompts.
* **macOS**: Install Git using Homebrew with the command: `brew install git`.
* **Linux**: Install Git using your package manager, e.g., `sudo apt-get install git` for Debian-based distributions.


#### **Docker**



* **Windows/macOS**: Download and install Docker Desktop from [Docker Desktop](https://www.docker.com/products/docker-desktop/). Follow the installation prompts.
* **Linux**: Install Docker using your package manager, e.g., `sudo apt-get install docker-ce` for Debian-based distributions. Refer to Docker’s official documentation for detailed instructions.


#### **Flutter SDK**



* **Windows/macOS/Linux**: Follow the installation instructions on the [Flutter website](https://docs.flutter.dev/get-started/install/windows/mobile).


#### **Node.js**



* **Windows/macOS/Linux**: Download and install Node.js from[ Node.js official website](https://nodejs.org/).


## **Installation**


### **Cloning the Repository**



1. Open a terminal or command prompt.
    1. Clone the repository using the command: 

        ```
git clone https://github.com/COS301-SE-2024/WhatsOn-UP.git
```


    2. Navigate to the project directory:

        ```
cd WhatsOn-UP
```




### **Running the Docker Container**



1. Ensure Docker is running.
2. Open your terminal
3. Log in to Docker Hub because the image is hosted on a private registry. (Email [devforce.capstone@gmail.com](mailto:devforce.capstone@gmail.com) for the credentials)

    ```
docker login
```


4. Pull the Docker image

    ```
docker pull devforce123/backend
```


5. Run the Docker container: \


    ```
docker run -d --name backend -p 8085:8085 devforce123/backend
```




### **Building and Running Backend and Gateway Services with java sdk**

(Before this email [devforce.capstone@gmail.com](mailto:devforce.capstone@gmail.com) to obtain the environmental variables.)



1. Navigate to the backend directory: \


    ```
cd src/Backend
```


2. Build the services using Gradle

    ```
./gradlew build
```


3. Run the services:

    ```
./gradlew bootRun
```


4. The service will start running on port 8080
5. Navigate to the gateway directory: \


    ```
cd src/gateway
```


6. Build the services using Gradle

    ```
./gradlew build
```


7. Run the services:

    ```
./gradlew bootRun
```


8. The service will start running on port 8085


### **Building and Running Storage and Notification Services**

(Before this email [devforce.capstone@gmail.com](mailto:devforce.capstone@gmail.com) to obtain the .env file.)



1. Navigate to the storage-service directory:

    ```
cd storage-service
```


1. Install dependencies and start the services:

    ```
npm install
npm start
```


9. The service will start running on port 8083
1. Navigate to the notification-service directory:

    ```
cd notification-service
```


1. Install dependencies and start the services:

    ```
npm install
npm start
```


10. The service will start running on port 8081 for the notification endpoints and port 8082 for the websockets.


### **Building and Running the Frontend**



1. Navigate to the Flutter project directory: \


    ```
cd Frontend
```


1. Install dependencies:

    ```
flutter pub get
```


2. Run the Flutter app:

    ```
flutter run
```




## **Deployment/Running**

To deploy and run the system:



1. Ensure all services are running as described above.
2. Access the application via the mobile frontend.
3. For detailed usage instructions, refer to the User Manual.


## **Screenshots**

Include relevant screenshots for each step to improve clarity. For example:



* Backend run output
* 

<p id="gdcalert1" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image1.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert2">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image1.png "image_tooltip")

* 

<p id="gdcalert2" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image2.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert3">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image2.png "image_tooltip")

* Gateway
* Frontend build and run output
* Storage service run output
* Notification service run output