/**
 A collection of values that describes the section in a table.
 */
struct TableSection {
  let section: Section
  let titles: [Title]

  init(section: Section, titles: [Title]) {
    self.section = section
    self.titles = titles
  }
}

extension TableSection: Equatable {
  static func ==(lhs: TableSection, rhs: TableSection) -> Bool { lhs.section == rhs.section }
}

extension TableSection: Comparable {
  static func < (lhs: TableSection, rhs: TableSection) -> Bool { lhs.section < rhs.section }
}
