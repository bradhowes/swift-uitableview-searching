import Foundation

/**
 A title that is shown in a section of a table. It holds a 'sortable' title that is always uppercase and without
 any article at the beginning ('A', 'An', 'The'). It also knows what section it belongs to.
 */
struct Title : Comparable, Hashable {
  let index: Int
  let title: String
  let sortable: SortableTitle
  let section: Section

  init(index: Int, title: String) {
    self.index = index
    self.title = title
    let sortable = SortableTitle(title: title)
    self.sortable = sortable
    self.section = Section.locate(title: sortable)
  }

  func hash(into hasher: inout Hasher) { hasher.combine(self.index) }

  static func  < (lhs: Title, rhs: Title) -> Bool { lhs.sortable < rhs.sortable }
  static func == (lhs: Title, rhs: Title) -> Bool { lhs.sortable == rhs.sortable }
}

/// Collection of all of the titles that are shown in the table.
let allTitles: [Title] = [
  "12 Monkeys",
  "Absence of Malice",
  "The Adventures of Baron von Munchhausen",
  "Alien",
  "Aliens",
  "Alien: Covenant",
  "All the President's Men",
  "Almost Famous",
  "Baby Driver",
  "Barry Lyndon",
  "Blowfish",
  "Bottle Rocket",
  "The Bourne Identity",
  "The Bourne Legacy",
  "Call Me By Your Name",
  "Casino",
  "Casino Royale",
  "Clueless",
  "The Darjeeling Limited",
  "Deadpool",
  "Deadpool 2",
  "Death Becomes Her",
  "Emma",
  "Ender's Game",
  "Everything, Everywhere, All at Once",
  "The Fantastic Mister Fox",
  "Fast Times at Ridgemont High",
  "The Favorite",
  "The Girl Who Kicked the Hornets' Nest",
  "The Girl Who Played with Fire",
  "The Girl with the Dragon Tattoo",
  "Goodfellas",
  "Goosebumps",
  "Grand Budapest Hotel",
  "Grease",
  "Harry Potter",
  "Hellraiser",
  "Hereditary",
  "Holy Motors",
  "I Love Huckabees",
  "Incredibles",
  "Incredibles 2",
  "Invictus",
  "Isle of Dogs",
  "Jackie",
  "Jackie Brown",
  "JFK",
  "Jojo Rabbit",
  "Kill Bill",
  "The Killing Fields",
  "Klute",
  "The Last Man on the Moon",
  "The Last Picture Show",
  "The Last Seduction",
  "Legally Blonde",
  "The Life Aquatic with Steve Zissou",
  "Manhunter",
  "Married to the Mob",
  "The Martian",
  "Moonrise Kingdom",
  "Night of the Hunter",
  "Nikita",
  "No Time to Die",
  "Nomadland",
  "O Brother, Where Art Thou?",
  "Office Space",
  "The Omega Man",
  "The Omen",
  "One Flew Over the Cuckoo's Nest",
  "The Parallax View",
  "Parasite",
  "Pig",
  "Platoon",
  "Pulp Fiction",
  "Quantum of Solace",
  "The Queen",
  "The Quiet American",
  "Reservoir Dogs",
  "Ringu",
  "The Royal Tenenbaums",
  "Rushmore",
  "Scarface",
  "Scream",
  "Seems Like Old Times",
  "Seven",
  "Skyfall",
  "Something Wild",
  "Spectre",
  "Stop Making Sense",
  "The Talented Mr. Ripley",
  "Tenet",
  "Testing",
  "The Thing",
  "Three Days of the Condor",
  "Titanic",
  "The Unbearable Lightness of Being",
  "The Usual Suspects",
  "The Untouchables",
  "Venom",
  "The Verdict",
  "Walk the Line",
  "Wall Street",
  "The Watchmen",
  "Whiplash",
  "The Wolf of Wall Street",
  "X-Men",
  "X2",
  "X-Men: The Last Stand",
  "Y Tu Mama Tambien",
  "The Year of Living Dangerously",
  "Yentl",
  "Yes Man",
  "Yesterday's Girl",
  "Zardoz",
  "Zero Dark Thirty",
  "The Zero Theorem",
  "Zoolander",
].enumerated().map { Title(index: $0, title: $1) }.sorted()
