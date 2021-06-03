//
//  Created by Artem Novichkov on 31.05.2021.
//

import SwiftUI
import CoreBluetooth

struct DevicesView: View {
    
    @StateObject private var viewModel: DevicesViewModel = .init()
    @Binding var peripheral: CBPeripheral?
    @Environment(\.presentationMode) private var presentationMode
    
    private var peripherals: [CBPeripheral] {
        viewModel.peripherals.sorted { left, right in
            guard let leftName = left.name else {
                return false
            }
            guard let rightName = right.name else {
                return true
            }
            return leftName < rightName
        }
    }
    
    //MARK: - Lifecycle
    
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
            List(peripherals, id: \.identifier) { peripheral in
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
        DevicesView(peripheral: .constant(nil))
    }
}
