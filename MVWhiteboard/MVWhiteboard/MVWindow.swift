//
//  MVWindow.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 30.06.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Cocoa

class MVWindow: NSWindow, NSWindowDelegate {

    var isShowing = true
    var setupDone: Bool = false
    
    func setupSize() {
        //titleVisibility = .hidden
        //titlebarAppearsTransparent = true
        level = Int(CGWindowLevelForKey(.floatingWindow))
        //level = Int(CGWindowLevelForKey(.maximumWindow))
        var windowFrame = frame
        windowFrame.origin.x = 0
        windowFrame.size = NSMakeSize(NSScreen.main()!.frame.width * 0.3, NSScreen.main()!.frame.height)
        setFrame(windowFrame, display: true)
        setupDone = true
        hide()
    }

    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        if setupDone {
            return NSSize(width: frameSize.width, height: NSScreen.main()!.frame.height)
        } else {
            return NSSize(width: NSScreen.main()!.frame.width * 0.5, height: NSScreen.main()!.frame.height)
        }
    }

    func hide() {
        orderOut(self)
        isShowing = false
    }

    func show() {
        makeKeyAndOrderFront(self)
        isShowing = true
    }

    func toggle() {
        if isShowing {
            hide()
        } else {
            show()
        }
    }
    
}
