//
//  Day02.swift
//  AdventOfCode
//
//  Created by Todd Grooms on 12/2/24.
//

import Algorithms

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  /// Splits input data into an array of an array of integers.
  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
  }

  /// Each value of entities is an array of integers. The first value is a row or report. Inside
  /// the nested array of the report, are levels. We need to report the number of "safe" reports.
  /// A safe report is a report that:
  /// - Levels are either **all increasing** or **all decreasing**
  /// - Any two adjacent levels differ by **at least one** and **at most three**
  func part1() -> Any {
    let safeReports: [[Int]] = entities.compactMap { report in
      var previousLevel: Int?
      var previousDifferencePositive: Bool?
      for level in report {
        defer {
          previousLevel = level
        }
        
        guard let previousLevel else {
          continue
        }
        
        let difference = level - previousLevel
        guard abs(difference) >= 1, abs(difference) <= 3 else {
          return nil
        }
        
        let differencePositive = difference > 0
        defer {
          previousDifferencePositive = differencePositive
        }
        
        if let previousDifferencePositive,
           previousDifferencePositive != differencePositive {
          return nil
        }
      }
      
      return report
    }
    
    return safeReports.count
  }

  /// Same idea as part1, except we can ignore the first level that would normally signal
  /// an unsafe report. If we can ignore the first level that would normally signal an unsafe
  /// report, we can consider the report "safe".
  func part2() -> Any {
    var safeReports: Int = 0
    
    for report in entities {
      var safe: Bool = true
      
      for index in 0..<report.count {
        var doctored = report
        doctored.remove(at: index)
        
        var previousLevel: Int?
        var previousDifferencePositive: Bool?
        for level in doctored {
          defer {
            previousLevel = level
          }
          
          guard let previousLevel else {
            continue
          }
          
          let difference = level - previousLevel
          guard abs(difference) >= 1, abs(difference) <= 3 else {
            safe = false
            break
          }
          
          let differencePositive = difference > 0
          defer {
            previousDifferencePositive = differencePositive
          }
          
          if let previousDifferencePositive,
             previousDifferencePositive != differencePositive {
            safe = false
            break
          }
        }
        
        if safe {
          break
        } else if index < (report.count - 1) {
          safe = true
          continue
        }
      }
      
      if safe {
        safeReports += 1
      }
    }
    
    return safeReports
  }
}
