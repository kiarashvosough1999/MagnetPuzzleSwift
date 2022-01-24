//
//  BoardMaker.swift
//  Magnet
//
//  Created by Kiarash Vosough on 10/13/1400 AP.
//

import Foundation

final class BoardMaker {
    
    let inputName: String
    
    init(inputName: String) {
        self.inputName = inputName
    }
    
    func getBoard() -> Board {
        
        do {
            let contents = try String(contentsOfFile: inputName, encoding: .utf8)
            
            let lines = contents.split(separator: "\r\n")
            
            let firstLine = String(lines[0]).split(separator: " ")

            let row_count = Int(String(firstLine.first!))!
            let column_count = Int(String(firstLine.last!))!
            
            let board = Board(columnCount: column_count, rowCount: row_count)
            
            
            let secondLine = String(lines[1]).split(separator: " ")
            var row_pos_dic = [Int: Int]()
            for (index, line) in secondLine.enumerated() {
                row_pos_dic.updateValue(Int(String(line))!, forKey: index + 2)
            }
            
            let thirdLine = String(lines[2]).split(separator: " ")
            var row_neg_dic = [Int: Int]()
            for (index, line) in thirdLine.enumerated() {
                row_neg_dic.updateValue(Int(String(line))!, forKey: index + 2)
            }
            
            let fourthLine = String(lines[3]).split(separator: " ")
            var column_pos_dic = [Int: Int]()
            for (index, line) in fourthLine.enumerated() {
                column_pos_dic.updateValue(Int(String(line))!, forKey: index + 2)
            }
            
            let fifthLine = String(lines[4]).split(separator: " ")
            var column_neg_dic = [Int: Int]()
            for (index, line) in fifthLine.enumerated() {
                column_neg_dic.updateValue(Int(String(line))!, forKey: index + 2)
            }
            
            
            board.setRowColumnStaticValues(rowPositiveDic: row_pos_dic,
                                           rowNegativeDic: row_neg_dic,
                                           columnPositiveDic: column_pos_dic,
                                           columnNegativeDic: column_neg_dic)
            
            var pairs: [PairCell] = []
            var counter = 5
            for i in 0..<row_count {
                // read each row values
                let line = String(lines[counter]).split(separator: " ")
                counter += 1
                for j in 0..<column_count {
                    let maped_i = i + 2
                    let maped_j = j + 2

                    // value for j column
                    let value = Int(String(line[j]))!

                    // map values of cell
                    let pairs_values = pairs.map { $0.pairValue }

                    let row_positive_constraint: ConstraintCell = board.getItemAt(position: Position(i: maped_i, j: 0))
                    let row_negative_constraint: ConstraintCell = board.getItemAt(position:Position(i: maped_i, j: 1))
                    let column_positive_constraint: ConstraintCell = board.getItemAt(position: Position(i: 0, j: maped_j))
                    let column_negative_constraint: ConstraintCell = board.getItemAt(position: Position(i: 1, j: maped_j))
                    
                    let const = Constraint(rowPositiveConstraint:row_positive_constraint.constraintValue,
                                           rowNegativeConstraint:row_negative_constraint.constraintValue,
                                           columnPositiveConstraint:column_positive_constraint.constraintValue,
                                           columnNegativeConstraint:column_negative_constraint.constraintValue)

                    // check if we can find cell which was generated before with the same value
                    if pairs_values.contains(value){
                        // find the desired cell
                        let cell = pairs.first(where: { $0.pairValue == value })
                        let next_cell = PairCell(position: Position(i: maped_i, j: maped_j),
                                                 nodeType: .Fillable,
                                                 pairValue: value,
                                                 constraint: const)
                        if let cell = cell {
                            cell.pairCell = next_cell
                            next_cell.pairCell = cell
                            board.setPairCell(i: maped_i, j: maped_j, cell: next_cell)
                        }
                        else {
                            fatalError("no matching pair was found")
                        }
                    }
                    else {
                        let cell = PairCell(position: Position(i: maped_i, j: maped_j),
                                        nodeType: .Fillable,
                                        pairValue: value,
                                        constraint: const)
                        board.setPairCell(i: maped_i, j: maped_j, cell: cell)
                        pairs.append(cell)
                    }
                }
            }
            return board
        } catch  {
            
        }
        fatalError()
    }
}
