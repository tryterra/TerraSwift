# TerraSwift

This library allows developers to connect to TERRA ENABLING DEVELOPERS LTD. through Swift (implemented with Swift5.0).
This library uses HealthKit for iOS v13+. It thus would not work on iPad or MacOS or any platform that does not support [Apple HealthKit](https://developer.apple.com/health-fitness/). (Must have signing capabilities for Healthkit and enable Background Delivery)

The package must be added as a dependency to your project. This can be done simply by editting your App's dependencies and adding `TerraSwift` as a dependency with the following location: `https://github.com/tryterra/TerraSwift.git`.

You may now import the package using: `import TerraSwift`

## Permissions
As default, we have enabled all our required healthkit HKObjectTypes for the functionality of the whole package. However if there are healthkit parameters for which you do not wish to be included, you may input a custom set of HKObjectTypes as a subset of the following:

- Workouts
- Activity Summary 
- Active Energy Burnt
- Step Count
- Heart Rate
- Heart Rate Variability in SDNN
- Vo2Max
- Height
- Apple Exercise Time
- Body Mass
- Flights Climbed
- Body Mass Index
- Body Fat Percentage
- Distance Swimming
- Distance Cycling
- Distance Walking/Running
- Biological Sex
- Date of Birth
- Basal Energy Burned
- Swimming Stroke Count
- Resting Heart Rate
- Blood Pressure Diastolic
- Blood Pressure Systolic
- Body Temperature
- Lean Body Mass
- Oxygen Saturation
- Sleep Analysis
- Respiratory Rate
- Workout Route

This set can then passed as the parameter `readTypes` when initiating the Terra Client as shown below.

## Usage
Start by connecting to Terra through our API as documented [here](https://docs.tryterra.co). To make this easier, there is a function provided by this package which allows your users to connect with Terra. By simply giving us your `dev-id` and `X-API-Key` that we provide for you when you sign up with us, you can register a user by simply running this function:


```swift
var userId: String = TerraSwift.connectTerra(dev_id: "YOUR_DEV_ID", xAPIKey: "YOUR_API_KEY")
```

This will return a userId for which you may now use to acquire data with.

Using this user ID, you may now create a Terra Client as such:

```swift
var TerraClient: TerraSwift.Terra = TerraSwift.Terra(user_id: user_id, dev_id: "YOUR_DEV_ID", xAPIKey: "YOUR_API_KEY", auto: true, readTypes: "YOUR_CUSTOM_HKOBJECT_SET")
```

Upon initializing, the Client will automatically push workout details of the user to your callback url every 20 minutes. If the Healthkit Background Delivery is enabled, the workout details will be pushed upon workout update instead. It will also automatically push Daily, Sleep, and Body Data to your callback url every 8 hours. However this can only occur when the user enters your application. This feature is controlled by the `auto` parameter. By default, it is set to `true`. However if you wish to make other timed requests, you may create your own timer and use the functions described below while setting `auto` to `false`.

## Requests

You may also request for specific data from specific days using the built in functions.

The following functions will push data to your webhook URL from between the given `startDate` and `endDate` parameters:

### Body Data
```swift
TerraClient.getBody(startDate: Date, endDate: Date)
```

### Daily Data
```swift
TerraClient.getDaily(startDate: Date, endDate: Date)
```

### Sleep Data
```swift
TerraClient.getSleep(startDate: Date, endDate: Date)
```

### Activity Data
```swift
TerraClient.getWorkout(startDate: Date, endDate: Date)
```

The following function will push athlete data to your webhook URL. (No parameters required)

### For Athlete Data
```swift
TerraClient.getAthlete()
```
