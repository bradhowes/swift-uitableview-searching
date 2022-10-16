import XCTest
@testable import Searching

final class ArrayTransitionsTests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testEmptyFromAndTo() throws {
    let from = [Int]()
    let to = [Int]()
    let changes = ArrayTransitions.changes(from: from, to: to)
    XCTAssertTrue(changes.added.isEmpty)
    XCTAssertTrue(changes.deleted.isEmpty)
  }
  
  func testEmptyFrom() throws {
    let from = [Int]()
    let to = [1, 2, 3]
    let changes = ArrayTransitions.changes(from: from, to: to)
    XCTAssertEqual(changes.added.count, 3)
    XCTAssertEqual(changes.deleted.count, 0)
    XCTAssertEqual(changes.added.sorted(), [0, 1, 2])
  }

  func testEmptyTo() throws {
    let from = [1, 2, 3]
    let to = [Int]()
    let changes = ArrayTransitions.changes(from: from, to: to)
    XCTAssertEqual(changes.added.count, 0)
    XCTAssertEqual(changes.deleted.count, 3)
    XCTAssertEqual(changes.deleted.sorted(), [0, 1, 2])
  }

  func testRemoveFirst() throws {
    let from = [1, 2, 3]
    let to = [2, 3]
    let changes = ArrayTransitions.changes(from: from, to: to)
    XCTAssertEqual(changes.added.count, 0)
    XCTAssertEqual(changes.deleted, [0])
  }

  func testRemoveMiddle() throws {
    let from = [1, 2, 3]
    let to = [1, 3]
    let changes = ArrayTransitions.changes(from: from, to: to)
    XCTAssertEqual(changes.added.count, 0)
    XCTAssertEqual(changes.deleted, [1])
  }

  func testRemoveLast() throws {
    let from = [1, 2, 3]
    let to = [1, 2]
    let changes = ArrayTransitions.changes(from: from, to: to)
    XCTAssertEqual(changes.added.count, 0)
    XCTAssertEqual(changes.deleted, [2])
  }

  func testAddedFirst() throws {
    let from = [1, 2, 3]
    let to = [0, 1, 2, 3]
    let changes = ArrayTransitions.changes(from: from, to: to)
    XCTAssertEqual(changes.added, [0])
    XCTAssertEqual(changes.deleted.count, 0)
  }

  func testAddedMiddle() throws {
    let from = [1, 2, 4]
    let to = [1, 2, 3, 4]
    let changes = ArrayTransitions.changes(from: from, to: to)
    XCTAssertEqual(changes.added, [2])
    XCTAssertEqual(changes.deleted.count, 0)
  }

  func testAddedEnd() throws {
    let from = [1, 2, 3]
    let to = [1, 2, 3, 4]
    let changes = ArrayTransitions.changes(from: from, to: to)
    XCTAssertEqual(changes.added, [3])
    XCTAssertEqual(changes.deleted.count, 0)
  }

  func testAddedAndDeleted() throws {
    let from = [1, 2, 3]
    let to = [1, 4]
    let changes = ArrayTransitions.changes(from: from, to: to)
    XCTAssertEqual(changes.added, [1])
    XCTAssertEqual(changes.deleted.sorted(), [1, 2])
  }

  func testLargeCollectionSizeDeletionPerformance() throws {
    let from = [Int](0..<100_000)
    let to = [1, 3, 19, 99_998, 99_999]
    self.measure {
      _ = ArrayTransitions.changes(from: from, to: to)
    }
  }
  
  func testLargeCollectionSizeInsertionPerformance() throws {
    let from = [1, 3, 19, 99_998, 99_999]
    let to = [Int](0..<100_000)
    self.measure {
      _ = ArrayTransitions.changes(from: from, to: to)
    }
  }

}
