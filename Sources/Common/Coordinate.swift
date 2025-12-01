//
//  Coordinate.swift
//  AdventOfCode
//
//  Created by Todd Grooms on 12/9/24.
//

import Foundation

struct Coordinate: Equatable, Hashable, CustomStringConvertible {
  let x: Int
  let y: Int
  
  var description: String {
    "(\(x), \(y))"
  }
}
