//
//  Board.swift
//  Magnet
//
//  Created by Kiarash Vosough on 10/13/1400 AP.
//


final class Board {
    
    
    let columnCount: Int
    let rowCount: Int
    
    var borad: [[Cell]]
    
    internal init(columnCount: Int, rowCount: Int) {
        self.columnCount = columnCount + 2
        self.rowCount = rowCount + 2
        self.borad = [[Cell]]()
        for i in 0..<self.rowCount {
            var row:[Cell] = []
            for j in 0..<self.columnCount {
                row.append(Cell(position: .init(i: i, j: j), nodeType: .Null))
            }
            self.borad.insert(row, at: i)
        }
    }
    
    func setPairCell(i: Int, j: Int, cell: PairCell) {
        self.borad[i][j] = cell
    }
    
    func getItemAt<T>(position: Position) -> T where T: Cell {
        return self.borad[position.i][position.j] as! T
    }
    
    func setRowColumnStaticValues(rowPositiveDic: [Int:Int],
                                  rowNegativeDic: [Int:Int],
                                  columnPositiveDic: [Int:Int],
                                  columnNegativeDic: [Int:Int]) {
        self.borad[0][0] = EmptyCell(position: Position(i: 0, j: 0), nodeType: .Null, title: "+")
        self.borad[0][1] = EmptyCell(position: Position(i: 0, j: 1), nodeType: .Null, title: "+")
        self.borad[1][0] = EmptyCell(position: Position(i: 1, j: 0), nodeType: .Null, title: "+")
        self.borad[1][1] = EmptyCell(position: Position(i: 1, j: 1), nodeType: .Null, title: "-")
        
        // fill the static numbers at top
        for i in 2..<self.columnCount {
            let const_pos = columnPositiveDic[i]!
            self.borad[0][i] = ConstraintCell(position: .init(i: 0, j: i),
                                              nodeType: .Positive_Column,
                                              constraintValue: const_pos)
            let const_neg = columnNegativeDic[i]!
            self.borad[1][i] = ConstraintCell(position: .init(i: 1, j: i),
                                              nodeType: .Negativ_Column,
                                              constraintValue: const_neg)
        }
        
        // fill the static numbers at left
        for i in 2..<self.rowCount {
            let const_pos = rowPositiveDic[i]!
            self.borad[i][0] = ConstraintCell(position: .init(i: 0, j: i),
                                              nodeType: .Positive_Row,
                                              constraintValue: const_pos)
            let const_neg = rowNegativeDic[i]!
            self.borad[i][1] = ConstraintCell(position: .init(i: 1, j: i),
                                              nodeType: .Negativ_Row,
                                              constraintValue: const_neg)
            
        }
    }
    
    func printBoard() {
        for i in 0..<self.rowCount {
            for j in 0..<self.columnCount {
                let cell = borad[i][j]
                print(cell.specialprint,terminator: " ")
            }
            print("")
        }
    }
    
    func printBoardDoms() {
        for i in 0..<self.rowCount {
            for j in 0..<self.columnCount {
                let cell = borad[i][j]
                if let cell = cell as? PairCell {
                    print("\(cell.pairValue),\(cell.copyOfDomain.count)", terminator: " ")
                }
                else {
                    print(cell.specialprint,terminator: " ")
                }
            }
            print("")
        }
    }
}

