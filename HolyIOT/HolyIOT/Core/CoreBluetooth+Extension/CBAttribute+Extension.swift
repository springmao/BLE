//
//  CBAttribute+Extension.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 20.05.2018.
//

import CoreBluetooth

extension CBAttribute {
	var id: String {
		return uuid.uuidString
	}
}
