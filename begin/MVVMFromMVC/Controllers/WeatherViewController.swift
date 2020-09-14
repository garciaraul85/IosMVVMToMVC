//This is the view controller you’ll refactor to remove any use of model and service types..

import UIKit

class WeatherViewController: UIViewController {
  
  private let viewModel = WeatherViewModel()
  
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var currentIcon: UIImageView!
  @IBOutlet weak var currentSummaryLabel: UILabel!
  @IBOutlet weak var forecastSummary: UITextView!
  
  // Here you have created bindings for the icon image, the weather summary and forecast summary. Whenever the values inside the boxes change, the view controller will automatically be informed.
  override func viewDidLoad() {
    viewModel.locationName.bind { [weak self] locationName in
      self?.cityLabel.text = locationName
    }
    
    viewModel.date.bind { [weak self] date in
      self?.dateLabel.text = date
    }
    
    viewModel.icon.bind { [weak self] image in
      self?.currentIcon.image = image
    }
    
    viewModel.summary.bind { [weak self] summary in
      self?.currentSummaryLabel.text = summary
    }
    
    viewModel.forecastSummary.bind { [weak self] forecast in
      self?.forecastSummary.text = forecast
    }
  }
  
  @IBAction func promptForLocation(_ sender: Any) {
    //1: Create a UIAlertController with a text field.
    let alert = UIAlertController(
      title: "Choose location",
      message: nil,
      preferredStyle: .alert)
    alert.addTextField()
    //2: Add an action button for Submit. The action passes the new location string to viewModel.changeLocation(to:).
    let submitAction = UIAlertAction(
      title: "Submit",
      style: .default) { [unowned alert, weak self] _ in
        guard let newLocation = alert.textFields?.first?.text else { return }
        self?.viewModel.changeLocation(to: newLocation)
    }
    alert.addAction(submitAction)
    //3: Present the alert.
    present(alert, animated: true)
  }
}
