//
//  Sensor.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 09.02.18.
//

import UIKit

protocol SensorCellDelegate: NSObjectProtocol {
    func switched(_ sensorCell: SensorCell, type: SensorType, isOn: Bool)
}

class SensorCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var value: UILabel!

    @IBOutlet weak var notifySwitch: UISwitch!

    weak var delegate: SensorCellDelegate?

    var type: SensorType!

    @IBAction func switched(_ sender: UISwitch) {
        delegate?.switched(self, type: type, isOn: sender.isOn)
    }
}
