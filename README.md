# TravelUI for iOS

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

An iOS module you can use in your app to offer cool transport stuff to your users.

## Usage

### Configuration - AppDelegate

| Parameters | Type | Required | Description | Example |
| --- | --- |:---:| --- | --- |
| TravelUI.shared.token | String | ✓ | Navitia token (generate a token on [navitia.io](https://www.navitia.io/))| 0de19ce5-e0eb-4524-a074-bda3c6894c19 |
| TravelUI.shared.mainColor | UIColor | ✗ | To set the background and the journey's duration colors  | by default<br/>UIColor(red: 64/255, green: 149/255, blue: 142/255, alpha: 1) |
| TravelUI.shared.originColor | UIColor | ✗ | To set the color of the origin icon and the roadmap departure bloc | by default<br/>UIColor(red: 0, green: 187/255, blue: 117/255, alpha: 1) |
| TravelUI.shared.destinationColor | UIColor | ✗ | To set the color of the destination icon and the roadmap arrival bloc  | by default<br/>UIColor(red: 176/255, green: 3/255, blue: 83/255, alpha: 1) |
| TravelUI.shared.multiNetwork | Boolean | ✗ | To set the display of the network name in the roadmap  | by default false |

#### Example

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        TravelUI.shared.initialize(token: "my-token")
        TravelUI.shared.mainColor = UIColor(red: 64.0/255, green: 149.0/255, blue: 142.0/255, alpha: 1)
        TravelUI.shared.originColor = UIColor(red: 0, green: 187.0/255, blue: 117.0/255, alpha: 1)
        TravelUI.shared.destinationColor = UIColor(red: 176.0/255, green: 3.0/255, blue: 83.0/255, alpha: 1)
        TravelUI.shared.multiNetwork = true
        
        return true
    }    
}
```
### Journeys request - ViewController
| Parameters | Type | Required | Description | Example |
| --- | --- |:---:| --- | --- |
| originId | String | ✓ | Origin coordinates, following the format `lon;lat` | "2.3665844;48.8465337" |
| destinationId | String | ✓ | Destination coordinates, following the format `lon;lat` | "2.2979169;48.8848719" |
| originLabel | String | ✗ | Origin label, if not set the address will be displayed | "Home" |
| destinationLabel | String | ✗ | Destination label, if not set the address will be displayed | "Work" |
| datetime | Date | ✗ | Requested date and time for journey results | Date() |
| datetimeRepresents | String | ✗ | Can be `.departure` (journeys after datetime) or `.arrival` (journeys before datetime). | .departure |
| forbiddenUris | [String] | ✗ | Used to avoid lines, modes, networks, etc in the Journey search (List of navitia uris) | ["commercial_mode:Bus", "line:1"] |
| allowedId | [String] | ✗ | If you want to use only a small subset of the public transport objects in the Journey search (List of navitia uris) | ["commercial_mode:Bus", "line:1"] |
| firstSectionModes | [Enum] | ✗ | List of modes to use at the begining of the journey | [.walking, .car, .bike, .bss, .ridesharing] |
| lastSectionModes | [Enum] | ✗ | List of modes to use at the end of the journey | [.walking, .car, .bike, .bss, .ridesharing] |
| count | Integer | ✗ | The number of journeys that will be displayed | 3 |
| minNbJourneys | Integer | ✗ | The minimum number of journeys that will be displayed | 3 |
| maxNbJourneys | Integer | ✗ | The maximum number of journeys that will be displayed | 10 |
| addPoiInfos | [Enum] | ✗ | Allow the display of the availability in real time for bike share and car park | [.bss\_stands, .car\_park] |
| directPath | Enum | ✗ | To indicate if the journey is direct | .only |

#### Example

```swift
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Init a set of parameters
        var journeysRequest = JourneysRequest(originId: "2.3665844;48.8465337", destinationId: "2.2979169;48.8848719")
        journeysRequest.originLabel = "My Home"
        journeysRequest.firstSectionModes = [.walking, .car, .bike, .bss, .ridesharing]
        journeysRequest.addPoiInfos = [.bssStands, .carPark]
        journeysRequest.count = 5
        
        let bundle = Bundle(identifier: "org.cocoapods.TravelUI")
        let storyboard = UIStoryboard(name: "Journey", bundle: bundle)
        let journeyResultsViewController = storyboard.instantiateInitialViewController() as! ListJourneysViewController
        journeyResultsViewController.journeysRequest = journeysRequest

        // Invoke the screen using a navigation controller
        navigationController?.pushViewController(journeyResultsViewController, animated: true)
    }
}
```

##### Public transport 

```swift
var journeysRequest = JourneysRequest(originId: "2.3665844;48.8465337", destinationId: "2.2979169;48.8848719")
```

##### Bike

```swift
var journeysRequest = JourneysRequest(originId: "2.3665844;48.8465337", destinationId: "2.2979169;48.8848719")
journeysRequest.firstSectionModes = [.bike]
journeysRequest.lastSectionModes = [.bike]
```

##### BSS

```swift
var journeysRequest = JourneysRequest(originId: "2.3665844;48.8465337", destinationId: "2.2979169;48.8848719")
journeysRequest.firstSectionModes = [.bss]
journeysRequest.lastSectionModes = [.bss]
journeysRequest.addPoiInfos = [.bssStands]
```

##### Car

```swift
var journeysRequest = JourneysRequest(originId: "2.3665844;48.8465337", destinationId: "2.2979169;48.8848719")
journeysRequest.firstSectionModes = [.car]
journeysRequest.addPoiInfos = [.car_park]
```

##### Ridesharing

```swift
var journeysRequest = JourneysRequest(originId: "2.3665844;48.8465337", destinationId: "2.2979169;48.8848719")
journeysRequest.firstSectionModes = [.ridesharing]
journeysRequest.lastSectionModes = [.ridesharing]
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## License #

Check out the TravelUI iOS [License](https://github.com/sicardf/TravelUI_iOS/blob/master/LICENSE) here.