import XCTest
@testable import Searching

final class TitleTests: XCTestCase {

  override func setUpWithError() throws {}

  override func tearDownWithError() throws {}

  func testWithEmptyString() throws {
    let a: Title = .init(index: 0, sortableTitle: .init(title: ""))
    XCTAssertEqual(a.title, "")
    XCTAssertEqual(a.section, .Other)
  }

  func testOrdering() throws {
    let a: Title = .init(index: 0, sortableTitle: .init(title: "a few good men"))
    let b: Title = .init(index: 1, sortableTitle: .init(title: "the empire strikes back"))
    let c: Title = .init(index: 2, sortableTitle: .init(title: "empire falls"))
    XCTAssertTrue(a > b)
    XCTAssertTrue(a > c)
    XCTAssertTrue(b > c)

    XCTAssertEqual(a.section, .F)
    XCTAssertEqual(b.section, .E)
    XCTAssertEqual(c.section, .E)
  }

  func testEquality() throws {
    let a: Title = .init(index: 0, sortableTitle: .init(title: "a few good men"))
    let b: Title = .init(index: 1, sortableTitle: .init(title: "few good men   "))
    XCTAssertTrue(a == b)
  }
}
