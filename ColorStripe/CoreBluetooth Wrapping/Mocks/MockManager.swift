//
//  MockManager.swift
//  ColorStripe
//
//  Created by Dorian Grolaux on 28/06/2021.
//

import Foundation
import CoreBluetooth

class MockManager: ManagerWrapper {
    
    // MARK: - Private
    
    private static let availablePeripherals: [MockPeripheral] = [
        .iphone,
        .mbPro,
        .phBalcony,
        .phBedRoom,
        .triones,
        .tv,
        .phLivingRoom,
        .unkown1,
        .unkown2
    ]
    
    private var foundPeripherals: [PeripheralWrapper] = []
    
    private var currentPeripheralIndex: Int = 0
    
    private var timer: Timer? = nil
    
    private init(delegate: ManagerDelegateWrapper?) {
        self.delegateWrapper = delegate
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Conformance
    
    static func initialize(delegate: ManagerDelegateWrapper?, queue: DispatchQueue) -> Self {
        return MockManager(delegate: delegate) as! Self
    }
    
    var delegateWrapper: ManagerDelegateWrapper?
    
    var stateWrapper: ManagerState = .unknown {
        didSet {
            delegateWrapper?.managerDidUpdateState(self)
        }
    }
    
    func scanForPeripheralsWrapper(withServices serviceUUIDs: [CBUUID]?) {
        stateWrapper = .poweredOn
        
        timer = .scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            guard self.currentPeripheralIndex < Self.availablePeripherals.count else {
                self.stateWrapper = .resetting
                return
            }
            let peripheral = Self.availablePeripherals[self.currentPeripheralIndex]
            self.foundPeripherals.append(peripheral)
            self.delegateWrapper?.manager(self,
                                          didDiscover: peripheral,
                                          advertisementData: [:],
                                          rssi: .init(value: peripheral.identifier.hashValue))
            self.currentPeripheralIndex += 1
        })
    }
    
    func connectWrapper(_ peripheral: PeripheralWrapper, options: [String : Any]?) {
        delegateWrapper?.manager(self, didConnect: peripheral)
    }
    
    func stopScanWrapper() {
        stateWrapper = .poweredOff
    }
}
