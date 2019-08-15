//
//  MVToolbar.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 09.07.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Cocoa

class MVToolbar: NSToolbar {
    
    let ProjectListToolbarItemID = "ProjectListToolbarItemID"
    let ShowHideablesToolbarItemID = "ShowHideablesToolbarItemID"

    let OpenObjectToolbarItemID = "OpenObjectToolbarItemID"
    let MarkObjectToolbarItemID = "MarkObjectToolbarItemID"
    let SizeSliderObjectToolbarItemID = "SizeSliderObjectToolbarItemID"
    let SizeButtonObjectToolbarItemID = "SizeButtonObjectToolbarItemID"
    let RemoveObjectToolbarItemID = "RemoveObjectToolbarItemID"
    let NewMarkingNodeToolbarItemID = "NewMarkingNodeToolbarItemID"
    let MarkingConnectionModeToolbarItemID = "MarkingConnectionModeToolbarItemID"

    var open = true
    var mark = true
    var resize = true
    var remove = true
    var newMarking = true
    var connectable = true

    override func validateVisibleItems() {
        super.validateVisibleItems()
    }

    func update() {
        items.forEach { _ in
            removeItem(at: 0)
        }
        objectToolbarAll().forEach {
            insertItem(withItemIdentifier: $0, at: items.count)
        }
        items.forEach {
            $0.isEnabled = true
        }
    }

    func projectToolbar() -> [String] {
        return [ProjectListToolbarItemID,
                ShowHideablesToolbarItemID]
    }

    func objectToolbarAll() -> [String] {
        var items = [String]()
        items += projectToolbar()
        items += ["NSToolbarFlexibleSpaceItem"]

        if (open)           {items.append(OpenObjectToolbarItemID)}
        if (mark)           {items.append(MarkObjectToolbarItemID)}
        if (resize)         {items.append(SizeSliderObjectToolbarItemID)}
        if (resize)         {items.append(SizeButtonObjectToolbarItemID)}
        if (remove)         {items.append(RemoveObjectToolbarItemID)}
        if (newMarking)     {items.append(NewMarkingNodeToolbarItemID)}
        if (connectable)    {items.append(MarkingConnectionModeToolbarItemID)}
        
        items += ["NSToolbarFlexibleSpaceItem"]
        
        return items
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [String] {
        return objectToolbarAll()
    }
    
}
