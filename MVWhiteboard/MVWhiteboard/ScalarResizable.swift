//
//  ScalarResizable.swift
//  MVWhiteboard
//
//  Created by Modestas Valauskas on 08.07.17.
//  Copyright © 2017 MV. All rights reserved.
//

import Foundation

protocol ScalarResizable {
    func resize(value: Double)
    func maxValue() -> Double
    func minValue() -> Double
    func defaultValue() -> Double
    func currentValue() -> Double
}
