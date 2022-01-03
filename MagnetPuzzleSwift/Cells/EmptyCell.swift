//
//  EmptyCell.swift
//  MagnetPuzzleSwift
//
//  Created by Kiarash Vosough on 10/13/1400 AP.
//

import Foundation

final class EmptyCell: Cell {
    
    let title: String
    
     init(position: Position, nodeType: NodeType, title: String) {
         self.title = title
         super.init(position: position, nodeType: nodeType)
    }
    
    override var specialprint: String {
        title
    }
}
