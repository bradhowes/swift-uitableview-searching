/**
 A collection of values that describes the section in a table.
 */
struct SectionTitles {
  let section: Section
  let titles: [Title]

  init(section: Section, titles: [Title]) {
    self.section = section
    self.titles = titles
  }
}

extension SectionTitles: Equatable {
  static func ==(lhs: SectionTitles, rhs: SectionTitles) -> Bool { lhs.section == rhs.section }
}

extension SectionTitles: Comparable {
  static func < (lhs: SectionTitles, rhs: SectionTitles) -> Bool { lhs.section < rhs.section }
}
