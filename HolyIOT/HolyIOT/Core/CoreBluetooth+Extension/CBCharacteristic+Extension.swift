//
//  CBCharacteristic+Extension.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 20.05.2018.
//

import CoreBluetooth

extension CBCharacteristic {

	var sensorType: SensorType {
		return SensorType(rawValue: id)
	}
	var isAccelerometer: Bool {
		return id == HolyIOT.accelerometerUUID
	}
	var isGyroscope: Bool {
		return id == HolyIOT.gyroscopeUUID
	}
	var isMagnetometer: Bool {
		return id == HolyIOT.magnetometerUUID
	}
	var isBarometer: Bool {
		return id == HolyIOT.barometerUUID
	}
	var isHumidity: Bool {
		return id == HolyIOT.humidityUUID
	}
	var isTemperature: Bool {
		return id == HolyIOT.temperatureUUID
	}
	var isSFL: Bool {
		return id == HolyIOT.sflUUID
	}
	var isStatus: Bool {
		return id == HolyIOT.statusUUID
	}
	var isPower: Bool {
		return id == HolyIOT.powerUUID
	}
	var isPowerAnswer: Bool {
		return id == HolyIOT.powerAnswerUUID
	}

	open override var debugDescription: String {
		let descrsString = descriptors?.map {"\n    \($0.debugDescription)"}.joined(separator: ", ") ?? "[]"
		return """
		uuid \(uuid)
		isNotifying \(isNotifying)
		value \(value != nil)
		properties \(properties)
		descriptions \(descrsString)
		"""
	}
}
