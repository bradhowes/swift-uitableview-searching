import Foundation

/**
 Obtain a 'sortable' representation of a string:
 * strips all whitespace values from start and end of string
 * moves all characters to uppercase for searching

 - parameter value: the value to use
 - returns: sortable representation
 */
func sortable(from value: String) -> String {
  value.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
}

private let skippedArticles = Set(["A", "An", "The"].map { sortable(from: $0) })

/**
 Obtain a sortable title. This uses `sortable` to transform the input, and it drops the first word of the title if
 the first word is in the `skippedArticles` set.

 - parameter title: the original title
 - returns: a sortable representation
 */
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

/**
 Partition a list of `Title` entities into a collection of `TableSection` entities based on their section values.

 - parameter titles: the collection of `Title` entities to partition
 - returns: the collection of `TableSection` that was generated
 */
func partitionTitles(_ titles: [Title]) -> [SectionTitles] {
  titles.reduce(into: [[Title]](), { partialResult, title in

    // Combine titles with same section into an array, then create a TableSection instance for each array and finally
    // order the instances by their section values.
    if partialResult.last?.last?.section == title.section {
      partialResult[partialResult.count - 1].append(title)
    } else {
      partialResult.append(.init(arrayLiteral: title))
    }
  }).map { .init(section: $0[0].section, titles: $0) }
    .sorted()
}
