//
//  TemperatureData.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 05.02.18.
//

import Foundation
import CoreBluetooth

extension CBCharacteristic {

  fileprivate var divider: Float {
    return 100.0
  }

    var temperatureData: Float {
        if let value = value {
            let byteArray = [UInt8](value)
            guard byteArray.count == 7 else {return 0}
            let a = Float(UInt32(byteArray[3]) | UInt32(byteArray[4]) << 8)
            let b = Float(UInt32(byteArray[5]) << 16 | UInt32(byteArray[6]) << 32)
            return (a + b)/divider
        } else {
            return 0
        }
    }
}
