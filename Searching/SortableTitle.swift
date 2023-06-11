struct SortableTitle : Comparable {
  let value: String

  init(title: String) {
    self.value = sortableTitle(from: title)
  }

  static func  < (lhs: SortableTitle, rhs: SortableTitle) -> Bool { lhs.value  < rhs.value }
  static func == (lhs: SortableTitle, rhs: SortableTitle) -> Bool { lhs.value == rhs.value }
}
