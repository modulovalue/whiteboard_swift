//
//  MVTextView.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 05.07.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Foundation
import Cocoa

class MVTextView: NSTextView, NSTextViewDelegate {

    static var textView: MVTextView? = nil {
        didSet {
            oldValue?.setActive(false)
            textView?.setActive(true)
        }
    }

    var delegate2: MVTextViewDelegate? = nil

    var draggableColor = NSColor.black
    var activeColor: NSColor = NSColor(calibratedRed: 0.0, green: 0.0, blue: 0.25, alpha: 1.0)

    func setup(x: CGFloat, y: CGFloat, width: CGFloat, text: NSAttributedString) {
      //  scaleUnitSquare(to: NSSize(width: 3.0, height: 3.0))
        setFrameOrigin(NSPoint(x: x, y: y))
        setActive(false)
        textStorage?.setAttributedString(text)
        delegate = self
    }

    func setActive(_ boo: Bool) {
        isSelectable = boo
        isEditable = boo
        backgroundColor = boo ? activeColor : draggableColor
    }

    var mouseDownPoint: NSPoint = NSPoint.zero

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        delegate2?.setSelected()
        mouseDownPoint = event.locationInWindow
    }

    override func mouseUp(with event: NSEvent) {
        if event.locationInWindow == mouseDownPoint {
            MVTextView.textView = self
        }
    }

    func textDidChange(_ notification: Notification) {
        delegate2?.textDidChange(attributedString())
        setFrameOrigin(NSPoint(x: frame.origin.x, y: frame.origin.y))
    }

    override func mouseDragged(with event: NSEvent) {
        delegate2?.dragged(event)
    }
}

protocol MVTextViewDelegate: ClickSelectable {
    func textDidChange(_ str: NSAttributedString)
    func dragged(_ event: NSEvent)
}
