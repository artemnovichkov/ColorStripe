//
//  Created by Dorian Grolaux on 28/06/2021.
//

import Foundation

protocol ManagerDelegateWrapper: AnyObject {
    func managerDidUpdateState(_ manager: ManagerWrapper)
    
    func manager(_ manager: ManagerWrapper,
                 didDiscover peripheral: PeripheralWrapper,
                 advertisementData: [String: Any],
                 rssi RSSI: NSNumber)
    
    func manager(_ manager: ManagerWrapper,
                 didConnect peripheral: PeripheralWrapper)
}
