//
//  TableComponentViewController.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 4/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class UIKit.UITableView
import class UIKit.UIView
import protocol UIKit.UITableViewDelegate
import struct CoreGraphics.CGRect
import struct Foundation.IndexPath

/**
 TableComponentViewController is the base class of UIViewControllers that use Cyanic's state driven UI logic
*/
open class TableComponentViewController: AbstractComponentViewController, UITableViewDelegate {

    // MARK: UIViewController Lifecycle Methods
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(TableComponentCell.self, forCellReuseIdentifier: TableComponentCell.identifier)

        // Set up as the UITableView's UITableViewDelegate
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
    }

    // MARK: Views
    /**
     The UITableView instance managed by this ComponentViewController instance.
     */
    public var tableView: UITableView {
        return self._listView as! UITableView // swiftlint:disable:this force_cast
    }

    // MARK: Methods
    internal override func setUpListView() -> UIView {
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
        selectable.onSelect()
    }
}
