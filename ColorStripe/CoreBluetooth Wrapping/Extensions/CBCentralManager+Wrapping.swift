//
//  Created by Dorian Grolaux on 28/06/2021.
//

import Foundation
import CoreBluetooth

class CentralManagerWrapper: NSObject, ManagerWrapper, CBCentralManagerDelegate {
    
    private var cbManager: CBCentralManager!
    
    weak var delegateWrapper: ManagerDelegateWrapper?
    
    var stateWrapper: ManagerState {
            .init(from: cbManager.state)
    }
    
    required init(delegate: ManagerDelegateWrapper?, queue: DispatchQueue) {
        super.init()
        self.cbManager = .init(delegate: self, queue: queue)
        self.delegateWrapper = delegate
    }
    
    static func initialize(delegate: ManagerDelegateWrapper?, queue: DispatchQueue) -> Self {
            .init(delegate: delegate, queue: queue)
    }
    
    func scanForPeripheralsWrapper(withServices serviceUUIDs: [CBUUID]?) {
        cbManager.scanForPeripherals(withServices: serviceUUIDs, options: nil)
    }
    
    func connectWrapper(_ peripheral: PeripheralWrapper, options: [String : Any]?) {
        cbManager.connect(peripheral as! CBPeripheral, options: options)
    }
    
    func stopScanWrapper() {
        cbManager.stopScan()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        delegateWrapper?.managerDidUpdateState(self)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        delegateWrapper?.manager(self, didConnect: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        delegateWrapper?.manager(self, didDiscover: peripheral, advertisementData: advertisementData, rssi: RSSI)
    }
}
