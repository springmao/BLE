//
//  CBPeripheral+Extension.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 20.05.2018.
//

import CoreBluetooth

extension CBPeripheral {
	var isConnected: Bool {
		return state == .connected
	}

	func getServiceWith(_ id: String) -> CBService? {

		guard let services = services else {return nil}

		for service in services {
			if service.id == id {
				return service
			}
		}
		return nil
	}

	func writeCommand(_ command: PowerCommand, for characteristic: CBCharacteristic) {
		let data = Data.dataWithValue(value: command.rawValue)
		writeValue(data, for: characteristic, type: .withResponse)
	}

	func findCharacteristicWithSensorType(_ sensorType: SensorType) -> CBCharacteristic? {
		guard let services = services else {return nil}
		for service in services {
			if let characteristic = service.findCharacteristicWithSensorType(sensorType) {
				return characteristic
			}
		}
		return nil
	}

	static func ==(lhs: CBPeripheral, rhs: CBPeripheral) -> Bool {
		return lhs.id == rhs.id
	}
}
