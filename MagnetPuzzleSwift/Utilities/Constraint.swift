//
//  Constraint.swift
//  MagnetPuzzleSwift
//
//  Created by Kiarash Vosough on 10/13/1400 AP.
//

import Foundation

struct Constraint: Equatable, Clonable {
    
    let rowPositiveConstraint: Int
    let rowNegativeConstraint: Int
    let columnPositiveConstraint: Int
    let columnNegativeConstraint: Int
    
    var rep: String {
        "\(rowPositiveConstraint)" +
        "\(rowNegativeConstraint)" +
        "\(columnPositiveConstraint)" +
        "\(columnNegativeConstraint)"
    }
}
