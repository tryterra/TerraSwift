# TerraSwift

## !! DEPRECATED: Please use [TerraiOS](https://github.com/tryterra/TerraiOS) instead !!


This library allows developers to connect to TERRA through Swift (implemented with Swift5.0).
This library uses HealthKit for iOS v13+. It thus would not work on iPad or MacOS or any platform that does not support [Apple HealthKit](https://developer.apple.com/health-fitness/). (Must have signing capabilities for Healthkit)

Also must include the following keys in your `Info.plist` file:
`Privacy - Health Share Usage Description` and `Privacy - Health Records Usage Description`

The package must be added as a dependency to your project. This can be done simply by editting your App's dependencies and adding `TerraSwift` as a dependency with the following location: `https://github.com/tryterra/TerraSwift.git`.

You may now import the package using: `import TerraSwift`

## Permissions
As default, we have enabled all our required healthkit HKObjectTypes for the functionality of the whole package. However if there are healthkit parameters for which you do not wish to be included, you may input a custom set of `HKObjectTypes` as a subset of the following:

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
var result: TerraAuthResponse = TerraSwift.connectTerra(dev_id: "YOUR_DEV_ID", xAPIKey: "YOUR_API_KEY")
```

This will return a TerraAuthResponse payload. This object is defined as:

```swift
public struct TerraAuthResponse:Decodable{
    public var status: String = String()
    public var user_id: String = String()
    public var reference_id: String? = nil
}
```

You can extract the user_id  as: let user_id = result.user_id . You should save this user_id to associate the user who authentIcated with data we send you. You may now create a Terra class as such:
```swift
var TerraClient: TerraSwift.Terra = try! TerraSwift.Terra(dev_id: "YOUR_DEV_ID", xAPIKey: "YOUR_API_KEY", auto: true, readTypes: "YOUR_CUSTOM_HKOBJECT_SET")
```

Please note this initialisation can throw an error. Please catch this error and handle it appropriately:
- HealthKit Unavailable
- Unexpected Error

Upon initializing, the Client will automatically push workout details of the user to your callback url everytime they open your application. It will also automatically push Daily, Sleep, and Body Data to your callback url every 8 hours. However this can only occur when the user enters your application. This feature is controlled by the `auto` parameter. By default, it is set to `true`. However if you wish to make other timed requests, you may create your own timer and use the functions described below while setting `auto` to `false`.

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

## Deauthorize

To deauthorize a user, please follow our Deauthentication Endpoint on the [Docs](https://docs.tryterra.co/authentication-flow).
To make this easier, we have addded a function within the package to this:

```swift
TerraCient.disconnectFromTerra()
```

## Connect to Terra within this SDK

You may if you wish make Terra API request using this SDK as well. 

You will simply need to instantiate a `TerraClient` class as follows:

```swift
let terra: TerraClient = TerraClient(user_id: USER_ID, dev_id: DEVID, xAPIKey: XAPIKEY)
```

Using this client, you may make requests to endpoints such as `/activity`, `/body`, etc. (More info [here](https://docs.tryterra.co/data-endpoints)).

To do this, you simply have to call:

```swift
terra.getDaily(startDate: "TIME INTERVAL", endDate: "TIME INTERVAL" , toWebhook: true)!)
```

You can specify a UNIX TIMESTAMP in Swift as: `Date.timeIntervalSince1970`. `toWebhook` is default set to true.

Simiarly, you can get Activity, Body, and Sleep using `getActivity()`, `getBody()`, and `getSleep()` respectively. They all use the same arguments. 

You may also get Athlete data by `getAthlete(toWebhook: true)` where the date arguments are not needed.

These methods return a payload corresponding to our data models and HTTP responses. 
For example:

```swift
let activityData = terra.getActivity(startDate: startDate.timeIntervalSince1970, endDate: endDate.timeIntervalSince1970)!)
```
In this case you can access the user data by accessing `activityData.user`, user_id by: `activityData.user.user_id` and the data array by `activityData.data`. This is similar to the structure returned by our Payloads

```json
{
    "status": "success",
    "type": "activity",
    "user": {
        "user_id": "b3a63gegd-ege1-42bf-a8ff-f6f1fege6e2a26",
        "provider": "GOOGLE",
        "last_webhook_update": "2022-01-12T08:00:00.036208+00:00"
    },
    "data": [...]
}
```

### Authenticate and Deauthenticate User without Widget

This package also embeds the `/authenticateUser` and `/deauthenticateUser` endpoint.

This can be called by using the `TerraAuthClient` class:

```swift 
let terraAuthClient: TerraAuthClient = TerraAuthClient(dev_id: DEVID, xAPIKey: XAPIKEY)
```

And then you can generate an authentication url (code uses FITBIT as an example) by running:

```swift
terraAuthClient.authenticateUser(resource: "FITBIT")
```

You can then deauthenticate a user by:

```swift
terraAuthClient.deauthenticateUser(user_id: "USER_ID")

```
