//
//  ImageViewEventProtocol.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 01.07.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Foundation
import Cocoa

protocol ImageViewEventProtocol {
    func dragged(imageView: InteractableObject, event: NSEvent)
    func setSelected(_ obj: InteractableObject)
    func getFilePathRoot(fileName: String) -> String
}
