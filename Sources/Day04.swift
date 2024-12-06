//
//  Day04.swift
//  AdventOfCode
//
//  Created by Todd Grooms on 12/4/24.
//

import Algorithms

extension Array where Element == [Character] {
  func isCharacter(
    _ character: Character,
    atRowIndex rowIndex: Int,
    columnIndex: Int
  ) -> Bool {
    guard rowIndex >= 0, rowIndex < count else {
      return false
    }
    
    let row = self[rowIndex]
    guard columnIndex >= 0, columnIndex < row.count else {
      return false
    }
    
    return row[columnIndex] == character
  }
}

struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Character]] {
    data.split(separator: "\n").map {
      Array($0)
    }
  }
  
  struct DirectionOptions: OptionSet {
    let rawValue: Int
    
    static let north = DirectionOptions(rawValue: 1 << 0)
    static let northEast = DirectionOptions(rawValue: 1 << 1)
    static let east = DirectionOptions(rawValue: 1 << 2)
    static let southEast = DirectionOptions(rawValue: 1 << 3)
    static let south = DirectionOptions(rawValue: 1 << 4)
    static let southWest = DirectionOptions(rawValue: 1 << 5)
    static let west = DirectionOptions(rawValue: 1 << 6)
    static let northWest = DirectionOptions(rawValue: 1 << 7)
    
    static let all: DirectionOptions = [
      .north,
      .northEast,
      .east,
      .southEast,
      .south,
      .southWest,
      .west,
      .northWest
    ]
  }
  
  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var xmasCount = 0
    
    let mas = Array("MAS")
    
    let rowCount = entities.count
    for rowIndex in 0..<rowCount {
      let columnCount = entities[rowIndex].count
      for columnIndex in 0..<columnCount {
        let isX = entities.isCharacter("X", atRowIndex: rowIndex, columnIndex: columnIndex)
        guard isX else {
          continue
        }
        
        var exists: DirectionOptions = .all
        
        for (index, char) in mas.enumerated() {
          if exists.contains(.north) {
            let existsNorth = entities.isCharacter(
              char,
              atRowIndex: rowIndex - (index + 1),
              columnIndex: columnIndex
            )
            if !existsNorth {
              exists.remove(.north)
            }
          }
          
          if exists.contains(.northEast) {
            let existsNorthEast = entities.isCharacter(
              char,
              atRowIndex: rowIndex - (index + 1),
              columnIndex: columnIndex + (index + 1)
            )
            if !existsNorthEast {
              exists.remove(.northEast)
            }
          }
          
          if exists.contains(.east) {
            let existsEast = entities.isCharacter(
              char,
              atRowIndex: rowIndex,
              columnIndex: columnIndex + (index + 1)
            )
            if !existsEast {
              exists.remove(.east)
            }
          }
          
          if exists.contains(.southEast) {
            let existsSouthEast = entities.isCharacter(
              char,
              atRowIndex: rowIndex + (index + 1),
              columnIndex: columnIndex + (index + 1)
            )
            if !existsSouthEast {
              exists.remove(.southEast)
            }
          }
          
          if exists.contains(.south) {
            let existsSouth = entities.isCharacter(
              char,
              atRowIndex: rowIndex + (index + 1),
              columnIndex: columnIndex
            )
            if !existsSouth {
              exists.remove(.south)
            }
          }
          
          if exists.contains(.southWest) {
            let existsSouthWest = entities.isCharacter(
              char,
              atRowIndex: rowIndex + (index + 1),
              columnIndex: columnIndex - (index + 1)
            )
            if !existsSouthWest {
              exists.remove(.southWest)
            }
          }
          
          if exists.contains(.west) {
            let existsWest = entities.isCharacter(
              char,
              atRowIndex: rowIndex,
              columnIndex: columnIndex - (index + 1)
            )
            if !existsWest {
              exists.remove(.west)
            }
          }
          
          if exists.contains(.northWest) {
            let existsNorthWest = entities.isCharacter(
              char,
              atRowIndex: rowIndex - (index + 1),
              columnIndex: columnIndex - (index + 1)
            )
            if !existsNorthWest {
              exists.remove(.northWest)
            }
          }
          
          if exists.isEmpty {
            break
          }
        }
        
        xmasCount += exists.rawValue.nonzeroBitCount
      }
    }
    
    return xmasCount
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var xmasCount = 0
    
    let rowCount = entities.count
    for rowIndex in 1..<(rowCount - 1) {
      let columnCount = entities[rowIndex].count
      for columnIndex in 1..<(columnCount - 1) {
        let isA = entities[rowIndex][columnIndex] == "A"
        guard isA else {
          continue
        }
        
        let northWest = entities[rowIndex - 1][columnIndex - 1]
        let northEast = entities[rowIndex - 1][columnIndex + 1]
        let southWest = entities[rowIndex + 1][columnIndex - 1]
        let southEast = entities[rowIndex + 1][columnIndex + 1]
        
        guard (northWest == "M" && southEast == "S") ||
                (northWest == "S" && southEast == "M")
        else {
          continue
        }
        
        guard (southWest == "M" && northEast == "S") ||
                (southWest == "S" && northEast == "M")
        else {
          continue
        }
        
        xmasCount += 1
      }
    }
    
    return xmasCount
  }
}
