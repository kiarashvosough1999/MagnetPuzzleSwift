//
//  NodeType.swift
//  MagnetPuzzleSwift
//
//  Created by Kiarash Vosough on 10/13/1400 AP.
//

import Foundation

enum NodeType: Int, Clonable {
    case Null = 0

    case Positive_Column = 1
    case Positive_Row = -1

    case Negativ_Column = 2
    case Negativ_Row = -2

    case Fillable = 10
}
