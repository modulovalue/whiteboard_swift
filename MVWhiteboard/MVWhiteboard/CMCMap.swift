import Foundation
import Cocoa
import JavaScriptCore

class CMCMap: InteractableObject, NSCoding {

    internal static var defaultSize: Double = 400.0

    internal var _view: NSView

    internal var imageViewEventProtocol: ImageViewEventProtocol? = nil

    init(_ eventProtoc: ImageViewEventProtocol, x: Double, y: Double, scale: Double, rot: Double) {
        _view = NSView()
        super.init(x: x, y: y, scale: scale, rot: rot)
        imageViewEventProtocol = eventProtoc
    }

    override func view() -> NSView {
        return _view
    }

    func dragged(_ event: NSEvent) {
        imageViewEventProtocol?.dragged(imageView: self, event: event)
    }

    func setSelected() {
        imageViewEventProtocol?.setSelected(self)
    }

    // NSCoding
    convenience required init(coder aDecoder: NSCoder) {
        self.init(ViewController.instance!,
                  x: aDecoder.decodeDouble(forKey: "x"),
                  y: aDecoder.decodeDouble(forKey: "y"),
                  scale: aDecoder.decodeDouble(forKey: "scale"),
                  rot: aDecoder.decodeDouble(forKey: "rot"))
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(x, forKey: "x")
        aCoder.encode(y, forKey: "y")
        aCoder.encode(scale, forKey: "scale")
        aCoder.encode(rotation, forKey: "rot")
        aCoder.encode(size, forKey: "size")
    }

}
