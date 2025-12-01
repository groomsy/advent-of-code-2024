//
//  Day09.swift
//  AdventOfCode
//
//  Created by Todd Grooms on 12/10/24.
//

import Algorithms

struct Day09: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var entities: (onlyFiles: [File], all: [any Block]) {
    var files: [File] = []
    var blocks: [any Block] = []
    
    let characters = Array(data.trimmingCharacters(in: .whitespacesAndNewlines))
    for index in stride(from: 0, to: characters.count, by: 2) {
      let id = index / 2
      let fileLength = Int(String(characters[index]))!
      let file = File(id: id, length: fileLength)
      files.append(file)
      blocks.append(file)
     
      guard index + 1 < characters.count else { break }

      let spaceLength = Int(String(characters[index+1]))!
      if spaceLength > 0 {
        blocks.append(Space(length: spaceLength))
      }
    }
    
    return (onlyFiles: files, all: blocks)
  }

  func part1() -> Any {
    let entities = entities
    
    var files = entities.onlyFiles
    var migrant = files.removeLast()
    
    var index: Int = 0
    var checksum: Int = 0
    
    var lastProcessedFile: File?
    
    for block in entities.all {
      if let file = block as? File {
        if file.id > migrant.id {
          break
        } else if file.id == migrant.id {
          for _ in 0..<migrant.length {
            checksum += (index * file.id)
            index += 1
          }
          break
        } else {
          for _ in 0..<file.length {
            checksum += (index * file.id)
            index += 1
          }
          lastProcessedFile = file
        }
      } else if let space = block as? Space {
        for _ in 0..<space.length {
          checksum += (index * migrant.id)
          migrant.length -= 1
          index += 1
          
          if migrant.length == 0 {
            migrant = files.removeLast()
          }
          
          if let lastProcessedFile, migrant == lastProcessedFile {
            break
          }
        }
      }
    }
    
    return checksum
  }

  func part2() -> Any {
    let entities = entities
    
    var files = Array(entities.onlyFiles.reversed())
    var migrated: Set<File> = []
    
    var index: Int = 0
    var checksum: Int = 0
    
    var processed: Set<File> = []
    
    var debug = ""
    
    for block in entities.all {
      if let file = block as? File {
        guard !migrated.contains(file) else {
          index += file.length
          debug += String( repeating: ".", count: file.length)
          continue
        }
        
        for _ in 0..<file.length {
          debug += String(file.id)
          checksum += (index * file.id)
          index += 1
        }
        
        processed.insert(file)
      } else if let space = block as? Space {
        var availableSpace = space.length
        while availableSpace > 0 {
          let migrantIndex = files.firstIndex {
            $0.length <= availableSpace && !processed.contains($0)
          }
          
          guard let migrantIndex else {
            break
          }
          
          let migrant = files[migrantIndex]

          for _ in 0..<migrant.length {
            debug += String(migrant.id)
            checksum += (index * migrant.id)
            index += 1
          }
          files.remove(at: migrantIndex)
          migrated.insert(migrant)

          availableSpace -= migrant.length
        }
        
        if availableSpace > 0 {
          index += availableSpace
          debug += String( repeating: ".", count: availableSpace)
        }
      }
    }
    
    return checksum
  }
}

protocol Block: Equatable, Hashable {
  var length: Int { get set }
}

struct File: Block {
  let id: Int
  var length: Int
}

struct Space: Block {
  var length: Int
}
