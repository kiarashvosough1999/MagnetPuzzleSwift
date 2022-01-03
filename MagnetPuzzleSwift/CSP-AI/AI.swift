//
//  AI.swift
//  MagnetPuzzleSwift
//
//  Created by Kiarash Vosough on 10/13/1400 AP.
//

import Foundation

final class AI {
    
    let board: Board
    var variables: [PairCell]
    var assignedVars: [PairCell]
    
    init(board: Board) {
        self.board = board
        self.variables = []
        self.assignedVars = []
    }
    
    func setup() {
        setVars()
        backtrack(num: 0)
    }
  
    private func setVars() {
        for i in 2..<board.rowCount {
            for j in 2..<board.columnCount {
                let cell: PairCell = board.getItemAt(position: Position(i: i, j: j))
                setNeighbours(i: i, j: j)
                variables.append(cell)
            }
        }
    }
    
    private func setNeighbours(i: Int, j: Int) {
        var row_neighbors:[PairCell] = []
        let current_node: PairCell = board.getItemAt(position: Position(i: i, j: j))

        // find neighbor cell in row
        for k in 2..<board.columnCount {
            let next_node: PairCell = board.getItemAt(position: Position(i: i, j: k))
            // avoid adding same nodes
            
            if current_node !== next_node && !row_neighbors.contains(where: { $0 === next_node }) {
                row_neighbors.append(next_node)
            }
        }
        current_node.rowNeighbours = row_neighbors

        var column_neighbors:[PairCell] = []
        // find neighbor cell in a column
        for k in 2..<board.rowCount {
            let next_node: PairCell = board.getItemAt(position: Position(i: k, j: j))
            // avoid adding same nodes
            if current_node !== next_node && !column_neighbors.contains(where: { $0 === next_node }) {
                column_neighbors.append(next_node)
            }
        }
        current_node.columNeighbours = column_neighbors
    }
    
    private func mrv() -> PairCell? {
        variables
            .filter { $0.isNodeFree() }
            .filter { $0.copyOfDomain.count > 0 }
            .sorted(by: { $0.copyOfDomain.count < $1.copyOfDomain.count })
            .first
    }
    
    private func lcv(node: PairCell) -> [MagnetSymbol] {
        var domain_conflict: [(MagnetSymbol, Int)] = []

        for domain in node.copyOfDomain {
            var sum = 0
            if domain == MagnetSymbol.nutral {
                sum = 1000
            }
            else {
                for cell in node.rowNeighbours {
                    if cell.copyOfDomain.contains(domain) {
                        sum += 1
                    }
                }
                for cell in node.columNeighbours {
                    if cell.copyOfDomain.contains(domain) {
                        sum += 1
                    }
                }
            }
            domain_conflict.append((domain, sum))
        }
        
        return domain_conflict.sorted { $0.1 < $1.1 }.map { $0.0 }
    }
    
    private func forwardChecking(node: PairCell) -> Bool {
        // for current node check for removing domains which has conflict
        
        for neighbour in node.columNeighbours {
            if neighbour.copyOfDomain.contains(where: { $0.rawValue == node.assignedValue!.rawValue }) &&
                node.position.is_adjacent_with(position: neighbour.position) &&
                node.pairCell !== neighbour &&
                node.assignedValue != MagnetSymbol.nutral {
                neighbour.removeFromCopyDomainWith(dom: node.assignedValue!)
            }

            if neighbour.copyOfDomain.isEmpty && neighbour.assignedValue == nil {
                return false
            }
        }

        for neighbour in node.rowNeighbours {
            if neighbour.copyOfDomain.contains(where: { $0.rawValue == node.assignedValue!.rawValue }) &&
                node.position.is_adjacent_with(position: neighbour.position) &&
                node.pairCell !== neighbour &&
                node.assignedValue != MagnetSymbol.nutral {
                neighbour.removeFromCopyDomainWith(dom: node.assignedValue!)
            }

            if neighbour.copyOfDomain.isEmpty && neighbour.assignedValue == nil {
                return false
            }
        }

        // for the pair check for removing domains which has conflict
        
        for neighbour in node.pairCell!.columNeighbours {
            if neighbour.copyOfDomain.contains(where: { $0.rawValue == node.pairCell!.assignedValue!.rawValue }) &&
                node.pairCell!.position.is_adjacent_with(position: neighbour.position) &&
                node !== neighbour &&
                node.pairCell!.assignedValue != MagnetSymbol.nutral {
                neighbour.removeFromCopyDomainWith(dom: node.pairCell!.assignedValue!)
            }

            if neighbour.copyOfDomain.isEmpty && neighbour.assignedValue == nil {
                return false
            }
        }

        for neighbour in node.pairCell!.rowNeighbours {
            if neighbour.copyOfDomain.contains(where: { $0.rawValue == node.pairCell!.assignedValue!.rawValue }) &&
                node.pairCell!.position.is_adjacent_with(position: neighbour.position) &&
                node !== neighbour &&
                node.pairCell!.assignedValue != MagnetSymbol.nutral {
                neighbour.removeFromCopyDomainWith(dom: node.pairCell!.assignedValue!)
            }

            if neighbour.copyOfDomain.isEmpty && neighbour.assignedValue == nil {
                return false
            }
        }
        return true
    }
    
    
    private func undoForwardChecking(node: PairCell) {
        for neighbour in node.columNeighbours {
            neighbour.undoRemovingLastDomain()
        }

        for neighbour in node.rowNeighbours {
            neighbour.undoRemovingLastDomain()
        }

        for neighbour in node.pairCell!.columNeighbours {
            neighbour.undoRemovingLastDomain()
        }

        for neighbour in node.pairCell!.rowNeighbours {
            neighbour.undoRemovingLastDomain()
        }
    }
    
