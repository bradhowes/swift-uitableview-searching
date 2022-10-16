import XCTest

final class SearchingUITests: XCTestCase {

  var app: XCUIApplication!
  var navigationBar: XCUIElement!
  var searchButton: XCUIElement!
  var mainView: XCUIElement!
  var searchBar: XCUIElement!
  var textField: XCUIElement!
  var itemsTable: XCUIElement!

  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launch()
    navigationBar = app.navigationBars["Items"]
    searchButton = navigationBar.buttons["toggleSearch"]
    mainView = app.otherElements["mainView"]
    searchBar = app.otherElements["searchBar"]
    textField = searchBar.searchFields["searchTextField"]
    itemsTable = mainView.tables["itemsTableView"]
  }

  override func tearDownWithError() throws {
  }

  func testSearchBarAppearsAndDisappears() throws {
    // Initially searchBar is hidden
    XCTAssertFalse(searchBar.isHittable)

    // Reveal searchBar
    searchButton.tap()
    XCTAssertTrue(searchBar.isHittable)

    // We cannot directly compare the two cells. Comparing their frames should be good enough.
    let firstRow = itemsTable.cells.element(boundBy: 0)
    let testingRow = itemsTable.cells.containing(.staticText, identifier:"Testing").element
    XCTAssertEqual(firstRow.frame, testingRow.frame)

    firstRow.tap()
    XCTAssertTrue(firstRow.isSelected)
    XCTAssertTrue(testingRow.isSelected)

    // Hide searchBar
    searchButton.tap()
    XCTAssertFalse(searchBar.isHittable)

    // The firstRow should be visible still and selected
    XCTAssertTrue(firstRow.isHittable)
    XCTAssertTrue(firstRow.isSelected)
    XCTAssertTrue(testingRow.isSelected)
  }

  func testSearchTextFiltersRows() throws {
    searchButton.tap()

    let firstRow = itemsTable.cells.element(boundBy: 0)
    firstRow.tap()
    XCTAssertTrue(firstRow.isSelected)
    XCTAssertEqual(itemsTable.cells.count, 23)

    let keyboard = app.keyboards.element(boundBy: 0)
    XCTAssertTrue(keyboard.waitForExistence(timeout: 30))
    keyboard.keys["J"].tap()

    // Should only have 1 entry showing
    XCTAssertEqual(firstRow.staticTexts.element(boundBy: 0).label, "The Darjeeling Limited")
    XCTAssertEqual(itemsTable.cells.count, 1)

    firstRow.tap()
    XCTAssertTrue(firstRow.isSelected)

    keyboard.keys["j"].tap()

    // Should have nothing showing
    XCTAssertEqual(itemsTable.cells.count, 0)

    // Delete last "j" should reveal previous entry
    keyboard.keys["delete"].tap()
    XCTAssertEqual(firstRow.staticTexts.element(boundBy: 0).label, "The Darjeeling Limited")
    XCTAssertEqual(itemsTable.cells.count, 1)
    XCTAssertTrue(firstRow.isSelected)

    // Delete sole "J" should reveal everything
    keyboard.keys["delete"].tap()
    XCTAssertEqual(itemsTable.cells.count, 23)

    // The last row should not be visible
    let lastItem = itemsTable.cells.containing(.staticText, identifier: "The Darjeeling Limited").element
    XCTAssertFalse(lastItem.isHittable)

    // Dismiss the searchBar. We should be showing the selection from above.
    searchButton.tap()
    XCTAssertTrue(lastItem.isSelected)
    XCTAssertTrue(lastItem.isHittable)
  }

  func testTextFieldClearTextButtonWorks() throws {
    searchButton.tap()

    let firstRow = itemsTable.cells.element(boundBy: 0)
    firstRow.tap()
    XCTAssertTrue(firstRow.isSelected)
    XCTAssertEqual(itemsTable.cells.count, 23)

    // Tap "J", select sole item, tap "j"
    let keyboard = app.keyboards.element(boundBy: 0)
    XCTAssertTrue(keyboard.waitForExistence(timeout: 30))
    keyboard.keys["J"].tap()
    firstRow.tap()
    keyboard.keys["j"].tap()

    // Should have nothing showing
    XCTAssertEqual(itemsTable.cells.count, 0)

    // Clear the text field
    textField.buttons.element(boundBy: 0).tap()

    // Should have everything showing.
    XCTAssertEqual(itemsTable.cells.count, 23)

    // The last row should not be visible
    let lastItem = itemsTable.cells
      .containing(NSPredicate(format: "label CONTAINS %@", "The Darjeeling Limited"))
      .element(boundBy: 0)
    XCTAssertFalse(lastItem.isHittable)

    // Dismiss the searchBar. We should be showing the selection from above.
    searchButton.tap()
    XCTAssertTrue(lastItem.isSelected)
    XCTAssertTrue(lastItem.isHittable)

  }
}
