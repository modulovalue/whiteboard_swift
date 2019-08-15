//
//  File4.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 05.07.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Foundation
import Cocoa

class File4: InteractableObject, ObjectOpenable, NSCoding, ScalarResizable, MVImageViewDelegate {

    var name: String
    var url: String
    private var _view: MVImageView

    private var imageViewEventProtocol: ImageViewEventProtocol? = nil

    init(_ eventProtoc: ImageViewEventProtocol, x: CGFloat, y: CGFloat, scale: Double, rot: Double, name: String, url: String) {
        self.name = name
        self.url = url
        _view = MVImageView(x: x, y: y, #imageLiteral(resourceName: "flp2"), text: name)
        super.init(x: Double(x), y: Double(y), scale: scale, rot: rot)
        _view.delegate2 = self
        _view.draggedEvent = { event in eventProtoc.dragged(imageView: self, event: event) }
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
                  rot: aDecoder.decodeDouble(forKey: "rot"),
                  name: aDecoder.decodeObject(forKey: "name") as! String,
                  url: aDecoder.decodeObject(forKey: "url") as! String)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(x, forKey: "x")
        aCoder.encode(y, forKey: "y")
        aCoder.encode(scale, forKey: "scale")
        aCoder.encode(rotation, forKey: "rot")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(url, forKey: "url")
    }

    static func encode(obj: Image4, path: String) {
        NSKeyedArchiver.archiveRootObject(obj, toFile: path)
    }

    static func decode(path: String) -> Image4? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Image4
    }

    func mouseDownEvent(event: NSEvent) {
        imageViewEventProtocol?.setSelected(self)
    }

    func URLForOpen() -> String {
        return (imageViewEventProtocol?.getFilePathRoot(fileName: url))!
    }

    func resize(value: Double) {
        print("TODO RESIZE VALUE")
    }

    func maxValue() -> Double {
        return 2000.0
    }

    func defaultValue() -> Double {
        return 1000.0
    }

    func minValue() -> Double {
        return 100.0
    }

    func currentValue() -> Double {
        return 2000.0
    }
}