    private func isConsistent(node: PairCell) -> Bool {
        // curr node
        let pos1 = node.position
        let const1 = node.constraint
        let val1 = node.assignedValue

        var row_positive_constraint_sum1 = 0
        var row_negative_constraint_sum1 = 0
        var column_positive_constraint_sum1 = 0
        var column_negative_constraint_sum1 = 0

        if val1 == MagnetSymbol.negative {
            row_negative_constraint_sum1 += 1
            column_negative_constraint_sum1 += 1
        }
        else if val1 == MagnetSymbol.positive{
            row_positive_constraint_sum1 += 1
            column_positive_constraint_sum1 += 1
        }

        // check for row neighbours
        for neighbour in node.rowNeighbours {
            if !neighbour.isNodeFree2() && neighbour !== node {
                let is_adjacent = pos1.is_adjacent_with(position: neighbour.position)
                var has_same_value = node.assignedValue! == neighbour.assignedValue!

                if neighbour.assignedValue! == MagnetSymbol.nutral && node.assignedValue! == MagnetSymbol.nutral {
                    has_same_value = false
                }

                if is_adjacent && has_same_value && neighbour !== node.pairCell {
                    return false
                }

                let neighbour_value = neighbour.assignedValue
                if neighbour_value == MagnetSymbol.negative {
                    row_negative_constraint_sum1 += 1
                }
                else if neighbour_value == MagnetSymbol.positive {
                    row_positive_constraint_sum1 += 1
                }
            }
        }
        
        for neighbour in node.columNeighbours {
            if !neighbour.isNodeFree2() && neighbour !== node {
                let is_adjacent = pos1.is_adjacent_with(position: neighbour.position)
                var has_same_value = node.assignedValue! == neighbour.assignedValue!

                if neighbour.assignedValue! == MagnetSymbol.nutral && node.assignedValue! == MagnetSymbol.nutral {
                    has_same_value = false
                }

                if is_adjacent && has_same_value && neighbour !== node.pairCell {
                    return false
                }

                let neighbour_value = neighbour.assignedValue
                if neighbour_value == MagnetSymbol.negative {
                    column_negative_constraint_sum1 += 1
                }
                else if neighbour_value == MagnetSymbol.positive {
                    column_positive_constraint_sum1 += 1
                }
            }
        }

        // pair node

        let pos2 = node.pairCell!.position
        let const2 = node.pairCell!.constraint
        let val2 = node.pairCell!.assignedValue!

        var row_positive_constraint_sum2 = 0
        var row_negative_constraint_sum2 = 0
        var column_positive_constraint_sum2 = 0
        var column_negative_constraint_sum2 = 0

        if val2 == MagnetSymbol.negative {
            row_negative_constraint_sum2 += 1
            column_negative_constraint_sum2 += 1
        }
        else if val2 == MagnetSymbol.positive {
            row_positive_constraint_sum2 += 1
            column_positive_constraint_sum2 += 1
        }

        // check for row neighbours
        for neighbour in node.pairCell!.rowNeighbours {
            if !neighbour.isNodeFree2() && neighbour !== node.pairCell! {
                let is_adjacent = pos2.is_adjacent_with(position: neighbour.position)
                var has_same_value = node.pairCell!.assignedValue! == neighbour.assignedValue!

                if neighbour.assignedValue! == MagnetSymbol.nutral && node.pairCell!.assignedValue! == MagnetSymbol.nutral {
                    has_same_value = false
                }

                if is_adjacent && has_same_value && neighbour != node {
                    return false
                }

                let neighbour_value = neighbour.assignedValue!
                if neighbour_value == MagnetSymbol.negative {
                    row_negative_constraint_sum2 += 1
                }
                else if neighbour_value == MagnetSymbol.positive {
                    row_positive_constraint_sum2 += 1
                }
            }
        }
        
        for neighbour in node.pairCell!.columNeighbours {
            if !neighbour.isNodeFree2() && neighbour !== node.pairCell! {
                let is_adjacent = pos2.is_adjacent_with(position: neighbour.position)
                var has_same_value = node.pairCell!.assignedValue! == neighbour.assignedValue!

                if neighbour.assignedValue! == MagnetSymbol.nutral && node.pairCell!.assignedValue! == MagnetSymbol.nutral {
                    has_same_value = false
                }

                if is_adjacent && has_same_value && neighbour != node {
                    return false
                }

                let neighbour_value = neighbour.assignedValue!
                if neighbour_value == MagnetSymbol.negative {
                    column_negative_constraint_sum2 += 1
                }
                else if neighbour_value == MagnetSymbol.positive {
                    column_positive_constraint_sum2 += 1
                }
            }
        }

        let first = row_positive_constraint_sum1 > const1.rowPositiveConstraint ||
        row_negative_constraint_sum1 > const1.rowNegativeConstraint ||
        column_positive_constraint_sum1 > const1.columnPositiveConstraint ||
        column_negative_constraint_sum1 > const1.columnNegativeConstraint ? false : true
        
        let sec =  row_positive_constraint_sum2 > const2.rowPositiveConstraint ||
        row_negative_constraint_sum2 > const2.rowNegativeConstraint ||
        column_positive_constraint_sum2 > const2.columnPositiveConstraint ||
        column_negative_constraint_sum2 > const2.columnNegativeConstraint ? false : true
        return first && sec
    }

