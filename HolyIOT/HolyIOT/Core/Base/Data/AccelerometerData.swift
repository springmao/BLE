//
//  AccelerometerData.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 05.02.18.
//

import Foundation
import CoreBluetooth

enum AccelerometerRange: Int, Range {

	case ACC_2G = 3
	case ACC_4G = 5
	case ACC_8G = 8
	case ACC_16G = 12

	var ratio: Float {
		switch self {
		case .ACC_2G:
			return 2.0
		case .ACC_4G:
			return 4.0
		case .ACC_8G:
			return 8.0
		case .ACC_16G:
			return 16.0
		}
	}

	var unit: String {
		return "G"
	}

	var min: Float {
		return -ratio
	}

	var max: Float {
		return ratio
	}
}

struct AccelerometerData: CustomStringConvertible {

	let x: Float
	let y: Float
	let z: Float

	static let dafaultRange = AccelerometerRange.ACC_2G

	let range: AccelerometerRange

	var isEmpty: Bool {
		return x == 0 && y == 0 && z == 0
	}

	init() {
		self.init(x: 0, y: 0, z: 0)
	}

	init(x: Float, y: Float, z: Float) {
		self.init(x: 0, y: 0, z: 0, range: AccelerometerData.dafaultRange)
	}

	init(x: Float, y: Float, z: Float, range: AccelerometerRange) {
		self.x = x
		self.y = y
		self.z = z
		self.range = range
	}

	init(rawX: Float, rawY: Float, rawZ: Float) {
		self.init(rawX: rawX, rawY: rawY, rawZ: rawZ, range: .ACC_2G)
	}

	init(rawX: Float, rawY: Float, rawZ: Float, range: AccelerometerRange) {
		self.x = rawX * range.ratio
		self.y = rawY * range.ratio
		self.z = rawZ * range.ratio
		self.range = range
	}

	var description: String {
		return String(format: "x: %.2f\(range.unit), " +
			"y: %.2f\(range.unit), " +
			"z: %.2f\(range.unit), " +
			"min: %d\(range.unit), " +
			"max: %d\(range.unit)", x, y, z, Int(range.min), Int(range.max))
	}
}

extension CBCharacteristic {

	fileprivate var divider: Float {
		return 32768.0
	}

	func fetchAccelerometerData(_ range: AccelerometerRange = AccelerometerRange.ACC_2G) -> AccelerometerData {

		if let value = value {
			let byteArray = [UInt8](value)
			guard byteArray.count == 9 else {return AccelerometerData()}
			let rawX = Float(Int16(byteArray[3]) | Int16(byteArray[4]) << 8) / divider
			let rawY = Float(Int16(byteArray[5]) | Int16(byteArray[6]) << 8) / divider
			let rawZ = Float(Int16(byteArray[7]) | Int16(byteArray[8]) << 8) / divider
			return AccelerometerData(rawX: rawX, rawY: rawY, rawZ: rawZ, range: range)
		} else {
			return AccelerometerData()
		}
	}
}
