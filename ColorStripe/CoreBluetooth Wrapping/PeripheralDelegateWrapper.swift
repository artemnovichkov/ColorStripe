//
//  Created by Dorian Grolaux on 28/06/2021.
//

import Foundation

protocol PeripheralDelegateWrapper: AnyObject {
    func peripheralWrapper(_ peripheral: PeripheralWrapper, didDiscoverServices error: Error?)
    
    func peripheralWrapper(_ peripheral: PeripheralWrapper, didDiscoverCharacteristicsFor service: ServiceWrapper, error: Error?)
}
