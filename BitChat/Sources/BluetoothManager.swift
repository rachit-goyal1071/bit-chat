import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject {
    private var centralManager: CBCentralManager!
    private var peripheralManager: CBPeripheralManager!
    
    private var chatServiceUUID = CBUUID(string: "1234")
    private var chatCharacteristicUUID = CBUUID(string: "5678")
    
    private var discoveredChatCharacteristic: CBCharacteristic?
    private var chatCharacteristic: CBMutableCharacteristic?
    
    private var connectedPeripheral: CBPeripheral?
    
    @Published var receivedMessages: [String] = []
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
//    func sendMessage(_ text: String, to Peripheral: CBPeripheral) {
//        guard let data = text.data(using: .utf8) else { return }
//        
//        
//        //Find writable characteristics
//        if let characteristic = peripheral.services?.first?.characteristics?.first(where: { $0.uuid == chatCharacteristicUUID }) {
//            peripheral.writeValue(data, for: characteristic, type: .withResponse)
//            print("sent message \(text)")
//        }
//    }
    func sendMessage(_ text: String, to peripheral: CBPeripheral) {
        guard let peripheral = connectedPeripheral,
                let data = text.data(using: .utf8),
              let characteristic = discoveredChatCharacteristic else {
                print("Characteristic not ready yet")
                return
            }
            
            peripheral.writeValue(data, for: characteristic, type: .withResponse)
            print("📤 Sent message: \(text)")
        }
}

extension BluetoothManager: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("central ready - scanning...")
            central.scanForPeripherals(withServices: [chatServiceUUID], options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String:Any], rssi RSSI: NSNumber) {
        print("Found peripheral: \(peripheral.name ?? "Unknown")")
                central.stopScan()
                central.connect(peripheral, options: nil)
                peripheral.delegate = self
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral")
        connectedPeripheral = peripheral
        peripheral.discoverServices([chatServiceUUID])
        }
    
//    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
//        if peripheral.state == .poweredOn {
//            print("peripheral ready - advertising...")
//            let advertisementData: [String: Any] = [CBAdvertisementDataLocalNameKey: "ChatMode",]
//            peripheral.startAdvertising(advertisementData)
//        }
//    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let service = peripheral.services?.first(where: { $0.uuid == chatServiceUUID}) else { return }
        peripheral.discoverCharacteristics([chatCharacteristicUUID], for: service)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let charateristic = service.characteristics?.first(where: { $0.uuid == chatCharacteristicUUID}) {
            discoveredChatCharacteristic = charateristic
            print("discovered chat characteristic")
            peripheral.setNotifyValue(true, for: charateristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == chatCharacteristicUUID,
           let data = characteristic.value,
           let message = String(data: data, encoding: .utf8) {
            print("Received \(message)")
            DispatchQueue.main.async {
                self.receivedMessages.append(message)
            }
        }
    }
}

extension BluetoothManager: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            print("Peripheral ready - advertising service...")
            
            // device characterstics
            chatCharacteristic = CBMutableCharacteristic(
                type: chatCharacteristicUUID,
                properties: [.write, .read, .notify],
                value: nil,
                permissions: [.writeable, .readable]
            )
            
            let service = CBMutableService(
                type: chatServiceUUID,
                primary: true
            )
            service.characteristics = [chatCharacteristic!]
            
            peripheral.add(service)
            peripheral.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [chatServiceUUID]])
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            if let value = request.value,
               let message = String(data: value, encoding: .utf8) {
                print("received on pheripheral: \(message)")
                DispatchQueue.main.async{
                    self.receivedMessages.append(message)
                }
            }
            peripheral.respond(to: request, withResult: .success)
        }
    }
}
