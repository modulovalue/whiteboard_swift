//
//  MVTextField.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 02.07.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Foundation
import Cocoa

class MVTextField: NSTextField {

    static var textField: MVTextField? = nil {
        didSet {
            if oldValue != textField {
                oldValue?.window?.makeFirstResponder(nil)
            }
        }
    }

    var fontSize: Double? = nil {
        didSet {
            self.font = NSFont.systemFont(ofSize: CGFloat(fontSize!))
        }
    }

    var delegate2: MVTextFieldDelegate? = nil

    init(x: CGFloat, y: CGFloat, _ text: String, _ size: Double) {
        super.init(frame: NSRect(x: x, y: y, width: 3000, height: CGFloat(size) * 1.2))
        self.stringValue = text
        self.isEditable = true
        self.textColor = NSColor.white

        self.backgroundColor = NSColor.white.withAlphaComponent(0.1)
        self.font = NSFont.systemFont(ofSize: CGFloat(size))
        self.isBordered = true

        self.focusRingType = .none
        alignment = .center
        MVTextField.textField = self

        defer {
            fontSize = size
            let size: CGSize = stringValue.size(withAttributes: [NSFontAttributeName: NSFont.systemFont(ofSize: CGFloat(fontSize!))])
            frame.size.width = max(500.0, size.width * 1.1)
        }
    }

    var pointMouseDown: NSPoint = NSPoint.zero

    override func mouseDown(with event: NSEvent) {
        // dont call super mouseDown to make draggable
        pointMouseDown = event.locationInWindow
        currentEditor()?.selectedRange = NSRange(location: 0, length: 0)
        window?.makeFirstResponder(nil)
    }

    override func mouseUp(with event: NSEvent) {
        if pointMouseDown == event.locationInWindow {
            delegate2?.setSelected()
            currentEditor()?.selectedRange = NSRange(location: 0, length: 0)
            window?.makeFirstResponder(self)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setText(_ str: String) {
        stringValue = str
        let size: CGSize = stringValue.size(withAttributes: [NSFontAttributeName: NSFont.systemFont(ofSize: CGFloat(fontSize!))])
        frame.size.width = max(500.0, size.width * 1.1)
    }

    override func textDidChange(_ notification: Notification) {
        let size: CGSize = stringValue.size(withAttributes: [NSFontAttributeName: NSFont.systemFont(ofSize: CGFloat(fontSize!))])
        frame.size.width = max(500.0, size.width * 1.1)
        delegate2?.textDidChange(stringValue)
    }

    override func mouseDragged(with event: NSEvent) {
        delegate2?.dragged(event)
    }

    func changeFontSize(_ size: Double) {
        fontSize = size
        let size: CGSize = stringValue.size(withAttributes: [NSFontAttributeName: NSFont.systemFont(ofSize: CGFloat(fontSize!))])
        frame.size.width = max(500.0, size.width * 1.1)
        frame.size.height = CGFloat(fontSize!) * 1.2
    }
}

protocol MVTextFieldDelegate: ClickSelectable {
    func textDidChange(_ str: String)
    func dragged(_ event: NSEvent)
}
