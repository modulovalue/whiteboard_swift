//
//  AlertExtensions.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 30.06.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Foundation
import Cocoa

extension NSWindow {
    func yesNoDialog(_ message: String, _ text: String, _ success: @escaping () -> Void) {
        let alert = NSAlert()
        alert.messageText = message
        alert.addButton(withTitle: "Yes")
        alert.addButton(withTitle: "No")
        alert.informativeText = text
        alert.beginSheetModal(for: self, completionHandler: { (returnCode) -> Void in
            if returnCode == NSAlertFirstButtonReturn {
                success()
            }
        })
    }
}

func alertDialog(_ title: String, _ message: String) {
    let alert = NSAlert()
    alert.messageText = message
    alert.informativeText = title
    alert.alertStyle = NSAlertStyle.warning
    alert.addButton(withTitle: "Ok")
    alert.runModal()
}


func dialogOKCancel(question: String, text: String) {
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = NSAlertStyle.warning
    alert.addButton(withTitle: "OK")
    alert.runModal()
}

func dialogYesNo(question: String, text: String) -> Bool {
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = NSAlertStyle.warning
    alert.addButton(withTitle: "Yes")
    alert.addButton(withTitle: "No")
    return alert.runModal() == NSAlertFirstButtonReturn
}
