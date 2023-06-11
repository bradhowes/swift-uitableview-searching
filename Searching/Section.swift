enum Section: UInt32, CaseIterable {
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

  var label: String {
    guard self != .Other else { return "?" }
    return String((UnicodeScalar(self.rawValue + ascii_A_unicodeScalar)!))
  }

  static func locate(title: SortableTitle) -> Section {
    guard let first = title.value.unicodeScalars.first?.value,
          first >= ascii_A_unicodeScalar,
          first <= ascii_Z_unicodeScalar else {
      return .Other
    }
    return .init(rawValue: first - ascii_A_unicodeScalar) ?? .Other
  }
}

private let ascii_A_unicodeScalar: UInt32 = UnicodeScalar(UInt8(ascii: "A")).value
private let ascii_Z_unicodeScalar: UInt32 = UnicodeScalar(UInt8(ascii: "Z")).value
