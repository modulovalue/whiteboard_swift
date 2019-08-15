//
//  DragAndDropProtocol.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 01.07.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Foundation

protocol DragAndDropProtocol {
    func processImage(_ imageUrl: URL, center: NSPoint)
    func processFLP(_ imageUrl: URL, center: NSPoint)
}
