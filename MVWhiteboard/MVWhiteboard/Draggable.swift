//
//  Draggable.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 18.07.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Foundation
import Cocoa
protocol Draggable {
    func dragged(event: NSEvent, newDeltaPos: (CGPoint) -> ())
}
