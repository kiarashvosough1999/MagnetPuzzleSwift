//
//  main.swift
//  MagnetPuzzleSwift
//
//  Created by Kiarash Vosough on 10/13/1400 AP.
//

import Foundation

let board = BoardMaker(inputName:"/Users/kiarashvosough/Desktop/Magnet/Magnet/input1_method2.txt")
    .getBoard()
let csp = CSP(board: board)
csp.setup()

