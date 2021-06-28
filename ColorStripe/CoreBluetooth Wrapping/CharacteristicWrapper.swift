//
//  Created by Dorian Grolaux on 28/06/2021.
//

import Foundation
import CoreBluetooth

protocol CharacteristicWrapper {
    var uuid: CBUUID { get }
    
    var value: Data? { get }
}
