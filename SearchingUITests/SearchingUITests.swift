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
#if !targetEnvironment(macCatalyst)
    XCUIDevice.shared.orientation = .portrait
#endif
    continueAfterFailure = false
    app = XCUIApplication()
    app.launch()
    navigationBar = app.navigationBars["Items"]
    searchButton = navigationBar.buttons["toggleSearch"]
    mainView = app.otherElements["mainView"]
    searchBar = app.otherElements["searchBar"]
    textField = searchBar.searchFields["searchTextField"]
    itemsTable = mainView.tables["itemsTableView"]
    selectFirstRow()
  }

  override func tearDownWithError() throws {
  }

  func selectFirstRow() {
    // Bring up search bar
    searchButton.tap()

    // Make sure that first entry is showing
    let keyboard = app.keyboards.element(boundBy: 0)
    XCTAssertTrue(keyboard.waitForExistence(timeout: 30))
    keyboard.keys["b"].tap()
    keyboard.keys["l"].tap()
    keyboard.keys["o"].tap()

    // Clear the text field for future queries.
    textField.buttons.element(boundBy: 0).tap()

    // Select the first row
    let firstRow = itemsTable.cells.containing(.staticText, identifier: "Blowfish").element
    firstRow.tap()
    XCTAssertTrue(firstRow.isSelected)
    XCTAssertTrue(firstRow.isHittable)
  }

  func showSearchBar() -> XCUIElement {
    searchButton.tap()
    let keyboard = app.keyboards.element(boundBy: 0)
    XCTAssertTrue(keyboard.waitForExistence(timeout: 30))
    return keyboard
  }

  func testSearchBarAppearsAndDisappears() throws {
    // Initially searchBar is hidden
    XCTAssertFalse(searchBar.isHittable)

    _ = showSearchBar()
    XCTAssertTrue(searchBar.isHittable)

    // We cannot directly compare the two cells. Comparing their frames should be good enough.
    let firstRow = itemsTable.cells.element(boundBy: 0)
    let testingRow = itemsTable.cells.containing(.staticText, identifier: "Blowfish").element
    XCTAssertEqual(firstRow.frame, testingRow.frame)

    firstRow.tap()
    XCTAssertTrue(firstRow.isSelected)
    XCTAssertTrue(testingRow.isSelected)

    // Search bar should go away upon selection
    XCTAssertFalse(searchBar.isHittable)

    // The firstRow should be visible still and selected
    XCTAssertTrue(firstRow.isHittable)
    XCTAssertTrue(firstRow.isSelected)
    XCTAssertTrue(testingRow.isSelected)
  }

  func testSearchTextFiltersRows() throws {
    let keyboard = showSearchBar()
    keyboard.keys["j"].tap()

    // Should only have 1 entry showing
    XCTAssertEqual(itemsTable.cells.count, 1)
    let tdl = itemsTable.cells.containing(.staticText, identifier: "The Darjeeling Limited").element
    XCTAssertTrue(tdl.isHittable)

    tdl.tap()
    XCTAssertTrue(tdl.isSelected)

    searchButton.tap()
    keyboard.keys["j"].tap()

    // Should have nothing showing
    XCTAssertEqual(itemsTable.cells.count, 0)

    // Delete last "j" should reveal previous entry
    keyboard.keys["delete"].tap()
    XCTAssertEqual(itemsTable.cells.count, 1)
    XCTAssertTrue(itemsTable.cells.element(boundBy: 0).isSelected)

    // Delete sole "J" should reveal everything
    keyboard.keys["delete"].tap()
    XCTAssertEqual(itemsTable.cells.count, 29)

    searchButton.tap()
    XCTAssertTrue(tdl.isSelected)
    XCTAssertTrue(tdl.isHittable)
  }

  func testTextFieldClearTextButtonWorks() throws {
    let keyboard = showSearchBar()

    // Tap "J", select sole item, tap "j"
    keyboard.keys["j"].tap()
    keyboard.keys["j"].tap()

    // Should have nothing showing
    XCTAssertEqual(itemsTable.cells.count, 0)

    // Clear the text field
    textField.buttons.element(boundBy: 0).tap()

    // Should have everything showing.
    XCTAssertEqual(itemsTable.cells.count, 29)

    // Dismiss the searchBar. We should be showing the selection from above.
    searchButton.tap()

    let firstRow = itemsTable.cells.containing(.staticText, identifier: "Blowfish").element
    XCTAssertTrue(firstRow.isHittable)
    XCTAssertTrue(firstRow.isSelected)
  }

  func testShowSelectedItem() throws {
    let keyboard = showSearchBar()
    keyboard.keys["u"].tap()
    keyboard.keys["n"].tap()
    keyboard.keys["b"].tap()
    XCTAssertEqual(itemsTable.cells.count, 1)
    let tulob = itemsTable.cells.containing(.staticText, identifier: "The Unbearable Lightness of Being").element
    tulob.tap()
    XCTAssertFalse(searchBar.isHittable)
    XCTAssertTrue(tulob.isSelected)
    XCTAssertTrue(tulob.isHittable)
  }
}
