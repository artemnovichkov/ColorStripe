//
//  Created by Artem Novichkov on 31.05.2021.
//

import CoreBluetooth
import Combine

final class DeviceViewModel: ObservableObject {

    @Published var isReady = false
    @Published var state: StripeState = .init()

    private enum Constants {
        static let readServiceUUID: CBUUID = .init(string: "FFD0")
        static let writeServiceUUID: CBUUID = .init(string: "FFD5")
        static let serviceUUIDs: [CBUUID] = [readServiceUUID, writeServiceUUID]
        static let readCharacteristicUUID: CBUUID = .init(string: "FFD4")
        static let writeCharacteristicUUID: CBUUID = .init(string: "FFD9")
    }

    private lazy var manager: BluetoothManager = .shared
    private lazy var cancellables: Set<AnyCancellable> = .init()

    private let peripheralModel: PeripheralModel
    private var peripheral: CBPeripheral?
    private var readCharacteristic: CBCharacteristic?
    private var writeCharacteristic: CBCharacteristic?

    //MARK: - Lifecycle

    init(peripheral: PeripheralModel) {
        self.peripheralModel = peripheral
    }

    deinit {
        cancellables.cancel()
    }

    func connect() {
        manager.peripheralSubject
            .filter { [weak self] in $0.identifier == self?.peripheralModel.id }
            .sink {
                [weak self] peripheral in
                guard let self = self else { return }
                self.peripheral = peripheral
                
                self.manager.servicesSubject
                    .map { $0.filter { Constants.serviceUUIDs.contains($0.uuid) } }
                    .sink { services in
                        services.forEach { service in
                            peripheral.discoverCharacteristics(nil, for: service)
                        }
                    }
                    .store(in: &self.cancellables)
                
                self.manager.characteristicsSubject
                    .filter { $0.0.uuid == Constants.readServiceUUID }
                    .compactMap { $0.1.first(where: \.uuid == Constants.readCharacteristicUUID) }
                    .sink { [weak self] characteristic in
                        self?.readCharacteristic = characteristic
                        self?.update(StripeData.state(from: characteristic.value))
                    }
                    .store(in: &self.cancellables)
                
                self.manager.characteristicsSubject
                    .filter { $0.0.uuid == Constants.writeServiceUUID }
                    .compactMap { $0.1.first(where: \.uuid == Constants.writeCharacteristicUUID) }
                    .sink { [weak self] characteristic in
                        self?.writeCharacteristic = characteristic
                    }
                    .store(in: &self.cancellables)
                
                self.manager.connect(peripheral)
            }
            .store(in: &cancellables)
    }

    private func update(_ state: StripeState) {
        let onPublisher = state.$isOn
            .map { StripeData.powerData(isOn: $0) }

        let colorPublisher = state.$color
            .compactMap { try? StripeData.staticColorData(from: $0) }

        let modePublisher = state.$mode
            .compactMap { $0 }
            .combineLatest(state.$speed)
            .map { StripeData.modeData(with: $0, speed: $1) }

        onPublisher.merge(with: colorPublisher, modePublisher)
            .dropFirst(3)
            .sink { [weak self] in self?.write($0) }
            .store(in: &cancellables)
        self.state = state
        self.isReady = true
    }

    private func write(_ data: Data) {
        guard let characteristic = writeCharacteristic else {
            return
        }
        peripheral?.writeValue(data, for: characteristic, type: .withoutResponse)
    }
}

func ==<Root, Value: Equatable>(lhs: KeyPath<Root, Value>, rhs: Value) -> (Root) -> Bool {
    { $0[keyPath: lhs] == rhs }
}

func ==<Root, Value: Equatable>(lhs: KeyPath<Root, Value>, rhs: Value?) -> (Root) -> Bool {
    { $0[keyPath: lhs] == rhs }
}
