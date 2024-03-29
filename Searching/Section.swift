/**
 Enumeration for all of the sections. There is one section for each letter of the English alphabet + one for those
 titles whose first character is something other than a letter. Note that the sorting of the titles will place numbers
 before letters, but the section order will force the titles start with numbers to appear at the end of any list.
 */
enum Section: UInt32 {
  case A = 0
  case B
  case C
  case D
  case E
  case F
  case G
  case H
  case I
  case J
  case K
  case L
  case M
  case N
  case O
  case P
  case Q
  case R
  case S
  case T
  case U
  case V
  case W
  case X
  case Y
  case Z
  case Other

  /// Obtain the label to show in the table view for the section
  var label: String {
    self == .Other ? "#" : String((UnicodeScalar(self.rawValue + ascii_A_unicodeScalar)!))
  }

  /**
   Obtain the Section enum that the given title will appear under.

   - parameter title: a SortableTitle to query
   - returns: the Section enum the title falls under
   */
  static func locate(title: SortableTitle) -> Section {
    guard let first = title.sortable.unicodeScalars.first?.value,
          first >= ascii_A_unicodeScalar,
          first <= ascii_Z_unicodeScalar else {
      return .Other
    }
    return .init(rawValue: first - ascii_A_unicodeScalar) ?? .Other
  }
}

extension Section: Equatable {
  static func == (lhs: Section, rhs: Section) -> Bool { lhs.rawValue == rhs.rawValue }
}

extension Section: Comparable {
  static func < (lhs: Section, rhs: Section) -> Bool { lhs.rawValue < rhs.rawValue }
}

private let ascii_A_unicodeScalar: UInt32 = UnicodeScalar(UInt8(ascii: "A")).value
private let ascii_Z_unicodeScalar: UInt32 = UnicodeScalar(UInt8(ascii: "Z")).value
