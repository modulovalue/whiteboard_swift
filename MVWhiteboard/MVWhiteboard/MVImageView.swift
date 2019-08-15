//
//  MVImageView.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 30.06.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Cocoa
import QuartzCore

class MVImageView: NSImageView {

    internal var draggedEvent: ((NSEvent) -> Void)? = nil

    internal var delegate2: MVImageViewDelegate? = nil

    var imageColor: NSColor? = nil

    override func awakeFromNib() {
        self.wantsLayer = true;
    }

    init(x: CGFloat, y: CGFloat, _ image: NSImage, text: String? = nil) {
        super.init(frame: NSRect(x: x, y: y, width: image.size.width, height: image.size.height))
        self.image = image
        if text != nil {
            imageScaling = NSImageScaling.scaleNone
            frame.size.height += 200
            frame.size.width += 300
            let text = MVTextField(x: 0, y: 0, text!, 100)
            text.backgroundColor = NSColor.clear
            addSubview(text)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        self.layer?.sublayers?.forEach({ $0.removeFromSuperlayer() })
        self.drawEverything()
    }

    override func mouseDragged(with event: NSEvent) {
        draggedEvent?(event)
    }

    override func mouseDown(with event: NSEvent) {
        delegate2?.mouseDownEvent(event: event)
    }

    func drawEverything() {
        var startFrame = CGRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
        let aLayer = CALayer()
        aLayer.frame = startFrame
        aLayer.contents = image?.cgImage(forProposedRect: &startFrame, context: nil, hints: nil)
        self.layer?.addSublayer(aLayer)

        if imageColor != nil {
            let shape = CAShapeLayer()
            shape.backgroundColor = imageColor?.cgColor.copy(alpha: 0.35)
            shape.frame = startFrame
            self.layer?.addSublayer(shape)
        }
    }

}

protocol MVImageViewDelegate {
    func mouseDownEvent(event: NSEvent)
}

extension NSView {
    var backgroundColorr: NSColor? {
        get {
            if let colorRef = self.layer?.backgroundColor {
                return NSColor(cgColor: colorRef)
            } else {
                return nil
            }
        }
        set {
            self.wantsLayer = true
            self.layer?.backgroundColor = newValue?.cgColor
        }
    }
}
