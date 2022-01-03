//
//  MagnetSymbol.swift
//  MagnetPuzzleSwift
//
//  Created by Kiarash Vosough on 10/13/1400 AP.
//

import Foundation

enum MagnetSymbol: String, CaseIterable, Clonable {
    
    case positive = "+"
    case negative = "-"
    case nutral = "?"
    
    func inverse() -> MagnetSymbol {
        switch self {
        case .positive:
            return .negative
        case .negative:
            return .positive
        case .nutral:
            return .nutral
        }
    }
}
