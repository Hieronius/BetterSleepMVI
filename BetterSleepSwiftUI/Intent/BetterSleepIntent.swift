import Foundation

/// Intents are actions that represent user interactions or events that modify the state. Define an enum to represent these actions
enum BetterSleepIntent {
	case setWakeUp(Date)
	case setSleepAmount(Double)
	case setCoffeeAmount(Int)
	case calculateBedtime
}
