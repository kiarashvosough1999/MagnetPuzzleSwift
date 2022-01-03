//
//  main.swift
//  MagnetPuzzleSwift
//
//  Created by Kiarash Vosough on 10/13/1400 AP.
//

import Foundation

let inputsPath = "/Users/kiarashvosough/Desktop/MagnetPuzzleSwift/MagnetPuzzleSwift/Inputs/"

let input1 = "input1_method1.txt"
let input2 = "input1_method2.txt"
let input3 = "input1_method3.txt"

for item in [input1, input2, input3] {
    let board = BoardMaker(inputName: inputsPath + item).getBoard()
    let csp = CSP(board: board)
    csp.setup()
    sleep(20)
}

