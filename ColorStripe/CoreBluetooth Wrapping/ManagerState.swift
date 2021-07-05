//
//  Created by Dorian Grolaux on 28/06/2021.
//

import Foundation
import CoreBluetooth

enum ManagerState {
    case poweredOn
    case poweredOff
    case resetting
    case unauthorized
    case unknown
    case unsupported
}

extension ManagerState {
    init(from managerState: CBManagerState) {
        switch managerState {
        case .unknown:
            self = .unknown
            
        case .resetting:
            self = .resetting
            
        case .unsupported:
            self = .unsupported
            
        case .unauthorized:
            self = .unauthorized
            
        case .poweredOff:
            self = .poweredOff
            
        case .poweredOn:
            self = .poweredOn
            
        @unknown default:
            fatalError("Unknown manager state: \(managerState)")
        }
    }
}
