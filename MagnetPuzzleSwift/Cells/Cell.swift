//
//  Cell.swift
//  MagnetPuzzleSwift
//
//  Created by Kiarash Vosough on 10/13/1400 AP.
//

import Foundation

class Cell: Equatable {
    
    let position: Position
    let nodeType: NodeType
    
    var specialprint: String { "" }
    
    init(position: Position, nodeType: NodeType) {
        self.position = position
        self.nodeType = nodeType
    }
    
    static func == (lhs: Cell, rhs: Cell) -> Bool {
        lhs === rhs
    }
}
