//
//  MagnetometerData.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 05.02.18.
//

import Foundation
import CoreBluetooth

enum MagnetometerRange: Int, Range {

	case MAGNETO_2000 = 0
	case MAGNETO_1000 = 1
	case MAGNETO_500 = 2
	case MAGNETO_250 = 3
	case MAGNETO_125 = 4

	var ratio: Float {
		switch self {
		case .MAGNETO_2000:
			return 2000.0
		case .MAGNETO_1000:
			return 1000.0
		case .MAGNETO_500:
			return 500.0
		case .MAGNETO_250:
			return 250.0
		case .MAGNETO_125:
			return 125.0
		}
	}

	var unit: String {
		return "uT"
	}

	var min: Float {
		return -ratio
	}

	var max: Float {
		return ratio
	}
}

struct MagnetometerData: CustomStringConvertible {

	let x: Float
	let y: Float
	let z: Float

	static let defaultRange = MagnetometerRange.MAGNETO_2000

	let range: MagnetometerRange

	var isEmpty: Bool {
		return x == 0 && y == 0 && z == 0
	}

	init() {
		x = 0
		y = 0
		z = 0
		range = MagnetometerData.defaultRange
	}

	init(x: Float, y: Float, z: Float, range: MagnetometerRange) {
		self.x = x
		self.y = y
		self.z = z
		self.range = range
	}

	var description: String {
		return "x:\(Int(x))\(range.unit), " +
			"y:\(Int(y))\(range.unit), " +
			"z:\(Int(z))\(range.unit), " +
			"min:\(Int(range.min))\(range.unit), " +
		"max:\(Int(range.max))\(range.unit)"
	}
}

extension CBCharacteristic {

	func fetchMagnetometerData(_ range: MagnetometerRange = MagnetometerData.defaultRange) -> MagnetometerData {
		if let value = value {
			let byteArray = [UInt8](value)
			guard byteArray.count == 9 else {return MagnetometerData()}
			let x = Float(Int16(byteArray[3]) | Int16(byteArray[4]) << 8)
			let y = Float(Int16(byteArray[5]) | Int16(byteArray[6]) << 8)
			let z = Float(Int16(byteArray[7]) | Int16(byteArray[8]) << 8)
			return MagnetometerData(x: x, y: y, z: z, range: range)
		} else {
			return MagnetometerData()
		}
	}
}
