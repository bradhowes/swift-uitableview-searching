/**
 A collection of values that describes the section in a table.
 */
struct TableSection {
  let section: Section
  var titles: [Title]

  init(title: Title) {
    self.section = title.section
    self.titles = [title]
  }

  mutating func append(title: Title) { titles.append(title) }
}
