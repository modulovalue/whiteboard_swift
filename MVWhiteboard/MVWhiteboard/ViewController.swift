//
//  ViewController.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 30.06.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Cocoa
import Foundation

class ViewController: NSViewController {

    static var instance: ViewController? = nil

    @IBOutlet weak var scrollView: MVScrollView!
    @IBOutlet weak var scrollContent: MVContentView!

    @IBOutlet weak var objectListTableViewView: NSScrollView!
    @IBOutlet weak var objectListTableViewContent: MVObjectTableListView!

    @IBOutlet weak var objectPrefsView: NSScrollView!
    @IBOutlet weak var objectPrefsContent: MVObjectPrefsTableListView!

    var currentProject: Project2? = nil
    var window: MVWindow!
    var windowController: WindowController!
    var objects: MVObjects = MVObjects()
    var didSet = false

    var currentSelectedObject: InteractableObject? = nil {
        willSet {
            if let obj = currentSelectedObject as? Deselectable {
                obj.deselect()
            }
        }
        didSet {
            windowController.updateUIToolbar(currentSelectedObject)
            appDelegate.updateMenu()
        }
    }

    override func viewDidAppear() {
        if !didSet {

            ViewController.instance = self

            self.window = (self.view.window as! MVWindow)
            self.window.setupSize()
            self.windowController = self.window.windowController as! WindowController
            self.windowController.toolbarProtocol = self
            self.windowController.setupMenu(ProjectManager.get())
            self.scrollContent.setupScrollView(self)
            self.scrollContent.contentViewDelegate = self
            self.scrollView.setMagnification(self.scrollView.minMagnification, centeredAt: NSPoint(x: 0, y: 0))
            self.scrollView.canvasObject = ScrollViewObject(scrollView, scrollContent, 0.0, 0.0, 1.0, 0.0)
            
            if !ProjectManager.get().isEmpty {
                self.currentProject = ProjectManager.get()[0]
            } else {
                self.handleNoProjects()
            }
            
            didSet = true

            currentSelectedObject = nil
            
            appDelegate.projectNew?.set({ true }, #selector(self.newProject))
            appDelegate.projectOpen?.set({ true }, #selector(self.openProject))
            appDelegate.projectSave?.set({ true }, #selector(self.saveProjectWithoutWarning))
            appDelegate.projectOnlyRemoveFromList?.set({ true }, #selector(self.removeProjectFromList))
            appDelegate.newLabelMenu?.set({ true }, #selector(self.newText))
            appDelegate.newDynamicTextMenu?.set({ true }, #selector(self.newDynamicText))
            appDelegate.newRichTextMenu?.set({ true }, #selector(self.newCodeView))
            appDelegate.newBlocade?.set({ true }, #selector(self.newBlocade))
            appDelegate.newMarker?.set({ true }, #selector(self.newMarker))
            appDelegate.selectionOpen?.set({ self.currentSelectedObject is ObjectOpenable }, #selector(self.openObject))
            appDelegate.selectionMark?.set({ self.currentSelectedObject is Colorable }, #selector(self.mark))
            appDelegate.selectionRemove?.set({ self.currentSelectedObject is Deletable }, #selector(self.removeObject))
            appDelegate.windowShowObjectList?.set({ true }, #selector(self.toogleContentObjectListVisibility))
            appDelegate.windowObjectPreferences?.set({ true }, #selector(self.toogleContentObjectPrefsVisibility))
            appDelegate.cmcMap?.set({ true }, #selector(self.addCMCMap))

            appDelegate.updateMenu()
        }
    }

    func handleNoProjects() {
        print("no projects available")
    }

    func handleProjectCouldNotBeFoundDuringLoadingOrSaving() {
        print("project could not be foundd")
    }

    @objc func saveProjectWithoutWarning() {
        saveProject(true)
    }

    // MARK: TODO CHECK IF project EXISTS
    func saveProject(_ withoutWarning: Bool = false) {
        if objects.objects.count == 0 {
            dialogOKCancel(question: "Not saving", text: "0 Objects found, may be a bug")
        } else {
            if withoutWarning || dialogYesNo(question: "Save Project", text: "do you want to save?") {
                let path = "\(currentProject!.url!)/data.white"
                NSKeyedArchiver.archiveRootObject(objects, toFile: path)
                print("Project saved")
            }
        }
    }

    // MARK: TODO CHECK IF project EXISTS
    func loadProject() {
        let path = "\(currentProject!.url!)/data.white"
        let objs = (NSKeyedUnarchiver.unarchiveObject(withFile: path) as? MVObjects)!
        scrollContent.subviews.removeAll()
        objects = objs
        objects.objects.forEach {
            self.scrollContent.addSubview($0.view())
        }
        print("Project loaded")
    }

    func addObject(_ obj: InteractableObject) {
        objects.addObj(obj)
        scrollContent.addSubview(obj.view())
    }

}

extension ViewController: ToolbarProtocol {

    @objc func mark() {
        (currentSelectedObject as? Colorable)?.nextState()
    }

    @objc func openObject() {
        func shell(_ command: String) -> Int32 {
            let task = Process()
            task.launchPath = "/usr/bin/env"
            task.arguments = ["bash", "-c", command]
            task.launch()
            task.waitUntilExit()
            return task.terminationStatus
        }

        if let file = currentSelectedObject as? ObjectOpenable {
            _ = shell("open \(file.URLForOpen())")
        }
    }

    @objc func removeObject() {
        window.yesNoDialog("Are you sure", "Do you want to delete this object?") {
            if ((self.currentSelectedObject as? Deletable)?.delete())! {
                self.objects.removeObj(self.currentSelectedObject!)
                self.currentSelectedObject?.view().removeFromSuperview()
                self.saveProject(true)
                self.currentSelectedObject = nil
            } else {
                self.window.yesNoDialog("Delete failed", "File not found, delete Object completely?") {
                    self.objects.removeObj(self.currentSelectedObject!)
                    self.currentSelectedObject?.view().removeFromSuperview()
                    self.saveProject(true)
                    self.currentSelectedObject = nil
                }
            }
        }
    }

    @objc func toogleContentObjectListVisibility() {
        objectListTableViewView.isHidden = !objectListTableViewView.isHidden
    }

    @objc func toogleContentObjectPrefsVisibility() {
        objectPrefsView.isHidden = !objectPrefsView.isHidden
    }

    func testDoSomething() {
        saveProject()
    }

    func testDoSomething2() {
//        loadProject()
//        window.yesNoDialog("Are you sure you want to remove all images", "Do you want to delete all images?") {
//            self.objects.objects.forEach {
//                if let obj = $0 as? Image4 {
//                    if (obj.delete()) {
//                        self.objects.removeObj(obj)
//                        obj.view().removeFromSuperview()
//                    }
//                }
//            }
//            self.currentSelectedObject = nil
//            self.saveProject(true)
//        }
    }

    func valueChanged(_ value: Double) {
        NSHapticFeedbackManager.defaultPerformer().perform(NSHapticFeedbackPattern.levelChange, performanceTime: NSHapticFeedbackPerformanceTime.now)
        if let selectedResizable = currentSelectedObject as? ScalarResizable {
            selectedResizable.resize(value: value)
        }
    }

    @objc func removeProjectFromList() {
        window.yesNoDialog("Are you sure", "Do you want to remove this project from the list?") {
            context.delete(self.currentProject!)
            appDelegate.saveAction(nil)
            self.windowController.removeProject(self.currentProject!)
            if !ProjectManager.get().isEmpty {
                self.currentProject = ProjectManager.get()[0]
            } else {
                self.handleNoProjects()
            }
        }
    }

    func selected(_ project: Project2) {
        if currentProject != nil {
            saveProject()
        }
        currentProject = project
        loadProject()
    }

    @objc func newProject() {
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        if savePanel.runModal() == NSModalResponseOK {

            let name = "\(savePanel.url!.lastPathComponent)"
            let url = savePanel.url!.path+".white"

            if FileManager.default.fileExists(atPath: url) {
               _ = dialogOKCancel(question: "Directory already exists", text: "Please choose a different name")
            } else {
                do {
                    print(url)
                    try FileManager.default.createDirectory(atPath: url, withIntermediateDirectories: true, attributes: nil)
                    try FileManager.default.createDirectory(atPath: url+"/files", withIntermediateDirectories: true, attributes: nil)
                    let p = Project2(context: context)
                    p.name = name
                    p.url = url
                    appDelegate.saveAction(nil)
                    windowController.newProject(p)

                    let path = "\(url)/data.white"
                    NSKeyedArchiver.archiveRootObject(MVObjects(), toFile: path)
                    print("Project created at \(path)")
                } catch {
                    print(error)
                }
            }
        }
    }

    @objc func openProject() {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = false
        if openPanel.runModal() == NSModalResponseOK {
            let name = "\(openPanel.url!.lastPathComponent)"
            let url = openPanel.url!.path
            let p = Project2(context: context)
            p.name = name
            p.url = url
            appDelegate.saveAction(nil)
            windowController.newProject(p)
        }
    }

    @objc func newText() {
        addObject(ObjectFactory.Text(self, center: scrollContent.getLastClickedPoint(), text: "Label Me", textType: .label))
    }

    @objc func newCodeView() {
        addObject(ObjectFactory.Text(self, center: scrollContent.getLastClickedPoint(), text: "Paste text Here", textType: .rich))
    }

    @objc func newDynamicText() {
        addObject(ObjectFactory.Text(self, center: scrollContent.getLastClickedPoint(), text: "2+2+3+4", textType: .dynamic))
    }

    @objc func newBlocade() {
        addObject(ObjectFactory.Blocade(self, center: scrollContent.getLastClickedPoint()))
    }

    @objc func newMarker() {
        addObject(ObjectFactory.Marker(self, self, center: scrollContent.getLastClickedPoint()))
    }

    @objc func addCMCMap() {
        addObject(ObjectFactory.Text(self, center: scrollContent.getLastClickedPoint(), text: "Paste text Here", textType: .rich))
    }
    
    func showMarkings(display: Bool) {
        objects.objects.forEach {
            if let obj = $0 as? Hideable {
                obj.hide(hide: !display)
            }
        }
    }

    func newMarkerNode() {
        if let obj = currentSelectedObject as? NewAddable {
            obj.addNew(at: scrollContent.getLastClickedPoint(), radius: Marker4.defaultRadius)
        }
    }

    func markerConnectionMode(on: Bool) {
        if let obj = currentSelectedObject as? Connectable {
            obj.connectMode(isActive: on)
        }
    }

}

extension ViewController: DragAndDropProtocol, Selectable, Draggable, ImageViewEventProtocol, ContentViewDelegate {

    // DragAndDropProtocol
    // MARK: TODO check if project exists
    func processImage(_ imageUrl: URL, center: NSPoint) {
        print(imageUrl.path, center)

        let newName = UUID().uuidString + "." + imageUrl.pathExtension
        let oldName = imageUrl.lastPathComponent

        if currentProject != nil {
            do {
                try FileManager.default.moveItem(atPath: imageUrl.path, toPath: "\(currentProject!.url!)/files/\(newName)")
                addObject(ObjectFactory.Image(self, center: center, name: oldName, url: newName))
                saveProject(true)
            } catch {
                print("could not move image \(error)")
            }
        }
    }

    func processFLP(_ imageUrl: URL, center: NSPoint) {
        let newName = UUID().uuidString + "." + imageUrl.pathExtension
        let oldName = imageUrl.lastPathComponent

        if currentProject != nil {
            do {
                try FileManager.default.moveItem(atPath: imageUrl.path, toPath: "\(currentProject!.url!)/files/\(newName)")
                addObject(ObjectFactory.File(self, center: center, name: oldName, url: newName))
                saveProject(true)
            } catch {
                print("could not move image \(error)")
            }
        }
    }
    // -----

    // Draggable
    func dragged(event: NSEvent, newDeltaPos: (CGPoint) -> ()) {
        let newP = CGPoint(x: Double(event.deltaX) / Double(scrollView.magnification),
                           y: -(Double(event.deltaY) / Double(scrollView.magnification)))
        newDeltaPos(newP)
    }

    // ImageViewEventProtocol // Selectable ALSO setSelected from Selectable
    func dragged(imageView: InteractableObject, event: NSEvent) {
        imageView.x += Double(event.deltaX) / Double(scrollView.magnification)
        imageView.y -= Double(event.deltaY) / Double(scrollView.magnification)
    }

    func setSelected(_ obj: InteractableObject) {
        currentSelectedObject = obj
    }

        // TODO check if proejct exists
    func getFilePathRoot(fileName: String) -> String {
        return "\(currentProject!.url!)/files/\(fileName)"
    }
    // -----

    // ContentViewDelegate
    func clicked() {
        print("ok")
        MVTextField.textField?.window?.makeFirstResponder(nil)
        MVTextView.textView = nil
        currentSelectedObject = scrollView.canvasObject
    }
    // ----
}
