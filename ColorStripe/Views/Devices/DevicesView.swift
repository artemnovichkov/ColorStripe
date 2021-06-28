//
//  Created by Artem Novichkov on 31.05.2021.
//

import SwiftUI
import CoreBluetooth

struct DevicesView<T: ManagerWrapper>: View {
    
    @StateObject private var viewModel: DevicesViewModel<T>
    @Binding var peripheral: PeripheralWrapper?
    @Environment(\.presentationMode) private var presentationMode
    
    //MARK: - Lifecycle
    
    init(peripheral: Binding<PeripheralWrapper?>, viewModel: DevicesViewModel<T>) {
        self._peripheral = peripheral
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    init(peripheral: Binding<PeripheralWrapper?>) where T == CentralManagerWrapper {
        self._peripheral = peripheral
        self._viewModel = .init(wrappedValue: .init())
    }
    
    var body: some View {
        NavigationView {
            contentView
                .navigationTitle("Devices")
        }
        .onAppear {
            viewModel.start()
        }
    }
    
    //MARK: - Private
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.state == .poweredOn {
            List(viewModel.peripherals, id: \.identifier) { peripheral in
                HStack {
                    if let peripheralName = peripheral.name {
                        Text(peripheralName)
                    } else {
                        Text("Unknown")
                            .opacity(0.2)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .contentShape(Rectangle())
                .onTapGesture {
                    self.peripheral = peripheral
                    viewModel.identifier = peripheral.identifier.uuidString
                    presentationMode.wrappedValue.dismiss()
                }
            }
            
        } else {
            Text("Please enable bluetooth to search devices")
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView(peripheral: .constant(MockPeripheral.triones),
                    viewModel: .init(manager: MockBluetoothProvider.shared))
    }
}
