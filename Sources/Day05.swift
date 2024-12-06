//
//  Day05.swift
//  AdventOfCode
//
//  Created by Todd Grooms on 12/5/24.
//

import Algorithms
import Foundation

struct Day05: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var guide: Guide {
    let input = data.split(separator: "\n\n")
    let ruleInput = input.first
    
    var rules: [Int: Set<Int>] = [:]
    
    for line in ruleInput!.split(separator: "\n") {
      let parts = line.split(separator: "|")
      let key = Int(parts.first!)!
      let value = Int(parts.last!)!
      
      var set = rules[key] ?? []
      set.insert(value)
      rules[key] = set
    }
    
    let jobs = input.last!.split(separator: "\n").map {
      $0.split(separator: ",").map { Int($0)! }
    }
    
    return Guide(rules: rules, jobs: jobs)
  }

  func part1() -> Any {
    return guide.validJobs.reduce(into: 0) { partialResult, job in
      return partialResult += job.median
    }
  }

  func part2() -> Any {
    var correctedJobs: [[Int]] = []
    
    for var job in guide.invalidJobs {
      job.sort { left, right in
        guard let following = guide.rules[left] else {
          return false
        }
        
        return following.contains(right)
      }
      correctedJobs.append(job)
    }
    
    return correctedJobs.reduce(into: 0) { partialResult, job in
      return partialResult += job.median
    }
  }
}

struct Guide {
  let rules: [Int: Set<Int>]
  
  let jobs: [[Int]]
  
  let validJobs: [[Int]]
  let invalidJobs: [[Int]]
  
  init(rules: [Int: Set<Int>], jobs: [[Int]]) {
    self.rules = rules
    self.jobs = jobs
    
    var validJobs: [[Int]] = []
    var invalidJobs: [[Int]] = []
    
    for job in jobs {
      var valid = true
      
      var previous: Int?
      for item in job {
        defer {
          previous = item
        }
        
        guard let previous else {
          continue
        }
        
        guard let following = rules[previous] else {
          valid = false
          break
        }
        
        if !following.contains(item) {
          valid = false
          break
        }
      }
      
      if valid {
        validJobs.append(job)
      } else {
        invalidJobs.append(job)
      }
    }
    
    self.validJobs = validJobs
    self.invalidJobs = invalidJobs
  }
}

extension Array where Element == Int {
  var median: Int {
    let index = Int(floor(Double(count) / 2.0))
    return self[index]
  }
}
