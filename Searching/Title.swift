import Foundation

struct Title : Comparable, Hashable {
  let identifier: Int
  let title: String
  let sortable: SortableTitle
  let section: Section

  init(index: Int, title: String) {
    self.identifier = index
    self.title = title
    let sortable = SortableTitle(title: title)
    self.sortable = sortable
    self.section = Section.locate(title: sortable)
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(self.identifier)
  }

  static func  < (lhs: Title, rhs: Title) -> Bool { lhs.sortable < rhs.sortable }
  static func == (lhs: Title, rhs: Title) -> Bool { lhs.sortable == rhs.sortable }
}
