//
//  Created by Dorian Grolaux on 28/06/2021.
//

import Foundation

final class MockBluetoothProvider: BluetoothProviderWrapper<MockManager> {
    static let shared: MockBluetoothProvider = .init()
}
