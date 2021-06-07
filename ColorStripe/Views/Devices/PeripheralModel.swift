//
//  PeripheralModel.swift
//  ColorStripe
//
//  Created by Dorian Grolaux on 03/06/2021.
//

import Foundation

struct PeripheralModel: Identifiable, Equatable, Comparable {
    let id: UUID
    let name: String?
    
    static func < (lhs: PeripheralModel, rhs: PeripheralModel) -> Bool {
        guard let leftName = lhs.name else {
            return true
        }
        guard let rightName = rhs.name else {
            return false
        }
        return leftName > rightName
    }
}
