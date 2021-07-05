//
//  Created by Dorian Grolaux on 28/06/2021.
//

import Foundation
import CoreBluetooth

protocol ServiceWrapper {
    var uuid: CBUUID { get }
    var characteristicsWrapper: [CharacteristicWrapper]? { get }
}
