//
//  Day10.swift
//  AdventOfCode
//
//  Created by Todd Grooms on 12/12/24.
//

import Testing

@testable import AdventOfCode

struct Day10Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """

  @Test func testPart1() async throws {
    let challenge = Day10(data: testData)
    #expect(String(describing: challenge.part1()) == "6000")
  }

  @Test func testPart2() async throws {
    let challenge = Day10(data: testData)
    #expect(String(describing: challenge.part2()) == "32000")
  }
}
