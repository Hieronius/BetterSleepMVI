import CoreML
import SwiftUI

/// The ViewModel in MVI acts as an intent handler that processes intents and updates the state. It should be responsible for applying intents to the model and notifying the view of state changes
final class BetterSleepViewModel: ObservableObject {

	// MARK: - Published Properties

	@Published private(set) var state: BetterSleepState

	// MARK: - Static Properties

	static var defaultWakeTime: Date {
		var components = DateComponents()
		components.hour = 7
		components.minute = 0
		return Calendar.current.date(from: components) ?? .now
	}

	// MARK: - Initialization

	init() {
		state = BetterSleepState(
			wakeUp: BetterSleepViewModel.defaultWakeTime,
			sleepAmount: 8.0,
			coffeeAmount: 1,
			idealBedtime: ""
		)
		handleIntent(.calculateBedtime)
	}

	// MARK: - Public Methods

	func handleIntent(_ intent: BetterSleepIntent) {
		switch intent {
		case .setWakeUp(let date):
			state.wakeUp = date
			handleIntent(.calculateBedtime)
		case .setSleepAmount(let amount):
			state.sleepAmount = amount
			handleIntent(.calculateBedtime)
		case .setCoffeeAmount(let amount):
			state.coffeeAmount = amount
			handleIntent(.calculateBedtime)
		case .calculateBedtime:
			state.idealBedtime = calculateBedtime()
		}
	}

	// MARK: - Private Methods

	private func calculateBedtime() -> String {
		guard state.sleepAmount >= 0, state.coffeeAmount >= 0 else {
			return "Some error in calculation has been detected"
		}
		do {
			let config = MLModelConfiguration()
			let model = try SleepCalculator(configuration: config)

			let components = Calendar.current.dateComponents([.hour, .minute], from: state.wakeUp)
			let hour = (components.hour ?? 0) * 60 * 60
			let minute = (components.minute ?? 0) * 60

			let prediction = try model.prediction(
				wake: Double(hour + minute),
				estimatedSleep: state.sleepAmount,
				coffee: Double(state.coffeeAmount)
			)

			let sleepTime = state.wakeUp - prediction.actualSleep
			return sleepTime.formatted(date: .omitted, time: .shortened)

		} catch {
			return "Some error in calculation has been detected"
		}
	}
}
