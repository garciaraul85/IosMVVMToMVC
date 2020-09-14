//This is the view controller you’ll refactor to remove any use of model and service types..

import UIKit

class WeatherViewController: UIViewController {
  // 1: geocoder takes a String input such as Washington DC and converts it to a latitude and longitude that it sends to the weather service.
  private let geocoder = LocationGeocoder()
  // 2: defaultAddress sets a default address.
  private let defaultAddress = "McGaheysville, VA"
  // 3: DateFormatter formats the date display.
  private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d"
    return dateFormatter
  }()
  // 4: Finally, NumberFormatter helps present the temperature as an integer value
  private let tempFormatter: NumberFormatter = {
    let tempFormatter = NumberFormatter()
    tempFormatter.numberStyle = .none
    return tempFormatter
  }()
  
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var currentIcon: UIImageView!
  @IBOutlet weak var currentSummaryLabel: UILabel!
  @IBOutlet weak var forecastSummary: UITextView!
  
  // viewDidLoad() calls geocoder to convert defaultAddress into a Location. The callback uses the return location to fill in cityLabel‘s text. Then, it passes location into fetchWeatherForLocation(_:).
  override func viewDidLoad() {
    geocoder.geocode(addressString: defaultAddress) { [weak self] locations in
      guard
        let self = self,
        let location = locations.first
      else {
        return
      }
      self.cityLabel.text = location.name
      self.fetchWeatherForLocation(location)
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
      self.dateLabel.text =
        self.dateFormatter.string(from: weatherData.date)
      self.currentIcon.image = UIImage(named: weatherData.iconName)
      let temp = self.tempFormatter.string(
        from: weatherData.currentTemp as NSNumber) ?? ""
      self.currentSummaryLabel.text =
        "\(weatherData.description) - \(temp)℉"
      self.forecastSummary.text = "\nSummary: \(weatherData.description)"
    }
  }
}
