//
//  Final_Fantasy_Lattice__Soldiers_Of_FireUITestsLaunchTests.swift
//  Final Fantasy Lattice: Soldiers Of FireUITests
//
//  Created by Dr. Nathaniel Fox on 2/19/26.
//

import XCTest

final class Final_Fantasy_Lattice__Soldiers_Of_FireUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
