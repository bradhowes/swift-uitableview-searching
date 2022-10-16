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
    let changes1 = ArrayTransitions.changes1(from: from, to: to)
    XCTAssertTrue(changes1.added.isEmpty)
    XCTAssertTrue(changes1.deleted.isEmpty)

    let changes2 = ArrayTransitions.changes1(from: from, to: to)
    XCTAssertTrue(changes2.added.isEmpty)
    XCTAssertTrue(changes2.deleted.isEmpty)
  }
  
  func testEmptyFrom() throws {
    let from = [Int]()
    let to = [1, 2, 3]
    let changes1 = ArrayTransitions.changes1(from: from, to: to)
    XCTAssertEqual(changes1.added.sorted(), [0, 1, 2])
    XCTAssertEqual(changes1.deleted.count, 0)

    let changes2 = ArrayTransitions.changes2(from: from, to: to)
    XCTAssertEqual(changes2.added.sorted(), [0, 1, 2])
    XCTAssertEqual(changes2.deleted.count, 0)
  }

  func testEmptyTo() throws {
    let from = [1, 2, 3]
    let to = [Int]()
    let changes1 = ArrayTransitions.changes1(from: from, to: to)
    XCTAssertEqual(changes1.added.count, 0)
    XCTAssertEqual(changes1.deleted.sorted(), [0, 1, 2])

    let changes2 = ArrayTransitions.changes2(from: from, to: to)
    XCTAssertEqual(changes2.added.count, 0)
    XCTAssertEqual(changes2.deleted.sorted(), [0, 1, 2])
  }

  func testRemoveFirst() throws {
    let from = [1, 2, 3]
    let to = [2, 3]
    let changes1 = ArrayTransitions.changes1(from: from, to: to)
    XCTAssertEqual(changes1.added.count, 0)
    XCTAssertEqual(changes1.deleted, [0])

    let changes2 = ArrayTransitions.changes2(from: from, to: to)
    XCTAssertEqual(changes2.added.count, 0)
    XCTAssertEqual(changes2.deleted, [0])
  }

  func testRemoveMiddle() throws {
    let from = [1, 2, 3]
    let to = [1, 3]
    let changes1 = ArrayTransitions.changes1(from: from, to: to)
    XCTAssertEqual(changes1.added.count, 0)
    XCTAssertEqual(changes1.deleted, [1])

    let changes2 = ArrayTransitions.changes2(from: from, to: to)
    XCTAssertEqual(changes2.added.count, 0)
    XCTAssertEqual(changes2.deleted, [1])
  }

  func testRemoveLast() throws {
    let from = [1, 2, 3]
    let to = [1, 2]
    let changes1 = ArrayTransitions.changes1(from: from, to: to)
    XCTAssertEqual(changes1.added.count, 0)
    XCTAssertEqual(changes1.deleted, [2])

    let changes2 = ArrayTransitions.changes2(from: from, to: to)
    XCTAssertEqual(changes2.added.count, 0)
    XCTAssertEqual(changes2.deleted, [2])
  }

  func testAddedFirst() throws {
    let from = [1, 2, 3]
    let to = [0, 1, 2, 3]
    let changes1 = ArrayTransitions.changes1(from: from, to: to)
    XCTAssertEqual(changes1.added, [0])
    XCTAssertEqual(changes1.deleted.count, 0)

    let changes2 = ArrayTransitions.changes2(from: from, to: to)
    XCTAssertEqual(changes2.added, [0])
    XCTAssertEqual(changes2.deleted.count, 0)
  }

  func testAddedMiddle() throws {
    let from = [1, 2, 4]
    let to = [1, 2, 3, 4]
    let changes1 = ArrayTransitions.changes1(from: from, to: to)
    XCTAssertEqual(changes1.added, [2])
    XCTAssertEqual(changes1.deleted.count, 0)

    let changes2 = ArrayTransitions.changes2(from: from, to: to)
    XCTAssertEqual(changes2.added, [2])
    XCTAssertEqual(changes2.deleted.count, 0)
  }

  func testAddedEnd() throws {
    let from = [1, 2, 3]
    let to = [1, 2, 3, 4]
    let changes1 = ArrayTransitions.changes1(from: from, to: to)
    XCTAssertEqual(changes1.added, [3])
    XCTAssertEqual(changes1.deleted.count, 0)

    let changes2 = ArrayTransitions.changes2(from: from, to: to)
    XCTAssertEqual(changes2.added, [3])
    XCTAssertEqual(changes2.deleted.count, 0)
  }

  func testAddedAndDeleted() throws {
    let from = [1, 2, 3]
    let to = [1, 4]
    let changes1 = ArrayTransitions.changes1(from: from, to: to)
    XCTAssertEqual(changes1.added, [1])
    XCTAssertEqual(changes1.deleted.sorted(), [1, 2])

    let changes2 = ArrayTransitions.changes2(from: from, to: to)
    XCTAssertEqual(changes2.added, [1])
    XCTAssertEqual(changes2.deleted.sorted(), [1, 2])
  }

  func testLargeCollectionSizeDeletion() throws {
    let from = [Int](0..<100_000)
    let to = [1, 3, 19, 99_998, 99_999]
    let diff1 = ArrayTransitions.changes1(from: from, to: to)
    let diff2 = ArrayTransitions.changes2(from: from, to: to)
    XCTAssertEqual(diff1.added.sorted(), diff2.added.sorted())
    XCTAssertEqual(diff1.deleted.sorted(), diff2.deleted.sorted())
  }

  func testLargeCollectionSizeDeletionPerformance1() throws {
    let from = [Int](0..<100_000)
    let to = [1, 3, 19, 99_998, 99_999]
    self.measure {
      _ = ArrayTransitions.changes1(from: from, to: to)
    }
  }
  
  func testLargeCollectionSizeDeletionPerformance2() throws {
    let from = [Int](0..<100_000)
    let to = [1, 3, 19, 99_998, 99_999]
    self.measure {
      _ = ArrayTransitions.changes2(from: from, to: to)
    }
  }

  func testLargeCollectionSizeInsertion() throws {
    let from = [1, 3, 19, 99_998, 99_999]
    let to = [Int](0..<100_000)
    let diff1 = ArrayTransitions.changes1(from: from, to: to)
    let diff2 = ArrayTransitions.changes2(from: from, to: to)
    XCTAssertEqual(diff1.added.sorted(), diff2.added.sorted())
    XCTAssertEqual(diff1.deleted.sorted(), diff2.deleted.sorted())
  }

  func testLargeCollectionSizeInsertionPerformance1() throws {
    let from = [1, 3, 19, 99_998, 99_999]
    let to = [Int](0..<100_000)
    self.measure {
      _ = ArrayTransitions.changes1(from: from, to: to)
    }
  }

  func testLargeCollectionSizeInsertionPerformance2() throws {
    let from = [1, 3, 19, 99_998, 99_999]
    let to = [Int](0..<100_000)
    self.measure {
      _ = ArrayTransitions.changes2(from: from, to: to)
    }
  }
}
