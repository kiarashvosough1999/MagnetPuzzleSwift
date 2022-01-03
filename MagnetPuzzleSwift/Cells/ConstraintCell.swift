//
//  ConstraintCell.swift
//  MagnetPuzzleSwift
//
//  Created by Kiarash Vosough on 10/13/1400 AP.
//

import Foundation

final class ConstraintCell: Cell {

    let constraintValue: Int
    
    init(position: Position, nodeType: NodeType, constraintValue: Int) {
        self.constraintValue = constraintValue
        super.init(position: position, nodeType: nodeType)
    }
    
    override var specialprint: String {
        "\(constraintValue)"
    }
}
