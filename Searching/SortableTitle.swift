/**
 A title that has been modified to be sortable and searchable.
 */
struct SortableTitle {
  let title: String
  let sortable: String

  init(title: String) {
    self.title = title
    self.sortable = sortableTitle(from: title)
  }
}

extension SortableTitle: Equatable {
  static func == (lhs: SortableTitle, rhs: SortableTitle) -> Bool { lhs.sortable == rhs.sortable }
}

extension SortableTitle: Comparable {
  static func  < (lhs: SortableTitle, rhs: SortableTitle) -> Bool { lhs.sortable  < rhs.sortable }
}
