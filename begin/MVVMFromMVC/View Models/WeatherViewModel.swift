//In MVVM, the view controller doesn’t call any services or manipulate any model types. That responsibility falls exclusively to the view model.

//You’ll start your refactor by moving code related to the geocoder and Weatherbit service from WeatherViewController into the WeatherViewModel. Then, you’ll bind views to the view model properties in WeatherViewController.

// 1: First, add an import for UIKit.UIImage. No other UIKit types need to be permitted in the view model. A general rule of thumb is to never import UIKit in your view models.
import UIKit.UIImage

// 2
public class WeatherViewModel{
  // The code above will make the app display “Loading…” on launch till a location has been fetched.
  let locationName = Box("Loading ...")
  // 2: defaultAddress sets a default address.
  private static let defaultAddress = "McGaheysville, VA"
  
  // 1: geocoder takes a String input such as Washington DC and converts it to a latitude and longitude that it sends to the weather service.
  private let geocoder = LocationGeocoder()
  
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
    }
  }
  
  // The callback does nothing for now, but you’ll complete this method in the next section.
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
    }
  }
  
}
