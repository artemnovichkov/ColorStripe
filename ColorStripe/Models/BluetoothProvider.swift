//
//  Created by Dorian Grolaux on 28/06/2021.
//

import Foundation
import CoreBluetooth

final class BluetoothProvider: BluetoothProviderWrapper<CentralManagerWrapper> {
    static let shared: BluetoothProvider = .init()
}

extension BluetoothProvider: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        peripheralWrapper(peripheral, didDiscoverServices: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        peripheralWrapper(peripheral, didDiscoverCharacteristicsFor: service, error: error)
    }
}
