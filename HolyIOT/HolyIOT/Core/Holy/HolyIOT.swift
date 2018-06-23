//
//  HolyIOT.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 05.02.18.
//

import Foundation
import CoreBluetooth

/**
HolyIOT

Represents a HolyIOT's constants.
 */
final class HolyIOT {

    static let advertisementServiceUUID = "6E400000-B5A3-F393-E0A9-E50E24DCCA9E"

    static let deviceName: String = "Holy-IOT"

    static let serviceUUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
    static let accelerometerUUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
    static let gyroscopeUUID = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
    static let magnetometerUUID = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
    static let barometerUUID = "6E400004-B5A3-F393-E0A9-E50E24DCCA9E"
    static let humidityUUID = "6E400005-B5A3-F393-E0A9-E50E24DCCA9E"
    static let temperatureUUID = "6E400006-B5A3-F393-E0A9-E50E24DCCA9E"
    static let sflUUID = "6E400007-B5A3-F393-E0A9-E50E24DCCA9E"
    static let statusUUID = "6E400008-B5A3-F393-E0A9-E50E24DCCA9E"
    static let powerUUID = "6E400009-B5A3-F393-E0A9-E50E24DCCA9E"
    static let powerAnswerUUID = "6E40000A-B5A3-F393-E0A9-E50E24DCCA9E"

    static var cbuuid: CBUUID {
        return CBUUID(string: advertisementServiceUUID)
    }
}
