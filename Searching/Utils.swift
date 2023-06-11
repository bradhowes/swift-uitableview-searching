import Foundation


func sortable(from value: String) -> String {
  value.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
}

private let skippedArticles = Set(["A", "An", "The"].map { sortable(from: $0) })

func sortableTitle(from title: String) -> String {
  let title = sortable(from: title)
  let words = title.split(separator: " ").map { String($0) }
  guard
    let first = words.first,
    words.count > 1,
    skippedArticles.contains(first)
  else {
    return title
  }
  return words.dropFirst().joined(separator: " ")
}

func partitionTitles(_ titles: [Title]) -> [TableSection] {
  titles.reduce(into: [TableSection](), { partialResult, title in
    guard
      partialResult.last?.section == title.section
    else {
      partialResult.append(.init(title: title))
      return
    }
    partialResult[partialResult.count - 1].append(title: title)
  })
}

func calculateArrayChanges(from fromIndices: [Int], to toIndices: [Int]) -> (added: IndexSet,
                                                                             removed: IndexSet,
                                                                             common: IndexSet) {
  var fromIndex = 0
  var toIndex = 0
  var added: IndexSet = .init()
  var removed: IndexSet = .init()
  var common: IndexSet = .init()

  while fromIndex < fromIndices.count && toIndex < toIndices.count {
    let fromValue = fromIndices[fromIndex]
    let toValue = toIndices[toIndex]

    if fromValue < toValue {
      removed.insert(fromIndex)
      fromIndex += 1
    } else if fromValue > toValue {
      added.insert(toIndex)
      toIndex += 1
    } else {
      common.insert(fromIndex)
      fromIndex += 1
      toIndex += 1
    }
  }

  // Remaining fromViewIndices must be deleted since they are not in the toViewIndices collection
  removed.insert(integersIn: fromIndex..<fromIndices.count)

  // Remaining toViewIndices must be added since hey were not in the fromViewIndices collection
  added.insert(integersIn: toIndex..<toIndices.count)

  return (added: added, removed: removed, common: common)
}
