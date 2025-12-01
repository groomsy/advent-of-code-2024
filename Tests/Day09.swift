//
//  Day09.swift
//  AdventOfCode
//
//  Created by Todd Grooms on 12/10/24.
//

import Testing

@testable import AdventOfCode

struct Day09Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    2333133121414131402
    """

  @Test func testPart1() async throws {
    let challenge = Day09(data: testData)
    #expect(String(describing: challenge.part1()) == "1928")
  }

  @Test func testPart2() async throws {
    let challenge = Day09(data: testData)
    #expect(String(describing: challenge.part2()) == "2858")
  }
}
