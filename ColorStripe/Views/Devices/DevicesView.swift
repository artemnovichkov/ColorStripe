//
//  Created by Artem Novichkov on 31.05.2021.
//

import SwiftUI
import CoreBluetooth

struct DevicesView: View {
    
    @StateObject private var viewModel: DevicesViewModel = .init()
    @Binding var peripheral: CBPeripheral?
    @Environment(\.presentationMode) private var presentationMode

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
            List {
                ForEach(viewModel.peripherals, id: \.identifier) { peripheral in
                    Text(peripheral.name ?? "Unknown")
                        .onTapGesture {
                            self.peripheral = peripheral
                            viewModel.identifier = peripheral.identifier.uuidString
                            presentationMode.wrappedValue.dismiss()
                        }
                }
            }
        }
        else {
            Text("Please enable bluetooth to search devices")
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView(peripheral: .constant(nil))
    }
}
