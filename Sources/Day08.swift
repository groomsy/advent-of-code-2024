//
//  Day08.swift
//  AdventOfCode
//
//  Created by Todd Grooms on 12/9/24.
//

import Algorithms

struct Day08: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var antennaField: AntennaField {
    var antennas: [Antenna] = []
    
    let lines = data.split(separator: "\n")
    var width: Int = 0
    let height = lines.count
    for (y, line) in lines.enumerated() {
      width = line.count
      for (x, character) in line.enumerated() {
        guard character != "." else { continue }
        antennas.append(
          Antenna(coordinate: Coordinate(x: x, y: y), character: character)
        )
      }
    }
    return AntennaField(
      antennas: antennas,
      size: Size(width: width, height: height)
    )
  }

  private func antinode(
    a: Coordinate,
    b: Coordinate,
    within field: AntennaField
  ) -> Coordinate? {
    let deltaX = a.x - b.x
    let deltaY = a.y - b.y
    
    let ax = a.x + deltaX
    let ay = a.y + deltaY
    if ax >= 0, ay >= 0, ax < field.size.width, ay < field.size.height {
      return Coordinate(x: ax, y: ay)
    } else {
      return nil
    }
  }
  
  func part1() -> Any {
    var antinodes: Set<Coordinate> = []
    
    var resolvedResonances: Set<ResonantFrequency> = []
    
    let field = antennaField
    for antennaA in field.antennas {
      for antennaB in field.antennas {
        guard antennaA != antennaB else { continue }
        
        guard antennaA.character == antennaB.character else { continue }
        
        let resonanceFrequency = ResonantFrequency(antennaA: antennaA, antennaB: antennaB)
        guard !resolvedResonances.contains(resonanceFrequency) else { continue }
        
        let antinodeA = antinode(
          a: antennaA.coordinate,
          b: antennaB.coordinate,
          within: field
        )
        if let antinodeA {
          antinodes.insert(antinodeA)
        }
        
        let antinodeB = antinode(
          a: antennaB.coordinate,
          b: antennaA.coordinate,
          within: field
        )
        if let antinodeB {
          antinodes.insert(antinodeB)
        }
        
        resolvedResonances.insert(resonanceFrequency)
      }
    }
    
    return antinodes.count
  }

  func part2() -> Any {
    // In part2, we just need to keep calculating antinodes until nil (in each direction).
    var antinodes: Set<Coordinate> = []
    
    var resolvedResonances: Set<ResonantFrequency> = []
    
    let field = antennaField
    for antennaA in field.antennas {
      for antennaB in field.antennas {
        guard antennaA != antennaB else { continue }
        
        guard antennaA.character == antennaB.character else { continue }
        
        let resonanceFrequency = ResonantFrequency(antennaA: antennaA, antennaB: antennaB)
        guard !resolvedResonances.contains(resonanceFrequency) else { continue }
        
        var a: Coordinate? = antennaA.coordinate
        var b: Coordinate? = antennaB.coordinate
        while a != nil {
          let antinode = antinode(a: a!, b: b!, within: field)
          if let antinode {
            antinodes.insert(antinode)
          }
          b = a
          a = antinode
        }
        
        a = antennaB.coordinate
        b = antennaA.coordinate
        while a != nil {
          let antinode = antinode(a: a!, b: b!, within: field)
          if let antinode {
            antinodes.insert(antinode)
          }
          b = a
          a = antinode
        }
        
        resolvedResonances.insert(resonanceFrequency)
      }
      
      antinodes.insert(antennaA.coordinate)
    }
    
    return antinodes.count
  }
}

struct AntennaField {
  let antennas: [Antenna]
  let size: Size
  
  let occupiedCoordinates: Set<Coordinate>
  
  init(antennas: [Antenna], size: Size) {
    self.antennas = antennas
    self.size = size
    self.occupiedCoordinates = Set(antennas.map(\.coordinate))
  }
}

struct Antenna: Hashable {
  let coordinate: Coordinate
  let character: Character
}

struct ResonantFrequency: Equatable, Hashable {
  let antennaA: Antenna
  let antennaB: Antenna
  
  func equals(_ other: ResonantFrequency) -> Bool {
    (antennaA == other.antennaA && antennaB == other.antennaB) || (antennaA == other.antennaB && antennaB == other.antennaA)
  }
}
