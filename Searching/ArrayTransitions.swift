import Foundation
import Tagged

/**
 Provides a way to determine the additions and deletions necessary to transform one collection of view indices to
 another as long as rows are only added or removed (not moved).

 Loosely based on https://lukaszielinski.de/blog/posts/2019/02/03/calculating-the-deltas-for-performbatchupdates/
 which does handle row movement.
 */
struct ArrayTransitions: Equatable {

  /// Collection of view indices that were added. Note that this is not guaranteed to be in a sorted order.
  let added: [Int]

  /// Collection of view indices that were removed. Note that this is not guaranteed to be in a sorted order.
  let deleted: [Int]

  /**
   Calculate the number of steps necessary to change from one collection of integers to another collection. A useful
   collection of integers could be the indices into a collection of data that is being displayed in a table view, and
   the indices would correspond to row values in the table view if every data item were to be displayed in the table.
   Often this is not the case, including when one applies a filter to see only those data elements that match the
   filter like in a text search.

   Note that the input arrays must not contain duplicates, and the ordering of the two arrays must honor the same
   ordering principle (ascending or descending). Also, the resulting `added` and `deleted` arrays contain values
   suitable for use as an IndexPath row value: they indicate how the `toViewIndices` transformed from the
   `fromViewIndices`, and so the values are *not* of the same conceptual type as the input values, which can be thought
   of as data elements and not row indices.

   - parameter from: the starting collection state
   - parameter to: the final collection state
   - returns: ArrayTransitions instance with the additions and deletions
   */
  @inlinable
  static func changes(from fromViewIndices: [Int], to toViewIndices: [Int]) -> ArrayTransitions {
    return changes2(from: fromViewIndices, to: toViewIndices)
  }

  // Use internal types to make sure we are working with the right index since the two are both Int-based.
  private typealias ValueIndex = Tagged<(ArrayTransitions, valueIndex: ()), Int>
  private typealias ViewIndex = Tagged<(ArrayTransitions, viewIndex: ()), Int>

  @inlinable
  static func changes1(from fromViewIndices: [Int], to toViewIndices: [Int]) -> ArrayTransitions {

    // Generate mappings from values to array indices. For very large collections this could get expensive so a future
    // optimization would be to store the toMap for future use as a fromMap. Alternatively, I am pretty sure there is
    // an algorithm that can be used to do this without the reverse maps, by walking two iterators up the two integer
    // collections and comparing the results. This would work if the underlying order of the items is always increasing.
    let fromReverseMap = [ValueIndex: ViewIndex](uniqueKeysWithValues: fromViewIndices.enumerated()
      .map { (.init(rawValue: $0.1), .init(rawValue: $0.0)) } )
    var toReverseMap = [ValueIndex: ViewIndex](uniqueKeysWithValues: toViewIndices.enumerated()
      .map { (.init(rawValue: $0.1), .init(rawValue: $0.0)) } )

    // Identify the elements that need to be deleted. As a side-effect, this will remove values from `toReverseMap`
    // that should remain.
    let deleted: [Int] = fromReverseMap.compactMap { (valueIndex, viewIndex) in
      if toReverseMap[valueIndex] != nil {
        toReverseMap.removeValue(forKey: valueIndex)
        return nil
      }
      return viewIndex.rawValue
    }

    return .init(added: toReverseMap.values.map { $0.rawValue }, deleted: deleted)
  }

  @inlinable
  static func changes2(from fromViewIndices: [Int], to toViewIndices: [Int]) -> ArrayTransitions {

    // Alternative version that does not rely on the reverse mapping. Timings show this to be ~10x faster.

    var fromIndex = 0
    var toIndex = 0

    var added = [Int]()
    var deleted = [Int]()

    // Handle case where both index values are valid
    while fromIndex < fromViewIndices.count && toIndex < toViewIndices.count {
      let fromValue = fromViewIndices[fromIndex]
      let toValue = toViewIndices[toIndex]

      if fromValue < toValue {
        deleted.append(fromIndex)
        fromIndex += 1
      } else if fromValue > toValue {
        added.append(toIndex)
        toIndex += 1
      } else {
        fromIndex += 1
        toIndex += 1
      }
    }

    // Remaining fromViewIndices must be deleted since they are not in the toViewIndices collection
    deleted.append(contentsOf: fromIndex..<fromViewIndices.count)

    // Remaining toViewIndices must be added since hey were not in the fromViewIndices collection
    added.append(contentsOf: toIndex..<toViewIndices.count)

    return .init(added: added, deleted: deleted)
  }

  private init(added: [Int], deleted: [Int]) {
    self.added = added
    self.deleted = deleted
  }
}
