//
//  Created by Artem Novichkov on 31.05.2021.
//

import SwiftUI
import CoreBluetooth
import Combine

final class DevicesViewModel<Manager: ManagerWrapper>: ObservableObject {
    
    @AppStorage("identifier") var identifier: String = ""
    @Published var state: ManagerState = .unknown
    @Published var peripherals: [PeripheralWrapper] = []

    private var manager: BluetoothProviderWrapper<Manager>
    private lazy var cancellables: Set<AnyCancellable> = .init()

    //MARK: - Lifecycle
    
    init(manager: BluetoothProviderWrapper<Manager>) {
        self.manager = manager
    }
    
    init() where Manager == CentralManagerWrapper {
        self.manager = BluetoothProvider.shared
    }
    
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
//            .filter { [weak self] in self?.peripherals.contains($0) == false }
//            .sink { [weak self] in
//                self?.peripherals.insertSorted($0)
//            }
            .filter { [weak self] newPeripheral in self?.peripherals.contains(where: { peripheral in
                newPeripheral.identifier == peripheral.identifier
            }) == false}
            .sink { [weak self] in
                self?.peripherals.append($0)
            }
            
            .store(in: &cancellables)
        manager.start()
    }
}
