//
//  File.swift
//  
//
//  Created by John Seong on 2023-04-16.
//

import Foundation
import CoreBluetooth

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