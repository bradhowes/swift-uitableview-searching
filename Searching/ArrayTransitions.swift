import Foundation
import Tagged

/**
 Provides a way to determine the additions and deletions necessary to transform one collection of view indices to
 another as long as rows are only added or removed (not moved).

 Loosely based on https://lukaszielinski.de/blog/posts/2019/02/03/calculating-the-deltas-for-performbatchupdates/
 which does handle row movement.
 */
struct ArrayTransitions {

  /// Collection of view indices that were added.
  let added: [Int]

  /// Collection of view indices that were removed.
  let deleted: [Int]

  /**
   Calculate the number of steps necessary to change from one collection of integers to another collection. A useful
   collection of integers could be the indices into a collection of data that is being displayed in a table view, and
   the indices would correspond to row values in the table view if every data item were to be displayed in the table.
   Often this is not the case, including when one applies a filter to see only those data elements that match the
   filter like in a text search.

   - parameter from: the starting collection state
   - parameter to: the final collection state
   - returns: ArrayTransitions instance with the additions and deletions
   */
  static func changes(from fromViewIndices: [Int], to toViewIndices: [Int]) -> ArrayTransitions {

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
    let deleted = DeletedArray(rawValue: fromReverseMap.compactMap { (valueIndex, viewIndex) in
      if toReverseMap[valueIndex] != nil {
        toReverseMap.removeValue(forKey: valueIndex)
        return nil
      }
      return viewIndex
    })

    return .init(added: .init(rawValue: toReverseMap.values.map { $0 }), deleted: deleted)
  }

  private init(added: AddedArray, deleted: DeletedArray) {
    self.added = added.map { $0.rawValue }
    self.deleted = deleted.map { $0.rawValue }
  }

  // Use internal types to make sure we are working with the right index since the two are both Int-based.
  private typealias ValueIndex = Tagged<(ArrayTransitions, valueIndex: ()), Int>
  private typealias ViewIndex = Tagged<(ArrayTransitions, viewIndex: ()), Int>
  // Additional collection types to help ensure we don't mix the additions and deletions.
  private typealias AddedArray = Tagged<(ArrayTransitions, addedArray: ()), [ViewIndex]>
  private typealias DeletedArray = Tagged<(ArrayTransitions, deletedArray: ()), [ViewIndex]>
}
