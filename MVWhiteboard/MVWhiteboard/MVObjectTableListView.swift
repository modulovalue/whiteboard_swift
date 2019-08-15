//
//  MVObjectListView.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 11.10.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Foundation
import Cocoa

class MVObjectTableListView: NSTableView, NSTableViewDataSource, NSTableViewDelegate {

    override var numberOfRows: Int {
        return 10
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.make(withIdentifier: "ObjectListCellID", owner: self) as? NSTableCellView
        cell?.textField?.stringValue = "item[(tableColumn?.identifier)!]!"
        return cell
    }

}
