//
//  ProjectManager.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 01.07.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Foundation
import Cocoa

class ProjectManager {

    private static var data = [Project2]()

    static func get() -> [Project2] {
        do {
            data.removeAll()
            let tempAllProjects = try context.fetch(Project2.fetchRequest()) as [Project2]
            tempAllProjects.forEach {project in
                if FileManager.default.fileExists(atPath: project.url!) {
                    data.append(project)
                }
            }
        } catch {
            print("could not load data")
        }
        return data
    }

    static func toString() -> String {
        var str = ""
        get().forEach {
            str.append("name : \(String(describing: $0.name)) and url: \(String(describing: $0.url)) ")
        }
        return str
    }

}

class Project: NSObject, NSCoding {

    let name : String

    let url : String

    init(name: String, url: String){
        self.name = name
        self.url = url
    }
    
    func getName() -> String {
        return name
    }

    func getURL() -> String{
        return url
    }

    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.url = aDecoder.decodeObject(forKey: "url") as! String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.url, forKey: "url")
    }
    
}
