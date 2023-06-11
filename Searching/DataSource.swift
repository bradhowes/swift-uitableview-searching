import UIKit

class DataSource : UITableViewDiffableDataSource<Section, Title> {

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    snapshot().sectionIdentifiers[section].label
  }
}
