import UIKit

class ViewController: UIViewController {
  static let selectedKey = "selected"

  private let contents = [
    "Blowfish",
    "Bottle Rocket",
    "The Bourne Identity",
    "Casino",
    "Casino Royale",
    "The Darjeeling Limited",
    "Goodfellas",
    "Everything, Everywhere, All at Once",
    "The Fantastic Mister Fox",
    "The Girl Who Kicked the Hornets' Nest",
    "The Girl Who Played with Fire",
    "The Girl with the Dragon Tattoo",
    "Goosebumps",
    "Grand Budapest Hotel",
    "Grease",
    "Harry Potter",
    "Isle of Dogs",
    "The Life Aquatic with Steve Zissou",
    "Married to the Mob",
    "Moonrise Kingdom",
    "Quantum of Solace",
    "The Royal Tenenbaums",
    "Rushmore",
    "Something Wild",
    "Stop Making Sense",
    "Skyfall",
    "Tenent",
    "Testing",
    "The Unbearable Lightness of Being",
  ]

  private var contentIndices: Range<Int> { 0..<contents.count }

  /// The index of the contents entry that is selected. Note that this always returns a valid index (default is 0).
  private var selectedContentIndex: Int {
    get { min(UserDefaults.standard.integer(forKey: Self.selectedKey), contents.count - 1) }
    set { UserDefaults.standard.set(newValue, forKey: Self.selectedKey) }
  }

  /// The collection of contents indices that are visible in the table view.
  private var visibleIndices = [Int]()

  /// Obtain an IndexPath for the selected row. This may be None if the selected row is not visible.
  private var selectedIndexPath: IndexPath? {
    visibleIndices.firstIndex { $0 == selectedContentIndex } .map { IndexPath(row: $0, section: 0) }
  }

  /// True if the searchBar is visible
  private var isSearching: Bool { searchBarHeightConstraint.constant != 0 }

  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var searchButton: UIBarButtonItem!
  @IBOutlet private weak var searchBar: UISearchBar!
  @IBOutlet private weak var searchBarHeightConstraint: NSLayoutConstraint!

  private var originalSearchBarHeight: CGFloat!
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

    // Don't start typing an uppercase letter. We ignore case when we match, but this just looks a little nicer.
    searchButton.tintColor = .systemBlue
    searchBar.searchTextField.autocapitalizationType = .none
    searchBar.text = nil
    visibleIndices = Array(0..<contents.count)

    // Default to selecting the first item.
    UserDefaults.standard.register(defaults: [Self.selectedKey: 0])
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
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
  @IBAction func toggleSearch(_ sender: UIBarButtonItem) {
    let searchStarting = searchBarHeightConstraint.constant == 0
    let goal = searchStarting ? originalSearchBarHeight! : 0

    view.layoutIfNeeded()
    searchBarHeightConstraint.constant = goal

    if searchStarting {
      // Bring up the keyboard
      self.searchBar.becomeFirstResponder()
      sender.tintColor = .systemRed
    } else {
      sender.tintColor = .systemBlue
      // Put away the keyboard
      self.searchBar.resignFirstResponder()
      // Stop filtering the items and then scroll to the selected one.
      updateViewForSearch(term: "") {
        self.tableView.scrollToNearestSelectedRow(at: .none, animated: true)
      }
    }

    // Animate the above height change by repeatedly updating the view layout.
    UIView.animate(withDuration: 0.2, delay: 0.0) {
      self.view.layoutIfNeeded()
    }
  }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {

  /**
   Obtain the number of sections in the table view

   - parameter tableView: the table view being displayed
   - returns: the number of sections
   */
  func numberOfSections(in tableView: UITableView) -> Int { 1 }

  /**
   Obtain the number of items to show in a section

   - parameter tableView: the table view being displayed
   - parameter section: the section to show
   - returns: number of rows in the section
   */
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { visibleIndices.count }

  /**
   Obtain a formatted table view cell for a given item.

   - parameter tableView: the table view being displayed
   - parameter indexPath: the coordinates of the item being shown
   - returns: the table view cell to use
   */
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "item")!
    var content = cell.defaultContentConfiguration()
    content.text = contents[visibleIndices[indexPath.row]]
    cell.contentConfiguration = content
    return cell
  }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {

  /**
   Notification that a row has been selected. Remember the index of the item and dismiss any active searching.

   - parameter tableView: the table view that was selected
   - parameter indexPath: the coordinates of the item that was selected
   */
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedContentIndex = visibleIndices[indexPath.row]
    if isSearching {
      toggleSearch(self.searchButton)
    }
  }
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {

  /**
   Handle the keyboard "done" button.

   - parameter searchBar: the search bar the button tap was for
   */
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    toggleSearch(self.searchButton)
  }

  /**
   Notification that the text field is now active and is the first responder for typing.

   - parameter searchBar: the search bar that is active
   */
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    // Reuse the last search term if present
    updateViewForSearch(term: searchBar.text?.lowercased() ?? "")
  }

  /**
   Notification that the search bar text has changed. Updates the view of items that match the search term.

   - parameter searchBar: the search bar that is active
   - parameter searchText: the new search term
   */
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    updateViewForSearch(term: searchText.lowercased())
  }
}

private extension ViewController {

  /**
   Revise the visibleIndices to only show the items that match the given search term.

   - parameter term: the string to look for in the contents entries
   - parameter completionBlock: the block to run after the table view has been updated
   */
  func updateViewForSearch(term: String, completionBlock: (()->())? = nil) {
    tableView.performBatchUpdates({
      // Remember the current collection of indices
      let from = visibleIndices
      // Generate the new collection of indices
      if term.isEmpty {
        visibleIndices = Array(contentIndices)
      } else {
        visibleIndices = contentIndices
          .filter { contents[$0].lowercased().contains(term) }
      }

      // Calculate the changes from the old to the new value and apply them to the table view.
      let changes = ArrayTransitions.changes(from: from, to: visibleIndices)
      if !changes.added.isEmpty {
        self.tableView.insertRows(at: changes.added.map { IndexPath(row: $0, section: 0) }, with: .automatic)
      }
      if !changes.deleted.isEmpty {
        self.tableView.deleteRows(at: changes.deleted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
      }
    }) { _ in
      // The selected content row might have reappeared so we need to make sure that it is selected in the table
      // view.
      self.tableView.selectRow(at: self.selectedIndexPath, animated: false, scrollPosition: .none)
      completionBlock?()
    }
  }
}
