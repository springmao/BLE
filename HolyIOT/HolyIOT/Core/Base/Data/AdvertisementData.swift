//
//  AdvertisementData.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 06.02.18.
//

import Foundation
import CoreBluetooth

/**
Struct describing human readable advertisement values
*/
public struct AdvertisementData {

    let advertisements: [String: Any]

    init(_ advertisements: [String: Any]) {
        self.advertisements = advertisements
    }

    public var localName: String? {
        return self.advertisements[CBAdvertisementDataLocalNameKey] as? String
    }

    public var manufacturerData: Data? {
        return self.advertisements[CBAdvertisementDataManufacturerDataKey] as? Data
    }

    public var txPower: NSNumber? {
        return self.advertisements[CBAdvertisementDataTxPowerLevelKey] as? NSNumber
    }

    public var isConnectable: NSNumber? {
        return self.advertisements[CBAdvertisementDataIsConnectable] as? NSNumber
    }

    public var serviceUUIDs: [CBUUID]? {
        return self.advertisements[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID]
    }

    public var serviceData: [CBUUID: Data]? {
        return self.advertisements[CBAdvertisementDataServiceDataKey] as? [CBUUID: Data]
    }

    public var overflowServiceUUIDs: [CBUUID]? {
        return self.advertisements[CBAdvertisementDataOverflowServiceUUIDsKey] as? [CBUUID]
    }

    public var solicitedServiceUUIDs: [CBUUID]? {
        return self.advertisements[CBAdvertisementDataSolicitedServiceUUIDsKey] as? [CBUUID]
    }
}
