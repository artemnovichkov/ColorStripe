//
//  Created by Artem Novichkov on 31.05.2021.
//

import Combine
import CoreBluetooth

class BluetoothProviderWrapper<CentralManager: ManagerWrapper>: NSObject {
    
    var stateSubject: PassthroughSubject<ManagerState, Never> = .init()
    var peripheralSubject: PassthroughSubject<PeripheralWrapper, Never> = .init()
    var servicesSubject: PassthroughSubject<[ServiceWrapper], Never> = .init()
    var characteristicsSubject: PassthroughSubject<(ServiceWrapper, [CharacteristicWrapper]), Never> = .init()

    private var centralManager: CentralManager!

    //MARK: - Lifecycle
    
    func start() {
        centralManager = .initialize(delegate: self, queue: .main)
    }
    
    func scan() {
        centralManager.scanForPeripheralsWrapper(withServices: nil)
    }
    
    func connect(_ peripheral: PeripheralWrapper) {
        centralManager.stopScanWrapper()
        peripheral.delegateWrapper = self
        centralManager.connectWrapper(peripheral, options: nil)
    }
}

extension BluetoothProviderWrapper: ManagerDelegateWrapper {
    func managerDidUpdateState(_ manager: ManagerWrapper) {
        stateSubject.send(manager.stateWrapper)
    }
    
    func manager(_ manager: ManagerWrapper, didDiscover peripheral: PeripheralWrapper, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        peripheralSubject.send(peripheral)
    }
    
    func manager(_ manager: ManagerWrapper, didConnect peripheral: PeripheralWrapper) {
        peripheral.discoverServicesWrapper(nil)
    }
}

extension BluetoothProviderWrapper: PeripheralDelegateWrapper {
    
    func peripheralWrapper(_ peripheral: PeripheralWrapper, didDiscoverServices error: Error?) {
        guard let services = peripheral.servicesWrapper else {
            return
        }
        servicesSubject.send(services)
    }
    
    func peripheralWrapper(_ peripheral: PeripheralWrapper, didDiscoverCharacteristicsFor service: ServiceWrapper, error: Error?) {
        guard let characteristics = service.characteristicsWrapper else {
            return
        }
        characteristicsSubject.send((service, characteristics))
    }
}
