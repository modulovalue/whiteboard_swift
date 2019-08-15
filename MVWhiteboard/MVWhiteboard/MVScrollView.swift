//
//  MVScrollView.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 30.06.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Cocoa

class MVScrollView: NSScrollView {
    var canvasObject: ScrollViewObject? = nil
}

class ScrollViewObject: InteractableObject, ScalarResizable {

    var scrollView: NSScrollView
    
    var contentView: MVContentView

    init(_ scrollView: NSScrollView, _ contentView: MVContentView, _ x: Double, _ y: Double, _ scale: Double, _ rot: Double) {
        self.scrollView = scrollView
        self.contentView = contentView
        super.init(x: x, y: y, scale: scale, rot: rot)
    }

    override func view() -> NSView {
        return NSView()
    }

    func resize(value: Double) {
         scrollView.setMagnification(CGFloat(value), centeredAt: contentView.getLastClickedPoint())
    }

    func maxValue() -> Double {
        return 0.6
    }

    func minValue() -> Double {
        return 0.03
    }

    func defaultValue() -> Double {
        return 1.0
    }

    func currentValue() -> Double {
        return Double(scrollView.magnification)
    }
}
