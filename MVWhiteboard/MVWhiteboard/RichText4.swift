import Foundation
import Cocoa

class RichText4: InteractableObject, NSCoding, MVTextViewDelegate, Deletable {

    var text: NSAttributedString

    private var _view: MVTextView

    private var imageViewEventProtocol: ImageViewEventProtocol? = nil

    init(_ eventProtoc: ImageViewEventProtocol, x: Double, y: Double, scale: Double, rot: Double, text: NSAttributedString) {
        self.text = text
        _view = MVTextView(frame: NSRect(x: x, y: y, width: 2400.0, height: 300.0))
        _view.setup(x: x.cg, y: y.cg, width: 2400.0, text: text)
        super.init(x: x, y: y, scale: scale, rot: rot)
        _view.delegate2 = self
        imageViewEventProtocol = eventProtoc
    }

    func textDidChange(_ str: NSAttributedString) {
        text = str
    }
    
    func setSelected() {
        imageViewEventProtocol?.setSelected(self)
    }

    func dragged(_ event: NSEvent) {
        imageViewEventProtocol?.dragged(imageView: self, event: event)
    }

    override func view() -> NSView {
        return _view
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(ViewController.instance!,
                  x: aDecoder.decodeDouble(forKey: "x"),
                  y: aDecoder.decodeDouble(forKey: "y"),
                  scale: aDecoder.decodeDouble(forKey: "scale"),
                  rot: aDecoder.decodeDouble(forKey: "rot"),
                  text: aDecoder.decodeObject(forKey: "text") as! NSAttributedString)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(x, forKey: "x")
        aCoder.encode(y, forKey: "y")
        aCoder.encode(scale, forKey: "scale")
        aCoder.encode(rotation, forKey: "rot")
        aCoder.encode(text, forKey: "text")
    }

    func delete() -> Bool {
        return true
    }
}
