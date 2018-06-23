//
//  GyroscopeData.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 05.02.18.
//

import Foundation
import CoreBluetooth

enum GyroscopeRange: Int, Range {

	case GYRO_2000 = 0
	case GYRO_1000 = 1
	case GYRO_500 = 2
	case GYRO_250 = 3
	case GYRO_125 = 4

	var ratio: Float {
		switch self {
		case .GYRO_2000:
			return 2000.0
		case .GYRO_1000:
			return 1000.0
		case .GYRO_500:
			return 500.0
		case .GYRO_250:
			return 250.0
		case .GYRO_125:
			return 125.0
		}
	}

	var unit: String {
		return "d/s"
	}

	var min: Float {
		return -ratio
	}

	var max: Float {
		return ratio
	}
}

struct GyroscopeData: CustomStringConvertible {

	let x: Float
	let y: Float
	let z: Float

	static let dafaultRange = GyroscopeRange.GYRO_2000

	let range: GyroscopeRange

	var isEmpty: Bool {
		return x == 0 && y == 0 && z == 0
	}

	init() {
		self.init(x: 0, y: 0, z: 0)
	}

	init(x: Float, y: Float, z: Float) {
		self.init(x: 0, y: 0, z: 0, range: GyroscopeData.dafaultRange)
	}

	init(x: Float, y: Float, z: Float, range: GyroscopeRange) {
		self.x = x
		self.y = y
		self.z = z
		self.range = range
	}

	init(rawX: Float, rawY: Float, rawZ: Float) {
		self.init(rawX: rawX, rawY: rawY, rawZ: rawZ, range: .GYRO_2000)
	}

	init(rawX: Float, rawY: Float, rawZ: Float, range: GyroscopeRange) {
		self.x = rawX * range.ratio
		self.y = rawY * range.ratio
		self.z = rawZ * range.ratio
		self.range = range
	}

	var description: String {
		return "ox:\(Int(x))\(range.unit), " +
			"oy:\(Int(y))\(range.unit), " +
			"oz:\(Int(z))\(range.unit), " +
			"min:\(Int(range.min))\(range.unit), " +
		"max:\(Int(range.max))\(range.unit)"
	}
}

extension CBCharacteristic {

	fileprivate var divider: Float {
		return 32768.0
	}

	func fetchGyroscopeData(_ range: GyroscopeRange = .GYRO_2000) -> GyroscopeData {
		if let value = value {
			let byteArray = [UInt8](value)
			guard byteArray.count == 9 else {return GyroscopeData()}
			let rawX = Float(Int16(byteArray[3]) | Int16(byteArray[4]) << 8) / divider
			let rawY = Float(Int16(byteArray[5]) | Int16(byteArray[6]) << 8) / divider
			let rawZ = Float(Int16(byteArray[7]) | Int16(byteArray[8]) << 8) / divider
			return GyroscopeData(rawX: rawX, rawY: rawY, rawZ: rawZ, range: range)
		} else {
			return GyroscopeData()
		}
	}
}
