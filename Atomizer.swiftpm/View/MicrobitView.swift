import SwiftUI
import CoreBluetooth

struct MicrobitView: View {
    @StateObject private var microbitViewModel = MicrobitViewModel()

    var body: some View {
        List(microbitViewModel.devices, id: \.identifier) { device in
            Text(device.name ?? "Unnamed Device")
        }
        .onAppear {
            microbitViewModel.scanForDevices()
        }
        .onDisappear {
            microbitViewModel.stopScan()
        }
        .navigationTitle("micro:bit")
    }
}