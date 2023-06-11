import XCTest
@testable import Searching

final class SortableTitleTests: XCTestCase {

  override func setUpWithError() throws {
  }

  override func tearDownWithError() throws {
  }

  func testWithEmptyString() throws {
    XCTAssertEqual(SortableTitle(title: "").value, "")
  }

  func testOrdering() throws {
    let a = SortableTitle(title: "a few good men")
    let b = SortableTitle(title: "the empire strikes back")
    let c = SortableTitle(title: "empire falls")
    XCTAssertTrue(a > b)
    XCTAssertTrue(a > c)
    XCTAssertTrue(b > c)
  }

  func testEquality() throws {
    let a = SortableTitle(title: "a few good men")
    let b = SortableTitle(title: "few good men   ")
    XCTAssertTrue(a == b)
  }
}
