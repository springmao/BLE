//
//  PowerCommand.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 05.02.18.
//

enum PowerCommand: Int8 {
    case turnOff = 0x00
    case turnOn = 0x01
    case writeSettigns = 0x10
    case readSettings = 0x11
}
