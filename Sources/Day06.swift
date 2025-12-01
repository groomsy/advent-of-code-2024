//
//  Day06.swift
//  AdventOfCode
//
//  Created by Todd Grooms on 12/6/24.
//

import Algorithms

struct Day06: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var board: Board {
    var guardStart: Coordinate?
    var obstacles: [Coordinate] = []
    
    var width: Int = 0
    let height: Int
    
    let lines = data.split(separator: "\n")
    height = lines.count
    for y in 0..<height {
      let line = lines[y]
      let characters = Array(line)
      width = characters.count
      for (x, character) in characters.enumerated() {
        if character == "#" {
          obstacles.append(Coordinate(x: x, y: y))
        } else if character == "^" {
          guardStart = Coordinate(x: x, y: y)
        }
      }
    }

    assert(guardStart != nil)
    
    let size = Size(width: width, height: height)
    
    return Board(guardStart: guardStart!, obstacles: obstacles, size: size)
  }

  func solve(_ board: Board) throws -> (visited: Set<Coordinate>, positions: Set<Coordinate>) {
    var positions: Set<Coordinate> = [board.guardStart]
    var visited: Set<Coordinate> = [board.guardStart]
    
    // Key: Row Index (Y-Value)
    // Value: Sorted Ascending Array of Column Indices (X-Values)
    //        Where Obstacles Reside
    var rowObstacleIndices: [Int: [Int]] = [:]
    // Key: Column Index (X-Value)
    // Value: Sorted Ascending Array of Row Indices (Y-Values)
    //        Where Obstacles Reside
    var columnObstacleIndices: [Int: [Int]] = [:]
    
    for obstacle in board.obstacles {
      var obstacleIndicesForRow = rowObstacleIndices[obstacle.y] ?? []
      obstacleIndicesForRow.insert(obstacle.x)
      rowObstacleIndices[obstacle.y] = obstacleIndicesForRow
      
      var obstacleIndicesForColumn = columnObstacleIndices[obstacle.x] ?? []
      obstacleIndicesForColumn.insert(obstacle.y)
      columnObstacleIndices[obstacle.x] = obstacleIndicesForColumn
    }
    
    // Always start by heading north
    var direction: Direction = .north
    var position: Coordinate? = board.guardStart
    
    var turn: Int = 1
    
    repeat {
      guard let pos = position else { break }
      
      switch direction {
      case .north:
        guard let obstacleIndicesForColumn = columnObstacleIndices[pos.x]
        else {
          position = nil
          break
        }
        
        
        let insertionIndex = obstacleIndicesForColumn.insertionIndex(of: pos.y)
        guard insertionIndex > 0 else {
          position = nil
          
          for y in 0..<pos.y {
            visited.insert(Coordinate(x: pos.x, y: y))
          }
          
          break
        }

        let nextY = obstacleIndicesForColumn[insertionIndex - 1] + 1
        for y in nextY...pos.y {
          visited.insert(Coordinate(x: pos.x, y: y))
        }
        
        position = Coordinate(x: pos.x, y: nextY)
        direction = .east
      case .east:
        guard let obstacleIndicesForRow = rowObstacleIndices[pos.y] else {
          position = nil
          break
        }
        let insertionIndex = obstacleIndicesForRow.insertionIndex(of: pos.x)
        guard insertionIndex < obstacleIndicesForRow.count else {
          position = nil
          
          for x in pos.x..<board.size.width {
            visited.insert(Coordinate(x: x, y: pos.y))
          }
          
          break
        }

        let nextX = obstacleIndicesForRow[insertionIndex] - 1
        for x in pos.x...nextX {
          visited.insert(Coordinate(x: x, y: pos.y))
        }
        
        position = Coordinate(x: nextX, y: pos.y)
        direction = .south
      case .south:
        guard let obstacleIndicesForColumn = columnObstacleIndices[pos.x] else {
          position = nil
          break
        }
        let insertionIndex = obstacleIndicesForColumn.insertionIndex(of: pos.y)
        guard insertionIndex < obstacleIndicesForColumn.count else {
          position = nil
          
          for y in pos.y..<board.size.height {
            visited.insert(Coordinate(x: pos.x, y: y))
          }
          
          break
        }

        let nextY = obstacleIndicesForColumn[insertionIndex] - 1
        for y in pos.y...nextY {
          visited.insert(Coordinate(x: pos.x, y: y))
        }
        
        position = Coordinate(x: pos.x, y: nextY)
        direction = .west
      case .west:
        guard let obstacleIndicesForRow = rowObstacleIndices[pos.y] else {
          position = nil
          break
        }
        let insertionIndex = obstacleIndicesForRow.insertionIndex(of: pos.x)
        guard insertionIndex > 0 else {
          position = nil
          
          for x in 0..<pos.x {
            visited.insert(Coordinate(x: x, y: pos.y))
          }
          
          break
        }

        let nextX = obstacleIndicesForRow[insertionIndex - 1] + 1
        for x in nextX...pos.x {
          visited.insert(Coordinate(x: x, y: pos.y))
        }
        
        position = Coordinate(x: nextX, y: pos.y)
        direction = .north
      }
      
      turn += 1
      if let position, position != pos, positions.contains(position) {
        throw CancellationError()
      } else if let position {
        positions.insert(position)
      }
      
    } while position != nil
    
    return (visited: visited, positions: positions)
  }
  
  func part1() -> Any {
    let count: Int
    do {
      count = try solve(board).visited.count
    } catch {
      count = 0
    }
    return count
  }

  func part2() -> Any {
    let visited: Set<Coordinate>
    do {
      visited = try solve(board).visited
    } catch {
      return -1
    }
    
    var cycles: Int = 0
    
    for coordinate in visited {
      var board = board
      board.obstacles.append(coordinate)
      do {
        _ = try solve(board)
      } catch {
        cycles += 1
      }
    }
    
    return cycles
  }
}

enum Direction {
  case north, east, south, west
}

struct Board {
  let guardStart: Coordinate
  var obstacles: [Coordinate]
  let size: Size
}

extension Array where Element == Int {
  mutating func insert(_ element: Element) {
    for (index, currentElement) in enumerated() {
      if element < currentElement {
        insert(element, at: index)
        return
      }
    }
    append(element)
  }
  
  func insertionIndex(of element: Element) -> Int {
    var lowerBound = startIndex
    var upperBound = endIndex
    
    var index: Int?
    repeat {
      let midIndex = (upperBound - lowerBound) / 2 + lowerBound
      let midValue = self[midIndex]
      
      if element < midValue, midIndex < upperBound {
        upperBound = midIndex
      } else if element < midValue {
        index = midIndex
      } else if element > midValue, midIndex > lowerBound {
        lowerBound = midIndex
      } else if element > midValue {
        index = midIndex + 1
      } else {
        index = midIndex
      }
    } while index == nil
    
    return index!
  }
}
