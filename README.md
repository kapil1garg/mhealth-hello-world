# mhealth-hello-world
A hello world project using the iPhone's step tracker and a Parse backend

## Project description
For my Hello World project, I created an iOS application which pulls step data from the user’s phone, determines whether or not the amount of steps is greater than threshold (default threshold = 1000 steps), and prints “Hello” or “World” accordingly (less than or greater than threshold respectively). Additionally, each time the application receives information from the phone that the user has taken steps, the step counter on the application updates and the step count is pushed to a Parse database using Parse’s native iOS Swift SDK. 

## Running application
1. The project can be downloaded from here: https://github.com/kapil1garg/mhealth-hello-world. The Parse database is already set-up and configured to work with the application, so you will not need to change any settings.
2. This application MUST be deployed on device for step counting to work. To do this, you will need to update the provisioning profile in the XCode project settings with one that has your devices on the profile (see here: https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppDistributionGuide/MaintainingPr ofiles/MaintainingProfiles.html)
3. Once the app is running on your phone (either via cable tether or Ad Hoc .ipa build), make sure that fitness tracking is turned on (see here: http://osxdaily.com/2014/10/08/track-fitness-health-app-iphone/) and the app is approved to use fitness data (see Settings --> Privacy --> Health)
4. Open the app and start tracking. Note: it may take about 30 seconds for readings to first start coming in. It takes some time for the sensor to start registering data.

## Configuring your own Parse DB
1. Create an account on https://parse.com/ and create a new application
2. Navigate to Core and create a new data class with a column for steps (as a number). See below for an example database<br>
![Alt text](/documentation/parse_example.png?raw=true "Example Parse Database")
3. Navigate to App Settings --> Security & Keys in Parse and note the Application ID and Client Key. Then in AppDelegate.Swift, update the keys as shown below:
```
// Initialize Parse.
Parse.setApplicationId("Application ID",
  clientKey: "Client Key")
```
Rebuild and deploy app. Data will now be pushed to your Parse instance. 
