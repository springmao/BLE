//
//  CBService+Extension.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 20.05.2018.
//

import CoreBluetooth

extension CBService {

	var isHolyIOT: Bool {
		return id == HolyIOT.serviceUUID
	}

	func findCharacteristicWithSensorType(_ sensorType: SensorType) -> CBCharacteristic? {
		guard let characteristics = characteristics else {return nil}
		return characteristics.first {$0.sensorType == sensorType}
	}

	func findCharacteristicWith(_ id: String) -> CBCharacteristic? {
		guard let characteristics = characteristics else {return nil}
		for characteristic in characteristics {
			if characteristic.id == id.uppercased() {
				return characteristic
			}
		}
		return nil
	}

	open override var debugDescription: String {
		let includedServicesString: String = includedServices?.map { (service) -> String in
			return "\n  \(service.debugDescription)"
			}.joined(separator: ", ") ?? "[]"
		let charsString: String = characteristics?.map {"\n    \($0.debugDescription)"}.joined(separator: ", ") ?? "[]"
		return """
		Suuid: \(uuid)
		SisPrimary: \(isPrimary)
		SincludedServices: \(includedServicesString)
		Scharacteristics: \(charsString)
		"""
	}
}
