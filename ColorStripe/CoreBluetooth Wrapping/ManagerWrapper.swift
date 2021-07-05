//
//  Created by Dorian Grolaux on 28/06/2021.
//

import Foundation
import CoreBluetooth

protocol ManagerWrapper {
    
    static func initialize(delegate: ManagerDelegateWrapper?, queue: DispatchQueue) -> Self
    
    var delegateWrapper: ManagerDelegateWrapper? { get set }
    
    var stateWrapper: ManagerState { get }
    
    func scanForPeripheralsWrapper(withServices serviceUUIDs: [CBUUID]?)
    
    func connectWrapper(_ peripheral: PeripheralWrapper, options: [String: Any]?)
    
    func stopScanWrapper()
}
