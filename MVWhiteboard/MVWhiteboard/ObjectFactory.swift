//
//  ObjectFactory.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 05.07.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Foundation

class ObjectFactory {

    static func Image(_ eventProtoc: ImageViewEventProtocol, center: CGPoint, scale: Double = 1.0, rotation: Double = 0.0, name: String, url: String) -> InteractableObject {
        return Image4(eventProtoc, x: center.x, y: center.y, scale: scale, rot: rotation, name: name, url: url)
    }

    static func Text(_ eventProtoc: ImageViewEventProtocol,
         center: CGPoint,
         scale: Double = 1.0,
         rot: Double = 0.0,
         text: String,
         textType: TextType) -> InteractableObject {

        switch textType {
        case .dynamic:
            return DynamicText4(eventProtoc, x: Double(center.x), y: Double(center.y), scale: scale, rot: rot, text: text)
        case .label:
            return Text4(eventProtoc, x: Double(center.x), y: Double(center.y), scale: scale, rot: rot, text: text)
        case .rich:
            return RichText4(eventProtoc, x: Double(center.x), y: Double(center.y), scale: scale, rot: rot, text: NSMutableAttributedString(string: text))
        }
    }

    static func File(_ eventProtoc: ImageViewEventProtocol, center: CGPoint, scale: Double = 1.0, rot: Double = 0.0, name: String, url: String) -> InteractableObject {
        return File4(eventProtoc, x: center.x, y: center.y, scale: scale, rot: rot, name: name, url: url)
    }

    static func Blocade(_ eventProtoc: ImageViewEventProtocol, center: CGPoint, scale: Double = 1.0, rot: Double = 0.0) -> InteractableObject {
        return Blocade4(eventProtoc, x: center.x, y: center.y, scale: scale, rot: rot)
    }

    static func Marker(_ selectable: Selectable,_ draggable: Draggable, center: CGPoint, scale: Double = 1.0, rot: Double = 0.0) -> InteractableObject {
        return Marker4(selectable: selectable, draggable: draggable, x: center.x, y: center.y, scale: scale, rot: rot)
    }

    static func CMCMap(_ selectable: Selectable,_ draggable: Draggable, center: CGPoint, scale: Double = 1.0, rot: Double = 0.0) -> InteractableObject {
        return Marker4(selectable: selectable, draggable: draggable, x: center.x, y: center.y, scale: scale, rot: rot)
    }
}

enum TextType {
    case dynamic
    case label
    case rich
}
