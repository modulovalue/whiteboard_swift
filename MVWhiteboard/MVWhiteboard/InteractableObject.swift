//
//  InteractableObject.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 02.07.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Foundation
import Cocoa

class InteractableObject: NSObject, InteractableObjectProtocol {

    var x: Double {
        didSet {
            view().frame.origin.x = x.cg
        }
    }

    var y: Double {
        didSet {
            view().frame.origin.y = y.cg
        }
    }

    var scale: Double {
        didSet {
            print("TODO scale \(scale)")
        }
    }

    var rotation: Double {
        didSet {
            view().frameRotation = CGFloat(rotation)
        }
    }

    init(x: Double, y: Double, scale: Double, rot: Double) {
        self.x = x
        self.y = y
        self.scale = scale
        self.rotation = rot
        super.init()
        defer {
            self.x = x
            self.y = y
            self.scale = scale
            self.rotation = rot
        }
    }

    func view() -> NSView {
        fatalError("needs to be overidden by subclass")
    }

}

extension Double {
    var cg: CGFloat {
        return CGFloat(self)
    }
}
