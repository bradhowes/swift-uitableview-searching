import Foundation

/**
 A title that is shown in a section of a table. It holds a 'sortable' title that is always uppercase and without
 any article at the beginning ('A', 'An', 'The'). It also knows what section it belongs to.
 */
struct Title : Comparable, Hashable {
  let index: Int
  let section: Section
  var title: String { sortableTitle.title }

  private let sortableTitle: SortableTitle

  init(index: Int, sortableTitle: SortableTitle) {
    self.index = index
    self.sortableTitle = sortableTitle
    self.section = Section.locate(title: sortableTitle)
  }

  func matches(_ term: String) -> Bool { sortableTitle.sortable.contains(term) }

  func hash(into hasher: inout Hasher) { hasher.combine(self.index) }

  static func  < (lhs: Title, rhs: Title) -> Bool { lhs.sortableTitle < rhs.sortableTitle }
  static func == (lhs: Title, rhs: Title) -> Bool { lhs.sortableTitle == rhs.sortableTitle }
}

/// Collection of all of the titles that are shown in the table.
let allTitles: [Title] = [
  "12 Monkeys",
  "2001: A Space Odyssey",
  "Absence of Malice",
  "The Adventures of Baron von Munchhausen",
  "Alien",
  "Alien: Covenant",
  "Aliens",
  "All the President's Men",
  "Almost Famous",
  "Baby Driver",
  "Barry Lyndon",
  "Basic Instinct",
  "Blowfish",
  "Boogie Nights",
  "Bottle Rocket",
  "Bound",
  "The Bourne Identity",
  "The Bourne Legacy",
  "The Bourne Supremacy",
  "The Bourne Ultimatum",
  "Call Me By Your Name",
  "Casino",
  "Casino Royale",
  "A Clockwork Orange",
  "Clueless",
  "Crouching Tiger, Hidden Dragon",
  "The Darjeeling Limited",
  "Deadpool",
  "Deadpool 2",
  "Death Becomes Her",
  "Don't Look Now",
  "Dressed To Kill",
  "Dune",
  "Emma",
  "Encanto",
  "Ender's Game",
  "Enter the Dragon",
  "Everything, Everywhere, All at Once",
  "The Evil Dead",
  "The Fantastic Mister Fox",
  "Fast Times at Ridgemont High",
  "The Favorite",
  "A Few Good Men",
  "Field of Dreams",
  "The Fifth Element",
  "Fletch",
  "Frances Ha",
  "The French Dispatch",
  "Full Metal Jacket",
  "Get Shorty",
  "The Girl Who Kicked the Hornets' Nest",
  "The Girl Who Played with Fire",
  "The Girl with the Dragon Tattoo",
  "The Godfather",
  "The Godfather Part II",
  "Goldfinger",
  "The Good, the Bad and the Ugly",
  "Goodfellas",
  "Goosebumps",
  "Grand Budapest Hotel",
  "Gravity",
  "Grease",
  "The Green Knight",
  "Harry Potter",
  "Hellraiser",
  "Hereditary",
  "Holy Motors",
  "I Love Huckabees",
  "Incredibles",
  "Incredibles 2",
  "Indiana Jones and the Last Crusade",
  "Indiana Jones and the Raiders of the Lost Ark",
  "Indiana Jones and the Temple of Doom",
  "Invictus",
  "Isle of Dogs",
  "Jackie",
  "Jackie Brown",
  "Jason Bourne",
  "JFK",
  "Jojo Rabbit",
  "Kill Bill: Volume 1",
  "Kill Bill: Volume 2",
  "The Killing Fields",
  "Klute",
  "The Last Man on the Moon",
  "The Last Picture Show",
  "The Last Seduction",
  "The Late Show",
  "Legally Blonde",
  "The LEGO Batman Movie",
  "The LEGO Movie",
  "The LEGO Movie 2: The Second Part",
  "The Life Aquatic with Steve Zissou",
  "Manhunter",
  "Married to the Mob",
  "The Martian",
  "Mary Poppins Returns",
  "Master Gardner",
  "Midnight Run",
  "Midsommar",
  "Miller's Crossing",
  "Moon",
  "Moonrise Kingdom",
  "Moonstruck",
  "Night of the Hunter",
  "Nikita",
  "No Time to Die",
  "Nomadland",
  "O Brother, Where Art Thou?",
  "Office Space",
  "The Omega Man",
  "The Omen",
  "One Flew Over the Cuckoo's Nest",
  "Onward",
  "The Parallax View",
  "Parasite",
  "Pig",
  "Platoon",
  "Pride and Prejudice",
  "Prince: Sign 'o' the Times",
  "Prisoners",
  "Prometheus",
  "The Protégé",
  "Pulp Fiction",
  "Punch-Drunk Love",
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
  "Shawshank Redemption",
  "Silkwood",
  "Skyfall",
  "Something Wild",
  "Snowpiercer",
  "Sorcerer",
  "The Sound of Music",
  "Spectre",
  "Stop Making Sense",
  "Sweet Smell of Success",
  "Syriana",
  "The Talented Mr. Ripley",
  "Tenet",
  "Testing",
  "That Thing You Do",
  "The Thing",
  "Thor: Ragnarok",
  "Three Days of the Condor",
  "Titanic",
  "Tomb Raider",
  "Top Gun",
  "Total Recall",
  "Trading Places",
  "Training Day",
  "The Unbearable Lightness of Being",
  "Under African Skies",
  "The Untouchables",
  "The Usual Suspects",
  "Venom",
  "The Verdict",
  "Walk the Line",
  "Wall Street",
  "The Watchmen",
  "Whiplash",
  "The Wolf of Wall Street",
  "X2",
  "X-Men",
  "X-Men: The Last Stand",
  "Y Tu Mama Tambien",
  "The Year of Living Dangerously",
  "Yentl",
  "Yes Man",
  "Yesterday's Girl",
  "Zardoz",
  "Zero Dark Thirty",
  "Zero Effect",
  "The Zero Theorem",
  "Zombieland",
  "Zombieland: Double Tap",
  "Zoolander"
]
  .map { SortableTitle(title: $0) }
  .sorted()
  .enumerated()
  .map { Title(index: $0, sortableTitle: $1) }
