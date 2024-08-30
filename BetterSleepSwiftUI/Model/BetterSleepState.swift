import Foundation

/// In MVI, the model represents the state of the entire view
struct BetterSleepState {
	var wakeUp: Date
	var sleepAmount: Double
	var coffeeAmount: Int
	var idealBedtime: String
}
