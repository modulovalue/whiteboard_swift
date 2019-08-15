//
//  ContentView.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 30.06.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Foundation
import Cocoa

class MVContentView: NSView {

    var dragAndDropDelegate: DragAndDropProtocol?
    var isReceivingDrag = false { didSet { needsDisplay = true } }
    var acceptableTypes: Set<String> { return [NSURLPboardType] }
    var contentViewDelegate: ContentViewDelegate? = nil
    var lastClickedPosition: NSPoint? = nil

    func setupScrollView( _ protoc: DragAndDropProtocol, width: CGFloat = 80000, height: CGFloat = 80000) {
        frame.size = NSSize(width: width, height: height)
        dragAndDropDelegate = protoc
        register(forDraggedTypes: Array(acceptableTypes))
    }

    override func mouseDown(with event: NSEvent) {
        lastClickedPosition = convert(event.locationInWindow, from: nil)
        contentViewDelegate?.clicked()
        NotificationCenter.default.post(name: .didTouchContentView, object: nil)
    }

    func getLastClickedPoint() -> NSPoint {
        var at = lastClickedPosition
        if at == nil {
            at = NSPoint(x: frame.width / 2, y: frame.height / 2 )
        }
        return at!
    }

}

// drag and drop handling stuff
extension MVContentView {

    func shouldAllowDrag(_ draggingInfo: NSDraggingInfo) -> Bool {
        let pasteBoard = draggingInfo.draggingPasteboard()
        if let urls = pasteBoard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL], urls.count > 0 {
            return checkForEndings(urls: urls, endings: ["jpg", "png", "jpeg", "gif", "flp"])
        }
        return false
    }

    func checkForEndings(urls: [URL], endings: [String]) -> Bool {
        var firstEnding: String? = nil
        for url in urls {
            let ending = url.pathExtension.lowercased()
            if firstEnding == nil {
                if endings.contains(ending) {
                    firstEnding = ending
                } else {
                    return false
                }
            }
            if ending != firstEnding {
                return false
            }
        }
        return true
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        isReceivingDrag = shouldAllowDrag(sender)
        return isReceivingDrag ? .copy : NSDragOperation()
    }

    override func draggingExited(_ sender: NSDraggingInfo?) {
        isReceivingDrag = false
    }

    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return shouldAllowDrag(sender)
    }

    override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {
        isReceivingDrag = false
        let pasteBoard = draggingInfo.draggingPasteboard()
        let point = convert(draggingInfo.draggingLocation(), from: nil)
        if let urls = pasteBoard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL], urls.count > 0 {
            if checkForEndings(urls: urls, endings: ["jpg", "png", "jpeg", "gif"]) {
                urls.forEach {
                    dragAndDropDelegate!.processImage($0, center: point)
                }
                return true
            } else if checkForEndings(urls: urls, endings: ["flp"]) {
                urls.forEach {
                    dragAndDropDelegate!.processFLP($0, center: point)
                }
                return true
            }
        }
        return false
    }

}

protocol ContentViewDelegate {
    func clicked()
}
