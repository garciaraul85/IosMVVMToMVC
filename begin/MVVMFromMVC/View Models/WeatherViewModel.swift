//In MVVM, the view controller doesn’t call any services or manipulate any model types. That responsibility falls exclusively to the view model.

//You’ll start your refactor by moving code related to the geocoder and Weatherbit service from WeatherViewController into the WeatherViewModel. Then, you’ll bind views to the view model properties in WeatherViewController.

// 1: First, add an import for UIKit.UIImage. No other UIKit types need to be permitted in the view model. A general rule of thumb is to never import UIKit in your view models.
import UIKit.UIImage

// 2
public class WeatherViewModel{
  // The code above will make the app display “Loading…” on launch till a location has been fetched.
  let locationName = Box("Loading ...")
  // 2: defaultAddress sets a default address.
  private static let defaultAddress = "Anchorage, AK"
  
  // 1: geocoder takes a String input such as Washington DC and converts it to a latitude and longitude that it sends to the weather service.
  private let geocoder = LocationGeocoder()
  
  // 3: DateFormatter formats the date display.
  private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d"
    return dateFormatter
  }()
  
  // It’s initially a blank string and updates when the weather data arrives from the Weatherbit API.
  let date = Box(" ")
  
  // 4: Finally, NumberFormatter helps present the temperature as an integer value
  private let tempFormatter: NumberFormatter = {
    let tempFormatter = NumberFormatter()
    tempFormatter.numberStyle = .none
    return tempFormatter
  }()
  
  let icon: Box<UIImage?> = Box(nil)
  let summary = Box(" ")
  let forecastSummary = Box(" ")
  
  init() {
    changeLocation(to: Self.defaultAddress)
  }
  
  // This code changes locationName.value to “Loading…” prior to fetching via geocoder. When geocoder completes the lookup, you’ll update the location name and fetch the weather information for the location.
  func changeLocation(to newLocation: String) {
    locationName.value = "Loading ..."
    geocoder.geocode(addressString: newLocation) { [weak self] locations in
      guard let self = self else { return }
      if let location = locations.first {
        self.locationName.value = location.name
        self.fetchWeatherForLocation(location)
        return
      }
      // This code makes sure no weather data is shown if no location is returned from the geocode call.
      self.locationName.value = "Not found"
      self.date.value = ""
      self.icon.value = nil
      self.summary.value = ""
      self.forecastSummary.value = ""
    }
  }
  
  func fetchWeatherForLocation(_ location: Location) {
    //1: Calls the weather service and passes it the location’s latitude and longitude.
    WeatherbitService.weatherDataForLocation(
      latitude: location.latitude,
      longitude: location.longitude) { [weak self] (weatherData, error) in
      //2: Updates the views with the weather data provided by the weather service callback.
      guard
        let self = self,
        let weatherData = weatherData
      else {
        return
      }
      print(location.latitude)
      // updates date whenever the weather data arrives.
      // This code formats the different weather items for the view to present them.
      self.date.value = self.dateFormatter.string(from: weatherData.date)
      self.icon.value = UIImage(named: weatherData.iconName)
      let temp = self.tempFormatter
        .string(from: weatherData.currentTemp as NSNumber) ?? ""
      print("\(weatherData.description) - \(temp)℉")
      self.summary.value = "\(weatherData.description) - \(temp)℉"
      self.forecastSummary.value = "\nSummary: \(weatherData.description)"
    }
  }
  
}
