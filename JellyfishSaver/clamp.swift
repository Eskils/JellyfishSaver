//
//  clamp.swift
//  JellyfishSaver
//
//  Created by Eskil Gjerde Sviggum on 01/12/2023.
//

import Foundation

func clamp<T: Comparable>(_ x: T,_ minVal: T,_ maxVal: T) -> T {
    max(minVal, min(maxVal, x))
}
