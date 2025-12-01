//
//  Day07.swift
//  AdventOfCode
//
//  Created by Todd Grooms on 12/8/24.
//

import Algorithms
import Foundation

struct Day07: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var probableEquations: [ProbableEquation] {
    data.split(separator: "\n").map {
      let parts = $0.split(separator: ": ")
      return ProbableEquation(
        solution: Int(parts.first!)!,
        input: parts.last!.split(separator: " ").map { Int($0)! }
      )
    }
  }
  
  func part1() -> Any {
    probableEquations.filter(\.validWithTwoOperators).reduce(into: 0) { partialResult, equation in
      partialResult += equation.solution
    }
  }

  func part2() -> Any {
    var sum: Int = part1() as! Int
    
    let probableEquations = probableEquations.filter(\.invalidWithTwoOperators)
    for probableEquation in probableEquations {
      let input = probableEquation.input
      let solution = probableEquation.solution
      
      let iterations = Int(pow(3.0, Double(input.count - 1)))
      for iteration in 0..<iterations {
        var result = input.first!
        let input = input.dropFirst()
        for (index, value) in input.enumerated() {
          
          let step = (iteration / Int(pow(3.0, Double(index)))) % 3
          if step == 2 {
            result = Int(String(result) + String(value))!
          } else if step == 1 {
            result *= value
          } else {
            result += value
          }
          
          if result > solution {
            break
          }
        }
        if result == solution {
          sum += solution
          break
        }
      }
    }
    
    return sum
  }
}

struct ProbableEquation {
  let solution: Int
  let input: [Int]
  let validWithTwoOperators: Bool
  var invalidWithTwoOperators: Bool {
    !validWithTwoOperators
  }
  
  init(solution: Int, input: [Int]) {
    self.solution = solution
    self.input = input
    
    let iterations = Int(pow(2.0, Double(input.count - 1)))
    for iteration in 0..<iterations {
      var result = input.first!
      let input = input.dropFirst()
      for (index, value) in input.enumerated() {
        let flag = 1 << index
        if iteration & flag == flag {
          result *= value
        } else {
          result += value
        }
        
        if result > solution {
          break
        }
      }
      if result == solution {
        validWithTwoOperators = true
        return
      }
    }
    validWithTwoOperators = false
  }
}
