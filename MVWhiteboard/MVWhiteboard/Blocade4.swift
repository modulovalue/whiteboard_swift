//
//  Blocade4.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 09.07.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Foundation
import Cocoa

class Blocade4: InteractableObject, NSCoding, Deletable {

    private var _view: MVView

    private var imageViewEventProtocol: ImageViewEventProtocol? = nil

    class MVView: NSView {
        var draggedEvent: ((NSEvent) -> Void)? = nil
        var clickedEvent: ((NSEvent) -> Void)? = nil

        override func mouseDragged(with event: NSEvent) {
            draggedEvent?(event)
        }

        override func mouseDown(with event: NSEvent) {
            clickedEvent?(event)
        }
    }

    init(_ eventProtoc: ImageViewEventProtocol, x: CGFloat, y: CGFloat, scale: Double, rot: Double) {
        _view = MVView(frame: NSRect(x: 0.0, y: 0.0, width: 1000.0, height: 2000.0))
        _view.backgroundColorr = NSColor.green
        super.init(x: Double(x), y: Double(y), scale: scale, rot: rot)
        _view.draggedEvent = { event in eventProtoc.dragged(imageView: self, event: event) }
        _view.clickedEvent = { event in eventProtoc.setSelected(self) }
        imageViewEventProtocol = eventProtoc
    }

    override func view() -> NSView {
        return _view
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(ViewController.instance!,
                  x: CGFloat(aDecoder.decodeDouble(forKey: "x")),
                  y: CGFloat(aDecoder.decodeDouble(forKey: "y")),
                  scale: aDecoder.decodeDouble(forKey: "scale"),
                  rot: aDecoder.decodeDouble(forKey: "rot"))
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(x, forKey: "x")
        aCoder.encode(y, forKey: "y")
        aCoder.encode(scale, forKey: "scale")
        aCoder.encode(rotation, forKey: "rot")
    }

    func delete() -> Bool {
        return true
    }
}

