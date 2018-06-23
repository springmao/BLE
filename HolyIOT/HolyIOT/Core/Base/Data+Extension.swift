//
//  Data+Extension.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 11.01.18.
//

import Foundation

extension Data {

	/**
	Computed property convert the data to Int16
	
	Except that it will return 0 if the bytes count is different from 2
	*/
	var int16Value: Int16 {
		let byteArray = [UInt8](self)
		guard byteArray.count == 2 else { return 0 }
		return (Int16(byteArray[0]) | Int16(byteArray[1]) << 8)
	}

	static func dataWithValue(value: Int16) -> Data {
		var variableValue = value
		return Data(buffer: UnsafeBufferPointer(start: &variableValue, count: 1))
	}
}

extension Data {

	/**
	Computed property convert the data to Int8
	
	Except that it will take only first byte of data
	*/
	var int8Value: Int8 {
		return Int8(bitPattern: self[0])
	}

    static func dataWithValue(value: Int8) -> Data {
        var variableValue = value
        return Data(buffer: UnsafeBufferPointer(start: &variableValue, count: 1))
    }
}

extension Data {
	func hexEncodedString() -> String {
		return map { String(format: "%02hhx", $0) }.joined()
	}
}
