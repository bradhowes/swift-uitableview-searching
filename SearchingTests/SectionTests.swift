import XCTest
@testable import Searching

final class SectionTests: XCTestCase {

  override func setUpWithError() throws {
  }

  override func tearDownWithError() throws {
  }

  func testEnumeration() {
    XCTAssertEqual(Section.A.rawValue, 0)
    XCTAssertEqual(Section.Z.rawValue, 25)
    XCTAssertEqual(Section.Other.rawValue, 26)
    for (index, value) in (UInt8(ascii: "A")...UInt8(ascii: "Z")).enumerated() {
      let title: String = .init(UnicodeScalar(value))
      XCTAssertEqual(Section.locate(title: .init(title: title)).rawValue, UInt32(index))
    }
  }

  func testEmptyString() throws {
    XCTAssertEqual(Section.locate(title: .init(title: "")), .Other)
    XCTAssertEqual(Section.locate(title: .init(title: "  ")), .Other)
  }

  func testTitleStartingWithNumber() throws {
    XCTAssertEqual(Section.locate(title: .init(title: "12 Monkeys")), .Other)
  }

  func testTitleStartingWithEmoji() throws {
    XCTAssertEqual(Section.locate(title: .init(title: "😀 Mondays")), .Other)
  }

  func testTitleStartingWithLetter() throws {
    XCTAssertEqual(Section.locate(title: .init(title: "Anna Karenina ")), .A)
    XCTAssertEqual(Section.locate(title: .init(title: " the night of the ignauna  ")), .N)
    XCTAssertEqual(Section.locate(title: .init(title: " the knight of the ignauna  ")), .K)
    XCTAssertEqual(Section.locate(title: .init(title: " the zero theorem")), .Z)
  }
}
