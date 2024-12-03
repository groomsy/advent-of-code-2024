//
//  Day03.swift
//  AdventOfCode
//
//  Created by Todd Grooms on 12/3/24.
//

import Algorithms

struct Multiply {
  let left: Int
  let right: Int
  
  let product: Int
  
  init(_ left: Int, _ right: Int) {
    self.left = left
    self.right = right
    self.product = left * right
  }
}

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  /// Splits input data into an array of multiplication commands.
  var entitiesPart1: [Multiply] {
    let commandPattern = /mul\((\d+),(\d+)\)/
    guard data.contains(commandPattern) else {
      print("Unable to find pattern.")
      return []
    }
    
    let commandMatches = data.matches(of: commandPattern)
    return commandMatches.compactMap {
      guard let left = Int($0.1), let right = Int($0.2) else {
        return nil
      }
      return Multiply(left, right)
    }
  }
  
  /// Splits input data into an array of multiplication commands, respecting `do`
  /// and `don't` commands).
  var entitiesPart2: [Multiply] {
    let doCommand = "do()"
    let dontCommand = "don't()"
    
    let commandPattern = /mul\((\d+),(\d+)\)|don't\(\)|do\(\)/
    guard data.contains(commandPattern) else {
      print("Unable to find pattern.")
      return []
    }
    
    var doEnabled = true
    
    let commandMatches = data.matches(of: commandPattern)
    return commandMatches.compactMap {
      if $0.0 == doCommand {
        doEnabled = true
        return nil
      } else if $0.0 == dontCommand {
        doEnabled = false
        return nil
      } else if let left = $0.1, let right = $0.2, doEnabled {
        return Multiply(Int(left)!, Int(right)!)
      } else {
        return nil
      }
    }
  }

  /// Sum product of all multiply commands for `entitiesPart1`.
  func part1() -> Any {
    entitiesPart1.reduce(into: 0) { partialResult, multiplyCommand in
      partialResult += multiplyCommand.product
    }
  }

  /// Sum product of all multiply commands for `entitiesPart2`.
  func part2() -> Any {
    entitiesPart2.reduce(into: 0) { partialResult, multiplyCommand in
      partialResult += multiplyCommand.product
    }
  }
}
