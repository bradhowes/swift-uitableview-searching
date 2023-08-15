import UIKit

/**
 Custom diffable data source that provides section titles.
 */
class DataSource : UITableViewDiffableDataSource<Section, Title> {

  /**
   Create a new snapshot to be used in a DataSource.

   - parameter term: the search term to use to filter titles to be in the new collection (empty string shows all)
   - returns: new NSDiffableDataSourceSnapshot instance
   */
  static func buildSnapshot(term: String) -> NSDiffableDataSourceSnapshot<Section, Title> {
    let titles = term.isEmpty ? allTitles : (allTitles.filter { $0.matches(term.uppercased()) })
    let tableSections = partitionTitles(titles)

    var snapshot = NSDiffableDataSourceSnapshot<Section, Title>()
    snapshot.appendSections(tableSections.map { $0.section })
    tableSections.forEach { snapshot.appendItems($0.titles, toSection: $0.section) }

    return snapshot
  }

  /**
   Obtain a section title.

   - parameter tableView: the table view to show
   - parameter section: the section to show
   - returns: the tile of the section
   */
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    snapshot().sectionIdentifiers[section].label
  }

  /**
   Obtain the labels to show for the section index labels on side of table. Clicking on an index title will scroll make
   that index visible.

   - parameter tableView: the table view to show
   - returns: the set of labels to show
   */
  override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    snapshot().sectionIdentifiers.map { $0.label }
  }
}
