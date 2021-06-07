//
//  Created by Artem Novichkov on 31.05.2021.
//

import SwiftUI
import CoreBluetooth
import Combine

final class MainViewModel: ObservableObject {

    @Published var state: CBManagerState = .unknown {
        didSet {
            update(with: state)
        }
    }
    @AppStorage("identifier") private var identifier: String = ""
    @Published var peripheral: PeripheralModel?

    private lazy var manager: BluetoothManager = .shared
    private lazy var cancellables: Set<AnyCancellable> = .init()

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
    
    private func update(with state: CBManagerState) {
        guard peripheral == nil else {
            return
        }
        guard state == .poweredOn else {
            return
        }
        manager.peripheralSubject
            .filter { $0.identifier == UUID(uuidString: self.identifier) }
            .sink { [weak self] in self?.peripheral = .init(id: $0.identifier, name: $0.name) }
            .store(in: &cancellables)
        manager.scan()
    }
}
