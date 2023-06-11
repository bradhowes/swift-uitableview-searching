import UIKit

/**
 Custom diffable data source that provides section titles.
 */
class DataSource : UITableViewDiffableDataSource<Section, Title> {

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
