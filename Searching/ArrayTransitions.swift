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
    var fromIndex = 0
    var toIndex = 0
    var added = [Int]()
    var deleted = [Int]()

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
