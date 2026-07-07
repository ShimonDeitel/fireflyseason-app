import XCTest

final class FireflyseasonUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddEntryFlow() {
        app.buttons["addEntryButton"].tap()
        let field0 = app.textFields["fieldLocation"]
        XCTAssertTrue(field0.waitForExistence(timeout: 2))
        field0.tap()
        field0.typeText("UI Test Entry")
        app.buttons["editorSaveButton"].tap()
        XCTAssertTrue(app.staticTexts["UI Test Entry"].waitForExistence(timeout: 2))
    }

    func testKeyboardDismissesOnTapOutside() {
        app.buttons["addEntryButton"].tap()
        let field0 = app.textFields["fieldLocation"]
        XCTAssertTrue(field0.waitForExistence(timeout: 2))
        field0.tap()
        field0.typeText("Dismiss Test")
        XCTAssertTrue(app.keyboards.element.exists)
        app.navigationBars.element.tap()
        XCTAssertFalse(app.keyboards.element.exists)
        app.buttons["editorCancelButton"].tap()
    }

    func testFreeLimitTriggersPaywall() {
        for i in 0..<40 {
            app.buttons["addEntryButton"].tap()
            let field0 = app.textFields["fieldLocation"]
            if field0.waitForExistence(timeout: 2) {
                field0.tap()
                field0.typeText("Entry \(i)")
                app.buttons["editorSaveButton"].tap()
            } else {
                break
            }
        }
        XCTAssertTrue(app.buttons["paywallPurchaseButton"].waitForExistence(timeout: 3))
    }

    func testSettingsSheetOpens() {
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 2))
        app.buttons["settingsDoneButton"].tap()
    }
}
