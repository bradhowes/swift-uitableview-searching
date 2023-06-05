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
    textField.typeText("blow")
    textField.buttons.element(boundBy: 0).tap()

    // Select the first row
    let firstRow = itemsTable.cells.containing(.staticText, identifier: "Blowfish").element
    firstRow.tap()
    XCTAssertTrue(firstRow.isSelected)
    XCTAssertTrue(firstRow.isHittable)
  }

  func showSearchBar() {
    searchButton.tap()
    XCTAssertTrue(searchBar.isHittable)
  }

  func testSearchBarAppearsAndDisappears() throws {
    // Initially searchBar is hidden
    XCTAssertFalse(searchBar.isHittable)

    showSearchBar()

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
    showSearchBar()
    textField.typeText("j")

    // Should only have 1 entry showing
    XCTAssertEqual(itemsTable.cells.count, 1)
    let tdl = itemsTable.cells.containing(.staticText, identifier: "The Darjeeling Limited").element
    XCTAssertTrue(tdl.isHittable)

    tdl.tap()
    XCTAssertTrue(tdl.isSelected)

    showSearchBar()
    textField.typeText("jj")

    // Should have nothing showing
    XCTAssertEqual(itemsTable.cells.count, 0)
    textField.buttons.element(boundBy: 0).tap()

    // Delete last "j" should reveal previous entry
    textField.typeText("j")
    XCTAssertEqual(itemsTable.cells.count, 1)
    XCTAssertTrue(itemsTable.cells.element(boundBy: 0).isSelected)

    textField.buttons.element(boundBy: 0).tap()
    XCTAssertEqual(itemsTable.cells.count, 29)

    searchButton.tap()
    XCTAssertTrue(tdl.isSelected)
    XCTAssertTrue(tdl.isHittable)
  }

  func testTextFieldClearTextButtonWorks() throws {
    showSearchBar()

    // Tap "J", select sole item, tap "j"
    textField.typeText("jj")

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
    showSearchBar()
    textField.typeText("unb")
    XCTAssertEqual(itemsTable.cells.count, 1)
    let tulob = itemsTable.cells.containing(.staticText, identifier: "The Unbearable Lightness of Being").element
    tulob.tap()
    XCTAssertFalse(searchBar.isHittable)
    XCTAssertTrue(tulob.isSelected)
    XCTAssertTrue(tulob.isHittable)
  }
}
