//
//  Day01.swift
//  AdventOfCode
//
//  Created by Todd Grooms on 12/1/24.
//

import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: (left: [Int], right: [Int]) {
    var left: [Int] = []
    var right: [Int] = []
    
    let lines = data.split(separator: "\n")
    for line in lines {
      let values = line.split(separator: "   ")
      guard let first = values.first,
            let last = values.last
      else {
        continue
      }
      
      if let leftValue = Int(first) {
        left.append(leftValue)
      }
      if let rightValue = Int(last) {
        right.append(rightValue)
      }
    }
    
    left.sort(by: <)
    right.sort(by: <)
    
    assert(left.count == right.count)
    
    return (left, right)
  }

  /// Calculate the sum of the distance of each row between the left and right columns
  /// of the entities.
  func part1() -> Any {
    var distanceSum: Int = 0
    
    let entities = self.entities
    let count = entities.left.count
    
    for i in 0..<count {
      let left = entities.left[i]
      let right = entities.right[i]
      
      distanceSum += abs(left - right)
    }
    
    return distanceSum
  }

  /// Calculate the sum of each row in the left column multiplied by its frequency in the
  /// right column.
  func part2() -> Any {
    var frequencyProductSum: Int = 0
    
    let entities = self.entities
    
    var frequencies: [Int:Int] = [:]
    for value in entities.right {
      guard let frequency = frequencies[value] else {
        frequencies[value] = 1
        continue
      }
      
      frequencies[value] = frequency + 1
    }

    for value in entities.left {
      guard let frequency = frequencies[value] else {
        continue
      }
      
      frequencyProductSum += value * frequency
    }
    
    return frequencyProductSum
  }
}
