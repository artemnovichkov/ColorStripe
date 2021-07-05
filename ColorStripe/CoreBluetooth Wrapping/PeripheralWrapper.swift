//
//  Created by Dorian Grolaux on 28/06/2021.
//

import Foundation
import CoreBluetooth

protocol PeripheralWrapper: AnyObject {
    var identifier: UUID { get }
    
    var name: String? { get }
    
    var delegateWrapper: PeripheralDelegateWrapper? { get set }
    
    var servicesWrapper: [ServiceWrapper]? { get }
    
    func discoverServicesWrapper(_ services: [ServiceWrapper]?)
    
    func discoverCharacteristicsWrapper(_ characteristicUUIDs: [CBUUID]?, for service: ServiceWrapper)
    
    func writeValueWrapper(_ data: Data, for characteristic: CharacteristicWrapper)
}
