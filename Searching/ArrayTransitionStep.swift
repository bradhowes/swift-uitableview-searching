import Foundation

// Based on https://lukaszielinski.de/blog/posts/2019/02/03/calculating-the-deltas-for-performbatchupdates/

enum ArrayTransitionStep {

  case added(Int)
  case deleted(Int)
  case moved(Int, Int)

  /**
   Calculate the number of steps necessary to change from one collection of integers to another collection.

   - parameter from: the starting collection state
   - parameter to: the final collection state
   - returns: the steps
   */
  static func changes(from: [Int], to: [Int]) -> [ArrayTransitionStep] {

    // Generate mappings from values to array indices
    let fromMap = [Int: Int](uniqueKeysWithValues: from.enumerated().map { ($0.1, $0.0) } )
    var toMap = [Int: Int](uniqueKeysWithValues: to.enumerated().map { ($0.1, $0.0) } )

    var actions = [ArrayTransitionStep]()
    for value in fromMap.keys.sorted() {
      let fromIndex = fromMap[value]!
      if let toIndex = toMap[value] {
        if fromIndex != toIndex {
          actions.append(.moved(fromIndex, toIndex))
        }
        toMap.removeValue(forKey: value)
      } else {
        actions.append(.deleted(fromIndex))
      }
    }

    return actions + toMap.keys.map { .added(toMap[$0]!) }
  }
}
