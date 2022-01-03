//
//  PairCell.swift
//  MagnetPuzzleSwift
//
//  Created by Kiarash Vosough on 10/13/1400 AP.
//

import Foundation

final class PairCell: Cell {
    
    let pairValue: Int
    
    let constraint: Constraint
    
    var pairCell:  PairCell?
    
    var assignedValue: MagnetSymbol?
    
    var rowNeighbours = [PairCell]()
    
    var columNeighbours = [PairCell]()
    
    var copyOfDomain: Set<MagnetSymbol> = [.positive, .negative, .nutral]
    
    var removedDomainStack = Set<MagnetSymbol>()
    
    init(position: Position, nodeType: NodeType, pairValue: Int, constraint: Constraint) {
        self.pairValue = pairValue
        self.constraint = constraint
        super.init(position: position, nodeType: nodeType)
    }
    
    func setAssignedValue(val: MagnetSymbol) {
        self.assignedValue = val
        self.copyOfDomain.remove(val)
    }
    
    func undoAssignedValue() {
        guard let assignedValue = assignedValue else { return }
        self.copyOfDomain.insert(assignedValue)
        self.assignedValue = nil
    }
    
    func isHorizontalPair() -> Bool {
        guard let pairCell = pairCell else { fatalError("pair is nil") }
        if position.i == pairCell.position.i {
            return true
        }
        return false
    }
    
    func isVerticalPair() -> Bool {
        guard let pairCell = pairCell else { fatalError("pair is nil") }
        if position.j == pairCell.position.j {
            return true
        }
        return false
    }
    
    func removeFromCopyDomainWith(dom: MagnetSymbol) {
        self.removedDomainStack.insert(dom)
        copyOfDomain.remove(dom)
    }
    
    func undoRemovingLastDomain() {
        self.copyOfDomain = copyOfDomain.union(removedDomainStack)
    }
    
    func isNodeFree2() -> Bool {
        return self.assignedValue == nil && self.pairCell?.assignedValue == nil
    }
    
    func isNodeFree() -> Bool {
        if self.assignedValue != nil && self.pairCell!.assignedValue != nil {
            return false
        }
        return true
    }
            
    
    override var specialprint: String {
        if let val = assignedValue?.rawValue {
            return "\(val)\(pairValue)"
        }
        return "\(pairValue)"
    }
}
