import Foundation
import Cocoa
import JavaScriptCore

class Text4: InteractableObject, NSCoding, MVTextFieldDelegate {

    var text: String

    var size: Double {
        didSet {
            _view.changeFontSize(size)
        }
    }

    internal static var defaultSize: Double = 400.0

    internal var _view: MVTextField

    internal var imageViewEventProtocol: ImageViewEventProtocol? = nil

    init(_ eventProtoc: ImageViewEventProtocol, x: Double, y: Double, scale: Double, rot: Double, text: String, size: Double = defaultSize) {
        self.text = text
        self.size = size
        _view = MVTextField(x: x.cg, y: y.cg, text, size)
        super.init(x: x, y: y, scale: scale, rot: rot)
        _view.delegate2 = self
        imageViewEventProtocol = eventProtoc
    }

    override func view() -> NSView {
        return _view
    }

    // MVTextFieldDelegate
    func textDidChange(_ str: String) {
        text = str
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
                  rot: aDecoder.decodeDouble(forKey: "rot"),
                  text: aDecoder.decodeObject(forKey: "text") as! String,
                  size: aDecoder.decodeDouble(forKey: "size"))
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(x, forKey: "x")
        aCoder.encode(y, forKey: "y")
        aCoder.encode(scale, forKey: "scale")
        aCoder.encode(rotation, forKey: "rot")
        aCoder.encode(text, forKey: "text")
        aCoder.encode(size, forKey: "size")
    }

}

extension Text4: ScalarResizable {

    func resize(value: Double) {
        size = value
    }

    func maxValue() -> Double {
        return 1600.0
    }

    func defaultValue() -> Double {
        return Text4.defaultSize
    }

    func minValue() -> Double {
        return 30.0
    }

    func currentValue() -> Double {
        return size
    }

}

extension Text4: Deletable {
    
    func delete() -> Bool {
        return true
    }

}
