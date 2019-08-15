//
//  Image3.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 01.07.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Foundation
import Cocoa

class Image4: InteractableObject, NSCoding, ScalarResizable, MVImageViewDelegate, Colorable, Deletable {

    var name: String

    var url: String
    
    private var _view: MVImageView

    private var imageViewEventProtocol: ImageViewEventProtocol? = nil

    var states = ["None", "Done", "Hard", "Look at it Again", "Skip for later"]

    var state: Int {
        didSet {
            updateState()
        }
    }

    init(_ eventProtoc: ImageViewEventProtocol, x: CGFloat, y: CGFloat, scale: Double, rot: Double, name: String, url: String) {
        self.name = name
        self.url = url
        var img: NSImage? = nil

        if FileManager.default.fileExists(atPath: eventProtoc.getFilePathRoot(fileName: url)) {
            img = NSImage(contentsOfFile: eventProtoc.getFilePathRoot(fileName: url))!
        } else {
            img = #imageLiteral(resourceName: "test")
        }

        _view = MVImageView(x: x, y: y, img!)
        state = 0
        super.init(x: Double(x), y: Double(y), scale: scale, rot: rot)
        _view.delegate2 = self
        _view.draggedEvent = { event in eventProtoc.dragged(imageView: self, event: event) }
        imageViewEventProtocol = eventProtoc

        updateState()
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
        self.state = aDecoder.decodeInteger(forKey: "state")
        updateState()
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(x, forKey: "x")
        aCoder.encode(y, forKey: "y")
        aCoder.encode(scale, forKey: "scale")
        aCoder.encode(rotation, forKey: "rot")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(state, forKey: "state")
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

    func resize(value: Double) {
        //TODO
    }

    func maxValue() -> Double {
        return 3
    }

    func defaultValue() -> Double {
        return 1.0
    }

    func minValue() -> Double {
        return 0.5
    }

    func currentValue() -> Double {
        // TODO
        return 1
    }

    func delete() -> Bool {
        do {
            try FileManager.default.removeItem(atPath: (imageViewEventProtocol?.getFilePathRoot(fileName: url))!)
            return true
        } catch {
            print(error)
            print("could not delete \(String(describing: imageViewEventProtocol?.getFilePathRoot(fileName: url)))")
        }
        return false
    }

    func nextState() {
        state = (state + 1) % states.count
    }

    func updateState() {
        switch state {
        case 0:
            _view.imageColor = nil
        case 1:
            _view.imageColor = NSColor.green.withAlphaComponent(0.2)
        case 2:
            _view.imageColor = NSColor.red.withAlphaComponent(0.2)
        case 3:
            _view.imageColor = NSColor.blue.withAlphaComponent(0.2)
        case 4:
            _view.imageColor = NSColor.yellow.withAlphaComponent(0.2)
        default:
            break
        }
        _view.setNeedsDisplay()
    }
}

