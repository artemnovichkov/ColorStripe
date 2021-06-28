//
//  Created by Dorian Grolaux on 28/06/2021.
//

import Foundation
import CoreBluetooth

extension CBPeripheral: PeripheralWrapper {
    var delegateWrapper: PeripheralDelegateWrapper? {
        get {
            delegate as? PeripheralDelegateWrapper
        }
        set {
            guard let newValue = newValue as? CBPeripheralDelegate else { return }
            delegate = newValue
        }
    }
    
    var servicesWrapper: [ServiceWrapper]? {
        services
    }
    
    func discoverServicesWrapper(_ services: [ServiceWrapper]?) {
        discoverServices(services as? [CBUUID])
    }
    
    func discoverCharacteristicsWrapper(_ characteristicUUIDs: [CBUUID]?, for service: ServiceWrapper) {
        discoverCharacteristics(characteristicUUIDs, for: service as! CBService)
    }
    
    func writeValueWrapper(_ data: Data, for characteristic: CharacteristicWrapper) {
        writeValue(data, for: characteristic as! CBCharacteristic, type: .withoutResponse)
    }
}
