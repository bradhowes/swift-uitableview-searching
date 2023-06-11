import XCTest
@testable import Searching

final class UtilsTests: XCTestCase {

  override func setUpWithError() throws {
  }

  override func tearDownWithError() throws {
  }

  func testSortableEmptyString() throws {
    XCTAssertEqual(sortable(from: ""), "")
  }

  func testSortableStripsWhitespaces() throws {
    XCTAssertEqual(sortable(from: "   this IS a Test \n\n\t"), "THIS IS A TEST")
  }

  func testSortableMakeUppercase() throws {
    XCTAssertEqual(sortable(from: "this IS a Test"), "THIS IS A TEST")
  }

  func testSortableTitleEmptyString() throws {
    XCTAssertEqual(sortableTitle(from: ""), "")
  }

  func testSortableTitleStripsWhitespaces() throws {
    XCTAssertEqual(sortableTitle(from: "   this IS a Test \n\n\t"), "THIS IS A TEST")
  }

  func testSortableTitleMakeUppercase() throws {
    XCTAssertEqual(sortableTitle(from: "this IS a Test"), "THIS IS A TEST")
  }

  func testSortableTitleSkipsFirstArticle() throws {
    XCTAssertEqual(sortableTitle(from: "a night to remember"), "NIGHT TO REMEMBER")
    XCTAssertEqual(sortableTitle(from: "the night of the iguana"), "NIGHT OF THE IGUANA")
    XCTAssertEqual(sortableTitle(from: "an awful experience"), "AWFUL EXPERIENCE")
  }

  func testSortableTitleIgnoresArticleWithNonAsciiCharacters() throws {
    XCTAssertEqual(sortableTitle(from: "ä night to remember"), "Ä NIGHT TO REMEMBER")
    XCTAssertEqual(sortableTitle(from: "thę night of the iguana"), "THĘ NIGHT OF THE IGUANA")
    XCTAssertEqual(sortableTitle(from: "añ awful experience"), "AÑ AWFUL EXPERIENCE")
  }

  func testSortableTitleKeepsFirstArticleIfOnlyWorld() throws {
    XCTAssertEqual(sortableTitle(from: " \t\nthe  "), "THE")
    XCTAssertEqual(sortableTitle(from: " \t\na  "), "A")
  }

  func testSortableTitleStripsWhitespacesAfterSkippedArticle() throws {
    XCTAssertEqual(sortableTitle(from: " \t\nthe    walrus "), "WALRUS")
  }

  func testPartitionTitles() throws {
    let sections = partitionTitles(allTitles)
    XCTAssertEqual(sections.count, 26)
    XCTAssertEqual(sections[0].titles.count, 7)
    for index in 0..<26 {
      let section = Section(rawValue: UInt32(index))
      XCTAssertTrue(sections[index].titles.allSatisfy { $0.section == section })
    }
  }
}
