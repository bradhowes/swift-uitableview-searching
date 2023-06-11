/**
 A title that has been modified to be sortable and searchable.
 */
struct SortableTitle : Comparable {
  let value: String

  init(title: String) {
    self.value = sortableTitle(from: title)
  }

  static func  < (lhs: SortableTitle, rhs: SortableTitle) -> Bool { lhs.value  < rhs.value }
  static func == (lhs: SortableTitle, rhs: SortableTitle) -> Bool { lhs.value == rhs.value }
}
