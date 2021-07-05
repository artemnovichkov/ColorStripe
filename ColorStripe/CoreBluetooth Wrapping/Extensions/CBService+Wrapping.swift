//
//  Created by Dorian Grolaux on 28/06/2021.
//

import Foundation
import CoreBluetooth

extension CBService: ServiceWrapper {
    var characteristicsWrapper: [CharacteristicWrapper]? {
        characteristics
    }
}
