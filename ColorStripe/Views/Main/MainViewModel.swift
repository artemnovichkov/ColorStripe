//
//  Created by Artem Novichkov on 31.05.2021.
//

import SwiftUI
import CoreBluetooth
import Combine

final class MainViewModel<Manager: ManagerWrapper>: ObservableObject {

    @Published var state: ManagerState = .unknown {
        didSet {
            update(with: state)
        }
    }
    @AppStorage("identifier") private var identifier: String = ""
    @Published var peripheral: PeripheralWrapper?

    private var manager: BluetoothProviderWrapper<Manager>
    private lazy var cancellables: Set<AnyCancellable> = .init()

    init(manager: BluetoothProviderWrapper<Manager>) {
        self.manager = manager
    }
    
    init() where Manager == CentralManagerWrapper {
        self.manager = BluetoothProvider.shared
    }
    
    //MARK: - Lifecycle
    
    deinit {
        cancellables.cancel()
    }
    
    func start() {
        manager.stateSubject.sink { [weak self] state in
            self?.state = state
        }
        .store(in: &cancellables)
        manager.start()
    }

    //MARK: - Private
    
    private func update(with state: ManagerState) {
        guard peripheral == nil else {
            return
        }
        guard state == .poweredOn else {
            return
        }
        manager.peripheralSubject
            .filter { $0.identifier == UUID(uuidString: self.identifier) }
            .sink { [weak self] in self?.peripheral = $0 }
            .store(in: &cancellables)
        manager.scan()
    }
}
