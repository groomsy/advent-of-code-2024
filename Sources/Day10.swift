//
//  Day10.swift
//  AdventOfCode
//
//  Created by Todd Grooms on 12/12/24.
//

import Algorithms

struct Day10: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.map { Int(String($0))! }
    }
  }
  
  func part1() -> Any {
    let entities = entities
    
    for (y, row) in entities.enumerated() {
      for (x, value) in row.enumerated() {
        guard x == 0 else {
          continue
        }
        
        
      }
    }
    
    return entities.first?.reduce(0, +) ?? 0
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
    entities.map { $0.max() ?? 0 }.reduce(0, +)
  }
}
