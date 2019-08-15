//
//  SequentiallyDeletable.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 18.07.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Foundation

protocol SequentiallyDeletable {
    func deleteFinally() -> Bool
    func deletable() -> Bool
}
