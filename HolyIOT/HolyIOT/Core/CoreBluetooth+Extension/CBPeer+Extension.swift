//
//  CBPeer+Extension.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 20.05.2018.
//

import CoreBluetooth

extension CBPeer {
	var id: String {
		return identifier.uuidString
	}
}
