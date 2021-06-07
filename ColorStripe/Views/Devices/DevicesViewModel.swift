//
//  Created by Artem Novichkov on 31.05.2021.
//

import SwiftUI
import CoreBluetooth
import Combine

final class DevicesViewModel: ObservableObject {
    
    @AppStorage("identifier") var identifier: String = ""
    @Published var state: CBManagerState = .unknown
    @Published var peripherals: [PeripheralModel] = []

    private lazy var manager: BluetoothManager = .shared
    private lazy var cancellables: Set<AnyCancellable> = .init()

    //MARK: - Lifecycle
    
    deinit {
        cancellables.cancel()
    }
    
    func start() {
        manager.stateSubject
            .sink { [weak self] state in
                self?.state = state
                if state == .poweredOn {
                    self?.manager.scan()
                }
            }
            .store(in: &cancellables)
        manager.peripheralSubject
            .map { PeripheralModel(id: $0.identifier, name: $0.name) }
            .filter { [weak self] in self?.peripherals.contains($0) == false }
            .sink { [weak self] in
                self?.peripherals.insertSorted($0)
            }
            
            .store(in: &cancellables)
        manager.start()
    }
}
