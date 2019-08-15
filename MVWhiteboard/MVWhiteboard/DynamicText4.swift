import Foundation
import Cocoa
import JavaScriptCore

class DynamicText4: Text4 {

    var codeOutput: String = "" {
        didSet {
            _view.setText(codeOutput)
        }
    }

    override init(_ eventProtoc: ImageViewEventProtocol, x: Double, y: Double, scale: Double, rot: Double, text: String, size: Double = defaultSize) {
        super.init(eventProtoc, x: x, y: y, scale: scale, rot: rot, text: text)
        deselect()
    }

    override func setSelected() {
        super.setSelected()
        _view.setText(text)
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(ViewController.instance!,
                  x: aDecoder.decodeDouble(forKey: "x"),
                  y: aDecoder.decodeDouble(forKey: "y"),
                  scale: aDecoder.decodeDouble(forKey: "scale"),
                  rot: aDecoder.decodeDouble(forKey: "rot"),
                  text: aDecoder.decodeObject(forKey: "code") as! String,
                  size: aDecoder.decodeDouble(forKey: "size"))
    }

    override func encode(with aCoder: NSCoder) {
        aCoder.encode(x, forKey: "x")
        aCoder.encode(y, forKey: "y")
        aCoder.encode(scale, forKey: "scale")
        aCoder.encode(rotation, forKey: "rot")
        aCoder.encode(text, forKey: "code")
        aCoder.encode(size, forKey: "size")
    }
}

extension DynamicText4: Deselectable {

    func deselect() {
        codeOutput = JSContext()!.evaluateScript(text).toString()
    }

}
