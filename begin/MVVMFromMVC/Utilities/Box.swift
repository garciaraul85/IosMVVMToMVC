//Data Binding Using Box
//In MVVM, you need a way to bind view model outputs to the views. To do that, you need a utility that provides a simple mechanism for binding views to output values from the view model. There are several ways to do such bindings:

//Key-Value Observing or KVO: A mechanism for using key paths to observe a property and get notifications when that property changes.
//Functional Reactive Programming or FRP: A paradigm for processing events and data as streams. Apple’s new Combine framework is its approach to FRP. RxSwift and ReactiveSwift are two popular frameworks for FRP.
//Delegation: Using delegate methods to pass notifications when values change.
//Boxing: Using property observers to notify observers that a value has changed.

import Foundation

final class Box<T> {
  //1: Each Box can have a Listener that Box notifies when the value changes.
  typealias Listener = (T) -> Void
  var listener: Listener?
  //2: Box has a generic type value. The didSet property observer detects any changes and notifies Listener of any value update.
  var value: T {
    didSet {
      listener?(value)
    }
  }
  //3: The initializer sets Box‘s initial value.
  init(_ value: T) {
    self.value = value
  }
  //4: When a Listener calls bind(listener:) on Box, it becomes Listener and immediately gets notified of the Box‘s current valu
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
