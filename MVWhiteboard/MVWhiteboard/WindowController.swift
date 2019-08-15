import Cocoa

class WindowController: NSWindowController, NSToolbarDelegate {

    @IBOutlet weak var toolbar: MVToolbar!

    @IBOutlet weak var projectsMenu: NSMenu!

    @IBOutlet weak var sizeSlider: NSSlider!

    @IBOutlet weak var openButton: NSButton!

    @IBOutlet weak var markButton: NSButton!

    @IBOutlet weak var resizePushButton: NSToolbarItem!

    var toolbarProtocol: ToolbarProtocol?

    var selectedProject: Project2? = nil

    override func windowDidLoad() {
        super.windowDidLoad()
    }

    func setupMenu(_ projects: [Project2]) {
        projectsMenu.removeAllItems()
        projects.forEach {
            newProject($0)
        }
        if !projects.isEmpty {
            projectsMenu.performActionForItem(at: 0)
        }
    }

    func newProject(_ project: Project2) {
        let menuItem = NSMenuItem(title: project.name!, action: #selector(projectSelected(_:)), keyEquivalent: "")
        menuItem.representedObject = project
        projectsMenu.addItem(menuItem)
    }

    @objc func projectSelected(_ menuItem: NSMenuItem) {
        selectProject(menuItem.representedObject as! Project2)
    }

    func selectProject(_ project: Project2) {
        selectedProject = project
        toolbarProtocol?.selected(project)
    }

    func removeProject(_ project: Project2) {
        let index = findProject(project)
        if project === selectedProject {
            projectsMenu.performActionForItem(at: 0)
        }
        projectsMenu.removeItem(at: index)
    }

    func findProject(_ project: Project2) -> Int {
        for value in projectsMenu.items.enumerated() {
            if (value.element.representedObject as! Project2) === project {
                return value.offset
            }
        }
        fatalError("Project not in list")
    }

    func updateUIToolbar(_ object: InteractableObject?) {

        if let obj = object as? ScalarResizable {
            sizeSlider.maxValue = obj.maxValue()
            sizeSlider.minValue = obj.minValue()
            sizeSlider.doubleValue = obj.currentValue()
        }

        toolbar.open = (object is ObjectOpenable)
        toolbar.mark = (object is Colorable)
        toolbar.remove = (object is Deletable)
        toolbar.resize = (object is ScalarResizable)
        toolbar.newMarking = (object is NewAddable)
        toolbar.connectable = (object is Connectable)

        toolbar.update()
        
    }

    @IBAction func pushAcceleratorAction(_ sender: NSButton) {
        if sender.doubleValue >= 1 && sender.doubleValue <= 2 {
            let value = ((sizeSlider.maxValue - sizeSlider.minValue) * (sender.doubleValue - 1.0)) + sizeSlider.minValue
            toolbarProtocol?.valueChanged(value)
        }
    }

    @IBAction func sizeSliderValueChangedAction(_ sender: NSSlider) {
        toolbarProtocol?.valueChanged(sender.doubleValue)
    }

    @IBAction func removeAction(_ sender: Any) {
        toolbarProtocol?.removeObject()
    }

    @IBAction func openAction(_ sender: Any) {
        toolbarProtocol?.openObject()
    }

    @IBAction func markAction(_ sender: Any) {
        toolbarProtocol?.mark()
    }
    
    @IBAction func stateChangeShowMarks(_ sender: NSButton) {
        toolbarProtocol?.showMarkings(display: sender.state == 1 ? true : false)
    }

    @IBAction func newMarkingNodeAction(_ sender: Any) {
        toolbarProtocol?.newMarkerNode()
    }

    @IBAction func markingConnectionModeAction(_ sender: NSButton) {
        toolbarProtocol?.markerConnectionMode(on: sender.state == 1 ? true : false)
    }

}

protocol ToolbarProtocol {
    func selected(_ project: Project2)
    func valueChanged(_ value: Double)
    func removeObject()
    func openObject()
    func mark()
    func showMarkings(display: Bool)
    func newMarkerNode()
    func markerConnectionMode(on: Bool)
}
