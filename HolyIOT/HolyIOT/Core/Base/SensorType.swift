//
//  SensorType.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 20.05.2018.
//

import Foundation

/**
Sensor Type is kind of measurement unit of holyIOT device
*/
enum SensorType: String {
	case accelerometer
	case gyroscope
	case magnetometer
	case barometer
	case humidity
	case temperature
	case sfl
	case status
	case power
	case powerAnswer
	case unknown

	init(rawValue: String) {
		switch rawValue {
		case HolyIOT.accelerometerUUID:
			self = .accelerometer
		case HolyIOT.gyroscopeUUID:
			self = .gyroscope
		case HolyIOT.magnetometerUUID:
			self = .magnetometer
		case HolyIOT.barometerUUID:
			self = .barometer
		case HolyIOT.humidityUUID:
			self = .humidity
		case HolyIOT.temperatureUUID:
			self = .temperature
		case HolyIOT.sflUUID:
			self = .sfl
		case HolyIOT.statusUUID:
			self = .status
		case HolyIOT.powerUUID:
			self = .power
		case HolyIOT.powerAnswerUUID:
			self = .powerAnswer
		default:
			self = .unknown
		}
	}
}
