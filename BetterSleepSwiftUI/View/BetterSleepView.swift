import SwiftUI

/// The view should interact with the ViewModel by sending intents and observing the state
struct BetterSleepView: View {

	// MARK: - State Properties

	@StateObject private var viewModel = BetterSleepViewModel()

	// MARK: - Body

	var body: some View {

		NavigationView {

			Form {

				// MARK: - Section 1

				Section {
					HStack {
						Text("When do you want to wake up?")
							.font(.headline)

						Spacer()

						// MARK: Intent (action) tool 1

						DatePicker(
							"Please enter a time",
							selection: Binding(
								get: { viewModel.state.wakeUp },
								set: { viewModel.handleIntent(.setWakeUp($0)) }
							),
							displayedComponents: .hourAndMinute
						)
						.labelsHidden()
					}
				}

				// MARK: - Section 2

				Section {
					HStack {
						Text("Desired amount of sleep")
							.font(.headline)
						Spacer()
					}

					// MARK: Intent (action) tool 2

					Stepper(
						"\(viewModel.state.sleepAmount.formatted()) hours",
						value: Binding(
							get: { viewModel.state.sleepAmount },
							set: { viewModel.handleIntent(.setSleepAmount($0)) }
						),
						in: 4...12
					)
				}

				// MARK: - Section 3

				Section {
					HStack {
						Text("Daily coffee intake")
							.font(.headline)
						Spacer()
					}

					// MARK: Intent (action) tool 3

					Stepper(
						"^[\(viewModel.state.coffeeAmount) cup](inflect: true)",
						value: Binding(
							get: { viewModel.state.coffeeAmount },
							set: { viewModel.handleIntent(.setCoffeeAmount($0)) }
						),
						in: 0...20
					)
				}

				// MARK: - Section 4

				Section {
					Text("Your approximate ideal bed time is")
						.font(.headline)
					Text(viewModel.state.idealBedtime)
				}
			}
			.navigationTitle("BetterSleep")
		}
	}
}

#Preview {
	BetterSleepView()
}
