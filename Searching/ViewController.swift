import UIKit

class ViewController: UIViewController {
  static let selectedKey = "selected"

  /// The index of the contents entry that is selected. Note that this always returns a valid index (default is 0).
  private var selectedTitleIndex: Int {
    get { min(UserDefaults.standard.integer(forKey: Self.selectedKey), allTitles.count - 1) }
    set { UserDefaults.standard.set(newValue, forKey: Self.selectedKey) }
  }

  /// Obtain an IndexPath for the selected row. This may be None if the selected row is not visible.
  private var selectedIndexPath: IndexPath? {
    dataSource.indexPath(for: allTitles[self.selectedTitleIndex])
  }

  /// True if the searchBar is visible
  private var isSearching: Bool { searchBarHeightConstraint.constant != 0 }

  /// Custom diffable data source
  private var dataSource: DataSource!

  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var searchButton: UIBarButtonItem!
  @IBOutlet private weak var searchBar: UISearchBar!
  @IBOutlet private weak var searchBarHeightConstraint: NSLayoutConstraint!

  private var originalSearchBarHeight: CGFloat!
}

extension ViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    dataSource = DataSource(tableView: tableView) { tableView, indexPath, item in
      let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
      var content = cell.defaultContentConfiguration()
      content.text = item.title
      cell.contentConfiguration = content
      return cell
    }

    view.accessibilityIdentifier = "mainView"

    searchBar.accessibilityIdentifier = "searchBar"
    searchBar.searchTextField.accessibilityIdentifier = "searchTextField"
    tableView.accessibilityIdentifier = "itemsTableView"

    originalSearchBarHeight = searchBarHeightConstraint.constant
    searchBarHeightConstraint.constant = 0
    tableView.dataSource = dataSource
    tableView.delegate = self
    searchBar.delegate = self

    // Don't start typing an uppercase letter. We ignore case when we match, but this just looks a little nicer.
    searchButton.tintColor = .systemBlue
    searchBar.searchTextField.autocapitalizationType = .none
    searchBar.text = nil

    // Default to selecting the first item.
    UserDefaults.standard.register(defaults: [Self.selectedKey: 0])
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateViewForSearch(term: "")
    tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if let selectedIndexPath {
      self.tableView.scrollToRow(at: selectedIndexPath, at: .none, animated: false)
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
      self.tableView.scrollToRow(at: .init(row: 0, section: 0), at: .top, animated: false)
      sender.tintColor = .systemRed
    } else {
      sender.tintColor = .systemBlue
      // Put away the keyboard
      self.searchBar.resignFirstResponder()
      // Stop filtering the items and then scroll to the selected one.
      updateViewForSearch(term: "") {
        self.tableView.scrollToNearestSelectedRow(at: .none, animated: false)
      }
    }

    // Animate the above height change by repeatedly updating the view layout.
    UIView.animate(withDuration: 0.2, delay: 0.0) {
      self.view.layoutIfNeeded()
    }
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
    selectedTitleIndex = dataSource.itemIdentifier(for: indexPath)?.index ?? 0
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
    let titles = term.isEmpty ? allTitles : (allTitles.filter { $0.matches(term.uppercased()) })
    let visibleIndicesBySection = partitionTitles(titles)

    var snapshot = NSDiffableDataSourceSnapshot<Section, Title>()
    snapshot.appendSections(visibleIndicesBySection.map { $0.section })

    for section in visibleIndicesBySection {
      snapshot.appendItems(section.titles, toSection: section.section)
    }

    dataSource.apply(snapshot, animatingDifferences: true) {
      self.tableView.selectRow(at: self.selectedIndexPath, animated: false, scrollPosition: .none)
      completionBlock?()
    }
  }
}
