import XCTest
@testable import BetterSleepSwiftUI

final class BetterSleepSwiftUITests: XCTestCase {

	var viewModel: BetterSleepViewModel!

	override func setUpWithError() throws {
		// Initialize the ViewModel before each test
		viewModel = BetterSleepViewModel()
	}

	override func tearDownWithError() throws {
		// Clean up the ViewModel after each test
		viewModel = nil
	}

	func testCalculateBedtime() throws {
		// Given: Set initial conditions
		let wakeUpTime = Calendar.current.date(from: DateComponents(hour: 8, minute: 0))!
		viewModel.handleIntent(.setWakeUp(wakeUpTime)) // 8:00 AM
		viewModel.handleIntent(.setSleepAmount(8.0)) // 8 hours of sleep
		viewModel.handleIntent(.setCoffeeAmount(1)) // 1 cup of coffee

		// When: Perform the action
		viewModel.handleIntent(.calculateBedtime)

		// Then: Verify the result
		let expectedBedtime = "23:38" // Example expected result
		XCTAssertEqual(viewModel.state.idealBedtime, expectedBedtime, "The calculated bedtime should be \(expectedBedtime)")
	}

	func testInvalidInputHandling() throws {
		// Given: Set invalid input conditions
		let wakeUpTime = Calendar.current.date(from: DateComponents(hour: 8, minute: 0))!
		viewModel.handleIntent(.setWakeUp(wakeUpTime)) // 8:00 AM
		viewModel.handleIntent(.setSleepAmount(-1.0)) // Invalid sleep amount
		viewModel.handleIntent(.setCoffeeAmount(-1)) // Invalid coffee amount

		// When: Perform the action
		viewModel.handleIntent(.calculateBedtime)

		// Then: Verify the error handling
		let expectedErrorMessage = "Some error in calculation has been detected"
		XCTAssertEqual(viewModel.state.idealBedtime, expectedErrorMessage, "The error message should be displayed for invalid input")
	}

	func testCoffeeAmountImpact() throws {
		// Given: Set conditions with high coffee intake
		let wakeUpTime = Calendar.current.date(from: DateComponents(hour: 8, minute: 0))!
		viewModel.handleIntent(.setWakeUp(wakeUpTime)) // 8:00 AM
		viewModel.handleIntent(.setSleepAmount(8.0)) // 8 hours of sleep
		viewModel.handleIntent(.setCoffeeAmount(5)) // 5 cups of coffee

		// When: Perform the action
		viewModel.handleIntent(.calculateBedtime)

		// Then: Verify the result considering coffee intake
		let expectedBedtime = "22:42" // Example expected result with higher coffee intake
		XCTAssertEqual(viewModel.state.idealBedtime, expectedBedtime, "The calculated bedtime should adjust for higher coffee intake")
	}

	func testPerformanceExample() throws {
		measure {
			// Measure the performance of the calculateBedtime function
			viewModel.handleIntent(.calculateBedtime)
		}
	}

}
