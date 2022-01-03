//
//  Position.swift
//  MagnetPuzzleSwift
//
//  Created by Kiarash Vosough on 10/13/1400 AP.
//

import Foundation

struct Position: Equatable, Clonable {
    let i: Int
    let j: Int
    
    var rep: String {
        "\(i) \(j)"
    }
    
    func is_adjacent_with(position: Position) -> Bool {
        // top
        if self.i == position.i + 1 && self.j == position.j {
            return true
        }
        // down
        if self.i == position.i - 1 && self.j == position.j {
            return true
        }
        // left
        if self.i == position.i && self.j == position.j + 1 {
            return true
        }
        // right
        if self.i == position.i && self.j == position.j - 1 {
            return true
        }
        return false
    }
}
