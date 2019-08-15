//
//  MVObjects.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 09.07.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Foundation

class MVObjects: NSObject, NSCoding {

    var objects: [InteractableObject] = []

    override init() {
        super.init()
    }

    func addObj(_ obj: InteractableObject) {
        objects.append(obj)
    }

    func removeObj(_ obj: InteractableObject) {
        objects = objects.filter { $0 != obj }
    }

    required init(coder aDecoder: NSCoder) {
        objects = aDecoder.decodeObject(forKey: "objects") as! [InteractableObject]
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(objects, forKey: "objects")
    }
    
}
