//
//  AppDelegate.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 30.06.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Cocoa
import CoreData

class MenuItemItem: NSMenuItem {

    var isActive: (() -> Bool)?

    var doThis: Selector?
    
    func update() {
        if (isActive != nil && doThis != nil && isActive!()) {
            action = doThis
        } else {
            action = nil
        }
    }
    
    func set(_ active: @escaping (() -> Bool), _ selector: Selector) {
        isActive = active
        doThis = selector
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBar = NSStatusBar.system()
    
    var statusBarItem : NSStatusItem = NSStatusItem()
    
    var menu: NSMenu = NSMenu()
    
    var menuItem : NSMenuItem = NSMenuItem()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupMenuBar()
        
        let p = acquirePrivileges()
        print("access " + String(p))

        NSEvent.addGlobalMonitorForEvents(matching: NSEventMask.keyDown, handler: {
            _ = self.handle(event: $0)
        })

        NSEvent.addLocalMonitorForEvents(matching: NSEventMask.keyDown, handler: {
            let returnVal = self.handle(event: $0)
            if returnVal {
                return nil
            } else {
                return $0
            }
        })
    }

    func handle(event: NSEvent) -> Bool {
        if event.modifierFlags.contains(.command) && event.modifierFlags.contains(.shift) {
            if event.keyCode == 50 {
                toggle()
                return true
            }
        }
        return false
    }

    func acquirePrivileges() -> Bool {
        let options : NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
        let accessibilityEnabled = AXIsProcessTrustedWithOptions(options)
        return accessibilityEnabled
    }

    func setupMenuBar() {
        statusBarItem = statusBar.statusItem(withLength: -1)
        statusBarItem.menu = menu
        statusBarItem.image = NSImage(named: "StatusBarButtonImage")
        statusBarItem.title = "MVWhiteboard"
        menu.addItem(NSMenuItem(title: "Toggle", action: #selector(toggle), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Settings", action: #selector(settings), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: ""))
    }

    @objc func toggle() {
        ViewController.instance?.window.toggle()
    }

    @objc func settings() {
        print("settings")
    }

    @objc func quitApp(sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }
    
    @IBOutlet weak var projectNew: MenuItemItem!
    @IBOutlet weak var projectOpen: MenuItemItem!
    @IBOutlet weak var projectSave: MenuItemItem!
    @IBOutlet weak var projectOnlyRemoveFromList: MenuItemItem!
    @IBOutlet weak var newLabelMenu: MenuItemItem!
    @IBOutlet weak var newDynamicTextMenu: MenuItemItem!
    @IBOutlet weak var newRichTextMenu: MenuItemItem!
    @IBOutlet weak var newBlocade: MenuItemItem!
    @IBOutlet weak var newMarker: MenuItemItem!
    @IBOutlet weak var selectionOpen: MenuItemItem!
    @IBOutlet weak var selectionMark: MenuItemItem!
    @IBOutlet weak var selectionRemove: MenuItemItem!
    @IBOutlet weak var windowShowObjectList: MenuItemItem!
    @IBOutlet weak var windowObjectPreferences: MenuItemItem!
    @IBOutlet weak var cmcMap: MenuItemItem!

    func updateMenu() {
        projectNew?.update()
        projectOpen?.update()
        projectSave?.update()
        projectOnlyRemoveFromList?.update()
        newLabelMenu?.update()
        newDynamicTextMenu?.update()
        newRichTextMenu?.update()
        newBlocade?.update()
        newMarker?.update()
        selectionOpen?.update()
        selectionMark?.update()
        selectionRemove?.update()
        windowShowObjectList?.update()
        windowObjectPreferences?.update()
        cmcMap?.update()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving and Undo support
    @IBAction func saveAction(_ sender: AnyObject?) {
        // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
        let context = persistentContainer.viewContext

        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
        }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Customize this code block to include application-specific recovery steps.
                let nserror = error as NSError
                NSApplication.shared().presentError(nserror)
            }
        }
    }

    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        return persistentContainer.viewContext.undoManager
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplicationTerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        let context = persistentContainer.viewContext

        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
            return .terminateCancel
        }

        if !context.hasChanges {
            return .terminateNow
        }

        do {
            try context.save()
        } catch {
            let nserror = error as NSError

            // Customize this code block to include application-specific recovery steps.
            let result = sender.presentError(nserror)

            if (result) {
                return .terminateCancel
            }

            let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
            let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
            let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButton(withTitle: quitButton)
            alert.addButton(withTitle: cancelButton)

            let answer = alert.runModal()
            if answer == NSAlertSecondButtonReturn {
                return .terminateCancel
            }
        }
        // If we got here, it is time to quit.
        return .terminateNow
    }

}

let appDelegate = NSApplication.shared().delegate as! AppDelegate

let context = (NSApplication.shared().delegate as! AppDelegate).persistentContainer.viewContext
