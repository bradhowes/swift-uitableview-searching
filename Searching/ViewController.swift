import UIKit

class ViewController: UIViewController {
  static let selectedKey = "selected"

  private let contents = [
    "Testing",
    "Blowfish",
    "Something Wild",
    "Goosbumps",
    "Harry Potter",
    "Casino",
    "Goodfellas",
    "Tenent",
    "Married to the Mob",
    "Grease",
    "Bourne Identity",
    "Everything, Everywhere, All at Once",
    "Stop Making Sense",
    "The Unbearable Lightness of Being",
    "Rushmore",
    "Bottle Rocket",
    "Grand Budapest Hotel",
    "Moonrise Kingdom",
    "Isle of Dogs",
    "The Fantastic Mister Fox",
    "The Royal Tenenbaums",
    "The Life Aquatic with Steve Zissou",
    "The Darjeeling Limited"
  ]

  private var contentIndices: Range<Int> { 0..<contents.count }

  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var searchButton: UIBarButtonItem!
  @IBOutlet private weak var searchBar: UISearchBar!
  @IBOutlet private weak var searchBarHeightConstraint: NSLayoutConstraint!

  private var originalSearchBarHeight: CGFloat!
  private var visibleIndices = [Int]()

  /// The index of the contents entry that is selected.
  private var selectedContentIndex: Int {
    get { UserDefaults.standard.integer(forKey: Self.selectedKey) }
    set { UserDefaults.standard.set(newValue, forKey: Self.selectedKey) }
  }

  /// Obtain an IndexPath for the selected content
  private var selectedIndexPath: IndexPath? {
    visibleIndices
      .firstIndex { $0 == selectedContentIndex }
      .map { IndexPath(row: $0, section: 0) }
  }
}

extension ViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.accessibilityIdentifier = "mainView"
    searchBar.accessibilityIdentifier = "searchBar"
    searchBar.searchTextField.accessibilityIdentifier = "searchTextField"
    tableView.accessibilityIdentifier = "itemsTableView"

    originalSearchBarHeight = searchBarHeightConstraint.constant
    searchBarHeightConstraint.constant = 0
    tableView.dataSource = self
    tableView.delegate = self
    searchBar.delegate = self
    visibleIndices = Array(contentIndices)
    UserDefaults.standard.register(defaults: [Self.selectedKey: 0])
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let selectedIndexPath = selectedIndexPath {
      tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if let selectedIndexPath = selectedIndexPath {
      self.tableView.scrollToRow(at: selectedIndexPath, at: .none, animated: animated)
    }
  }
}

extension ViewController {

  /**
   Toggle the appearance of the search text field.

   - parameter sender: entity that sent the message
   */
  @IBAction func toggleSearch(_ sender: Any) {
    let goal = searchBarHeightConstraint.constant == 0 ? originalSearchBarHeight! : 0
    view.layoutIfNeeded()
    searchBarHeightConstraint.constant = goal
    UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
      self.view.layoutIfNeeded()
    }, completion: { _ in
      if goal == 0 {
        self.endSearch()
      } else {
        self.searchBar.becomeFirstResponder()
      }
    })
  }
}

extension ViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int { 1 }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    section == 0 ? visibleIndices.count : 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "item")!
    var content = cell.defaultContentConfiguration()
    content.text = contents[visibleIndices[indexPath.row]]
    cell.contentConfiguration = content
    cell.setSelected(indexPath.row == selectedIndexPath?.row, animated: false)
    return cell
  }
}

extension ViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedContentIndex = visibleIndices[indexPath.row]
  }
}

extension ViewController: UISearchBarDelegate {

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    let term = searchBar.text?.lowercased() ?? ""
    updateViewForSearch(term: term)
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    updateViewForSearch(term: searchText.lowercased())
  }
}

extension ViewController {

  /**
   Change the contents of visibleIndices and have the table view updated to match.

   - parameter block: the block to perform the changes to visibleIndices
   - parameter completionBlock: the block to run after the table view has been updated
   */
  private func updateTableRows(block: () -> (), completionBlock: (()->())? = nil) {
    guard let tableView = self.tableView else { return }
    tableView.performBatchUpdates({
      let from = visibleIndices
      block()

      let changes = ArrayTransitions.changes(from: from, to: visibleIndices)
      if !changes.added.isEmpty {
        tableView.insertRows(at: changes.added.map { IndexPath(row: $0, section: 0) }, with: .automatic)
      }
      if !changes.deleted.isEmpty {
        tableView.deleteRows(at: changes.deleted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
      }
    }) { _ in

      // Always keep the selected index selected if it is visible.
      tableView.selectRow(at: self.selectedIndexPath, animated: true, scrollPosition: .none)
      completionBlock?()
    }
  }

  /**
   Revise the visibleIndices to only show the items that match the given search term.

   - parameter term: the string to look for in the contents entries
   - parameter completionBlock: the block to run after the table view has been updated
   */
  private func updateViewForSearch(term: String, completionBlock: (()->())? = nil) {
    updateTableRows(block: {
      visibleIndices = term.isEmpty ? Array(contentIndices) : contents.enumerated()
        .filter { $0.1.lowercased().contains(term) }
        .map { $0.0 }
    }, completionBlock: completionBlock)
  }

  /**
   End search mode by dismissing the keyboard and showing all of the rows. Make sure the selected row is fully visible.
   */
  private func endSearch() {
    searchBar.resignFirstResponder()
    updateViewForSearch(term: "") {
      if let selectedIndexPath = self.selectedIndexPath {
        if !self.tableView.bounds.contains(self.tableView.rectForRow(at: selectedIndexPath)) {
          self.tableView.scrollToRow(at: selectedIndexPath, at: .none, animated: true)
        }
      }
    }
  }
}
