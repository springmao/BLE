//
//  CBDescriptor+Extension.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 20.05.2018.
//

import CoreBluetooth

extension CBDescriptor {
	open override var debugDescription: String {
		return """
		Dvalue \(value != nil)
		"""
	}
}
