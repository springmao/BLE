//
//  Device.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 16.01.18.
//

import CoreBluetooth

public typealias Sensor = CBCharacteristic

public typealias State = CBPeripheralState

public typealias Service = CBService

public typealias Peripherial = CBPeripheral

protocol DeviceProtocol: NSObjectProtocol {
    func updated(id: String)
}

protocol DiscoverProtocol: NSObjectProtocol {
    func discoverSensor(_ sensor: Sensor)
    func didUpdateValueFor(_ sensor: Sensor)
}

class Device: NSObject, DiscoverProtocol {

    var id: String {
        return peripheral.id
    }

    var rssi: NSNumber = 0

    var name: String? {
        return peripheral.name
    }

    var stayConnected: Bool = false

    var advertisementData: AdvertisementData?

    var state: State {
        return peripheral.state
    }

    var services: [Service] {
        if let services = peripheral.services {
            return services
        }
        return []
    }

    private var peripheral: Peripherial!

    init(peripheral: Peripherial) {
        super.init()
        self.peripheral = peripheral
        peripheral.delegate = self
    }

    convenience init(peripheral: Peripherial, advertisementData: [String: Any]?, rssi: NSNumber) {
        self.init(peripheral: peripheral)
        if let advertisementData = advertisementData {
            self.advertisementData = AdvertisementData(advertisementData)
        }
        self.rssi = rssi
    }

    func readRSSI() {
        peripheral.readRSSI()
    }
	
	func isSensorTypeReady(_ sensorType: SensorType) -> Bool {
		return peripheral.findCharacteristicWithSensorType(sensorType) != nil
	}

    func turnOn() -> Bool {
        guard state == .connected else {return false}
        guard let power = peripheral.findCharacteristicWithSensorType(.power) else {fatalError("no power characteristic")}
        peripheral.writeCommand(.turnOn, for: power)
        return true
    }

    func turnOff() {
        guard state == .connected else {return}
        guard let power = peripheral.findCharacteristicWithSensorType(.power) else {fatalError("no power characteristic")}
        peripheral.writeCommand(.turnOff, for: power)
    }

    func setNotifyValue(_ value: Bool, for sensorType: SensorType) {
        guard state == .connected else {return}
        guard let characteristic = peripheral.findCharacteristicWithSensorType(sensorType) else {fatalError("no sensorType \(sensorType) characteristic")}
        peripheral.setNotifyValue(value, for: characteristic)
    }

	func updateFirmware() {
		guard state == .connected else {return}
		guard let power = peripheral.findCharacteristicWithSensorType(.power) else {fatalError("no power characteristic")}
		let data = Data.dataWithValue(value: UpdateCommand.update.rawValue)
		peripheral.writeValue(data, for: power, type: .withResponse)
	}

    func connect() {
        HolyCentralManager.shared.connect(id: id)
    }

    func disconnect() {
        HolyCentralManager.shared.disconnect(id: id)
    }

    func connected() {}

    func disconnected() {}

    func discoverSensor(_ sensor: Sensor) {}

    func didUpdateValueFor(_ sensor: Sensor) {}

	static func ==(lhs: Device, rhs: Device) -> Bool {
		return lhs.id == rhs.id
	}
}

extension Device: CBPeripheralDelegate {

    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {

    }

    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        for service in invalidatedServices {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        rssi = RSSI
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {return}
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {return}
        for characteristic in characteristics {
            discoverSensor(characteristic)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        didUpdateValueFor(characteristic)
    }
}

extension Device {
	open override var debugDescription: String {
		let advString = advertisementData?.localName ?? "no local name"
		let servicesString = services.map { (service) -> String in
			return "\n  \(service.debugDescription)"
			}.joined(separator: ", ")
		return """
		id: \(id)
		rssi: \(rssi)
		state: \(state)
		advertisementData: \(advString)
		services: \(servicesString)
		"""
	}
}
