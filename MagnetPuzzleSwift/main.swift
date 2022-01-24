//
//  main.swift
//  MagnetPuzzleSwift
//
//  Created by Kiarash Vosough on 10/13/1400 AP.
//

import Foundation

let inputsPath = "/Users/kiarashvosough/Desktop/Project/MagnetPuzzleSwift/MagnetPuzzleSwift/Inputs/"

let input1 = "input1_method2.txt"
let input2 = "input2_method2.txt"
let input3 = "input3_method2.txt"

for item in [input3, input2, input1] {
    let board = BoardMaker(inputName: inputsPath + item).getBoard()
    let csp = AI(board: board)
    csp.setup()
    sleep(20)
}