    @discardableResult
    private func backtrack(num: Int) -> Bool {
        print("ass ", num)
        if !isSolved(ass: num) {
            guard let node = mrv() else { return false }
            
            let domains = lcv(node: node)
            
            for domain in domains {
                print("")
                node.assignedValue = domain
                node.pairCell?.assignedValue = domain.inverse()
                
                print("assigned \(domain.rawValue) to \(node.position.rep) and \(domain.inverse().rawValue) to \(node.pairCell!.position.rep)")
                
                board.printBoard()
                self.assignedVars.append(node)

                if self.isConsistent(node: node) {
                    print("const")
                    if forwardChecking(node: node) {
                        if backtrack(num: num + 2) {
                            return true
                        }
                    }
                    undoForwardChecking(node: node)
                }

                node.pairCell?.undoAssignedValue()
                node.undoAssignedValue()
                self.assignedVars.removeAll(where: { $0 === node })
            }
            return false
        }
        else {
            print("solved")
            board.printBoard()
            exit(0)
        }
    }
    
    func isSolved(ass: Int) -> Bool {
        var row_const_pos: Bool = false
        var row_const_neg: Bool = false
        for i in 2..<board.rowCount {
            let row_neg_cons: ConstraintCell = board.getItemAt(position: Position(i: i, j: 1))
            let row_pos_cons: ConstraintCell = board.getItemAt(position: Position(i: i, j: 0))
            var row_neg_cons_sum = 0
            var row_pos_cons_sum = 0
            for j in 2..<board.columnCount {
                let cell: PairCell = board.getItemAt(position: Position(i: i, j: j))
                if let val = cell.assignedValue, val == MagnetSymbol.positive {
                    row_pos_cons_sum += 1
                }
                else if let val = cell.assignedValue, val == MagnetSymbol.negative {
                    row_neg_cons_sum += 1
                }
            }
            if row_neg_cons_sum == row_neg_cons.constraintValue && row_pos_cons_sum == row_pos_cons.constraintValue {
                row_const_pos = true
                row_const_neg = true
            }else {
                return false
            }
        }

        var column_const_pos: Bool = false
        var column_const_neg: Bool = false
        for j in 2..<board.columnCount {
            let column_neg_cons: ConstraintCell = board.getItemAt(position: Position(i: 1, j: j))
            let column_pos_cons: ConstraintCell = board.getItemAt(position: Position(i: 0, j: j))
            var column_neg_cons_sum = 0
            var column_pos_cons_sum = 0
            for i in 2..<board.rowCount {
                let cell: PairCell = board.getItemAt(position:Position(i: i, j: j))
                if let val = cell.assignedValue, val == MagnetSymbol.positive {
                    column_pos_cons_sum += 1
                }
                else if let val = cell.assignedValue, val == MagnetSymbol.negative {
                    column_neg_cons_sum += 1
                }
            }
            if column_neg_cons_sum == column_neg_cons.constraintValue && column_pos_cons_sum == column_pos_cons.constraintValue {
                column_const_pos = true
                column_const_neg = true
            }
            else {
                return false
            }
        }
        return column_const_pos && column_const_neg && row_const_pos && row_const_neg
    }
}
