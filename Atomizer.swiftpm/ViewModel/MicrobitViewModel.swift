import Foundation
import CoreBluetooth

/**
    A view model that manages the state of the micro:bit view.
 
    ATOMIZER
    Developed and Designed by John Seong.
*/

class MicrobitViewModel: NSObject, ObservableObject, CBCentralManagerDelegate {
    @Published var devices = [CBPeripheral]()
    private var centralManager: CBCentralManager?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            scanForDevices()
        } else {
            print("Central Manager State: \(central.state)")
        }
    }

    func scanForDevices() {
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }

    func stopScan() {
        centralManager?.stopScan()
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !devices.contains(peripheral) {
            DispatchQueue.main.async {
                self.devices.append(peripheral)
            }
        }
    }
}
