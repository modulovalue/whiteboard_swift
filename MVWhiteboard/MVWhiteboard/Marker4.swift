//
//  Marker4.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 18.07.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Foundation
import Cocoa

enum MarkerMode {
    case NONE
    case SELECTFIRST
    case SELECTSECOND
}

class Marker4: InteractableObject, NSCoding, Hideable, SequentiallyDeletable, NewAddable, Connectable {

    static var defaultRadius = 500.0

    override var x: Double { didSet {} }

    override var y: Double { didSet {} }
    
    var markers: [SingleMarker4] = []

    var directionalEdges: [(posInMarkersFrom: Int, posInMarkersTo: Int)] = [] {
        didSet {
            print(directionalEdges)
        }
    }

    var markerMode: MarkerMode

    var selectedMarker: SingleMarker4?

    var _view: NSView

    var selectable: Selectable

    var draggable: Draggable

    init(selectable: Selectable, draggable: Draggable, x: CGFloat, y: CGFloat, scale: Double, rot: Double) {
        _view = NSView(frame: NSRect(x: 0.0, y: 0.0, width: 80000.0, height: 80000.0))
        self.selectable = selectable
        self.draggable = draggable
        self.markerMode = .NONE
        super.init(x: Double(0.0), y: Double(0.0), scale: scale, rot: rot)
        addNew(at: CGPoint(x: x, y: y), radius: 500.0)
        NotificationCenter.default.addObserver(forName: .didTouchContentView, object:nil, queue:nil) { notification in
            print("received notifiction")
            self.connectMode(isActive: false)
        }
    }

    // NewAddable
    func addNew(at: CGPoint, radius: Double) {

        let newMarker = SingleMarker4(x: at.x, y: at.y, radius: radius, color: NSColor.red)
        self.markers.append(newMarker)
        self.selectedMarker = newMarker
        self._view.addSubview(newMarker)

        newMarker.draggedEvent = { event, marker in
            let newPos: (CGPoint) -> () = { newPos in
                marker.frame.origin.x += newPos.x
                marker.frame.origin.y += newPos.y
            }
            self.draggable.dragged(event: event, newDeltaPos: newPos)
        }

        newMarker.clickedEvent = { event, marker in
            self.selectable.setSelected(self)

            switch self.markerMode {
            case .NONE:
                self.selectedMarker = marker
            case .SELECTFIRST:
                if self.selectedMarker != marker {
                    self.markerMode = .SELECTSECOND
                    self.selectedMarker = marker
                }
            case .SELECTSECOND:
                let edge = (self.markers.index(of: self.selectedMarker!)!,
                            self.markers.index(of: marker)!)
                self.directionalEdges.append(edge)
                self.selectedMarker = marker
            }
        }
    }

    // Connectable
    func connectMode(isActive: Bool) {
        if markerMode == .NONE {
            markerMode = .SELECTFIRST
        } else if markerMode != .NONE {
            markerMode = .NONE
        }
    }

    class SingleMarker4: NSView {
        var draggedEvent: ((NSEvent, SingleMarker4) -> Void)? = nil
        var clickedEvent: ((NSEvent, SingleMarker4) -> Void)? = nil

        override func mouseDragged(with event: NSEvent) {
            draggedEvent?(event, self)
        }

        override func mouseDown(with event: NSEvent) {
            clickedEvent?(event, self)
        }

        init(x: CGFloat, y: CGFloat, radius: Double, color: NSColor) {
            super.init(frame: NSRect(x: Double(x), y: Double(y), width: radius, height: radius))
            wantsLayer = true
            layer?.masksToBounds = true
            layer?.cornerRadius = (radius.cg / 3)
            backgroundColorr = color
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    override func view() -> NSView {
        return _view
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(selectable: ViewController.instance!,
                  draggable: ViewController.instance!,
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

    // SequentiallyDeletable
    func deletable() -> Bool {
        return selectedMarker != nil
    }

    func deleteFinally() -> Bool {
        markers = markers.filter() { $0 !== selectedMarker }
        selectedMarker?.removeFromSuperview()
        selectedMarker = nil
        return markers.isEmpty
    }

    // Hideable
    func hide(hide: Bool) {
        _view.isHidden = hide
    }
}
