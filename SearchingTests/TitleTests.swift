import XCTest
@testable import Searching

final class TitleTests: XCTestCase {

  override func setUpWithError() throws {}

  override func tearDownWithError() throws {}

  func testWithEmptyString() throws {
    let a: Title = .init(index: 0, title: "")
    XCTAssertEqual(a.title, "")
    XCTAssertEqual(a.sortable, .init(title: ""))
    XCTAssertEqual(a.section, .Other)
  }

  func testOrdering() throws {
    let a: Title = .init(index: 0, title: "a few good men")
    let b: Title = .init(index: 1, title: "the empire strikes back")
    let c: Title = .init(index: 2, title: "empire falls")
    XCTAssertTrue(a > b)
    XCTAssertTrue(a > c)
    XCTAssertTrue(b > c)

    XCTAssertEqual(a.section, .F)
    XCTAssertEqual(b.section, .E)
    XCTAssertEqual(c.section, .E)
  }

  func testEquality() throws {
    let a: Title = .init(index: 0, title: "a few good men")
    let b: Title = .init(index: 1, title: "few good men   ")
    XCTAssertTrue(a == b)
  }
}
