//
//  Cyanic
//  Created by Julio Miguel Alorro on 14.04.19.
//  Licensed under the MIT license. See LICENSE file
//

import UIKit

/**
 TableComponentViewController is a subclass of ComponentViewController. It serves as the base class for the
 SingleSectionTableComponentViewController and MultiSectionTableComponentViewController, therefore it contains
 the logic and implementations shared between the two subclasses.
*/
open class TableComponentViewController: ComponentViewController, UITableViewDelegate {

    // MARK: UIViewController Lifecycle Methods
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Register TableComponentCell
        self.tableView.register(TableComponentCell.self, forCellReuseIdentifier: TableComponentCell.identifier)

        // Set up as the UITableView's UITableViewDelegate
        self.tableView.delegate = self
    }

    // MARK: Views
    /**
     The UITableView instance managed by this CollectionComponentViewController instance.
    */
    public var tableView: UITableView {
        return self._listView as! UITableView // swiftlint:disable:this force_cast
    }

    // MARK: Methods
    /**
     Creates a UITableView with a UITableView.Style of plain. This method is called in the ComponentViewController's
     loadView method.
     - Returns:
        - UITableView instance typed as a UIView.
     */
    open override func setUpListView() -> UIView {
        return UITableView(
            frame: CGRect.zero,
            style: UITableView.Style.plain
        )
    }

    // MARK: UITableViewDelegate Methods
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let component: AnyComponent = self.component(at: indexPath) else { return }
        guard let selectable = component.identity.base as? Selectable else { return }
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        selectable.onSelect(cell.contentView)
    }
}
