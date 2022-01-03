//
//  Clonable.swift
//  MagnetPuzzleSwift
//
//  Created by Kiarash Vosough on 10/13/1400 AP.
//

import Foundation

protocol Clonable {
    func clone() -> Self
}

extension Clonable {
    func clone() -> Self {
        let new = self
        return new
    }
}
