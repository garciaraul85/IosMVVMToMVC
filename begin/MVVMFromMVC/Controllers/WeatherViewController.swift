//This is the view controller you’ll refactor to remove any use of model and service types..

import UIKit

class WeatherViewController: UIViewController {
  
  private let viewModel = WeatherViewModel()
  
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
  
  // This code binds cityLabel.text to viewModel.locationName.
  override func viewDidLoad() {
    viewModel.locationName.bind { [weak self] locationName in
      self?.cityLabel.text = locationName
    }
  }
  
}
