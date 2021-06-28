//
//  MockPeripheral.swift
//  ColorStripe
//
//  Created by Dorian Grolaux on 28/06/2021.
//

import Foundation
import CoreBluetooth

class MockPeripheral: PeripheralWrapper {
    var identifier: UUID
    
    var name: String?
    
    weak var delegateWrapper: PeripheralDelegateWrapper?
    
    var servicesWrapper: [ServiceWrapper]?
    
    init(name: String? = nil, id: UUID = .init()) {
        self.identifier = id
        self.name = name
    }
    
    func discoverServicesWrapper(_ services: [ServiceWrapper]?) {
        //
    }
    
    func discoverCharacteristicsWrapper(_ characteristicUUIDs: [CBUUID]?, for service: ServiceWrapper) {
        //
    }
    
    func writeValueWrapper(_ data: Data, for characteristic: CharacteristicWrapper) {
        //
    }
}

extension MockPeripheral {
    static let triones: MockPeripheral = .init(name: "Triones", id: .init(uuidString: "1")!)
    static let phLivingRoom: MockPeripheral = .init(name: "Philips Hue - Living Room", id: .init(uuidString: "3")!)
    static let phBedRoom: MockPeripheral = .init(name: "Philips Hue - Bed Room", id: .init(uuidString: "4")!)
    static let phBalcony: MockPeripheral = .init(name: "Philips Hue - Balcony", id: .init(uuidString: "5")!)
    static let mbPro: MockPeripheral = .init(name: "Dorian's Macbook Pro", id: .init(uuidString: "6")!)
    static let iphone: MockPeripheral = .init(name: "Dorian's iPhone", id: .init(uuidString: "7")!)
    static let tv: MockPeripheral = .init(name: "HaierTV-RC", id: .init(uuidString: "8")!)
    static let unkown1: MockPeripheral = .init(id: .init(uuidString: "9")!)
    static let unkown2: MockPeripheral = .init(id: .init(uuidString: "10")!)
}
