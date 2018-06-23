//
//  DeviceVC.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 09.01.18.
//

import UIKit

class DeviceVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!

	@IBOutlet weak var connectionSwitch: UISwitch!

	@IBOutlet weak var sensorDataSwitch: UISwitch!

	@IBOutlet weak var updateFirmwareButton: UIButton!

	var device: HolyDevice!

	override func viewDidLoad() {
		super.viewDidLoad()
		title = device.name ?? "no name".localized
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updateFirmwareButton.isEnabled = device.state == .connected
		connectionSwitch.setOn(device.state == .connected, animated: true)
		if device.state != .connected {
			sensorDataSwitch.setOn(false, animated: true)
			tableView.switchOffAll()
		}
		device.delegate = self
	}

	@IBAction func updateFirmware(_ sender: Any) {
		router.showFirmwareUpdateInterface(from: self, device: device)
	}

	@IBAction func connectionSwitched(_ sender: UISwitch) {
		if sender.isOn {
			HolyCentralManager.shared.connect(id: device.id)
		} else {
			HolyCentralManager.shared.disconnect(id: device.id)
		}
	}

	@IBAction func sensorDataSwitched(_ sender: UISwitch) {
		if sender.isOn {
			if !device.turnOn() {
				sensorDataSwitch.setOn(false, animated: true)
			}
		} else {
			device.turnOff()
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 7
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let sersorCell = tableView.dequeueCell(SensorCell.self)
		sersorCell.delegate = self
		switch indexPath.row {
		case 0:
			sersorCell.name.text = "Accelerometer"
			sersorCell.type = SensorType.accelerometer
			break
		case 1:
			sersorCell.name.text = "Gyroscope"
			sersorCell.type = SensorType.gyroscope
			break
		case 2:
			sersorCell.name.text = "Magnetometer"
			sersorCell.type = SensorType.magnetometer
			break
		case 3:
			sersorCell.name.text = "Barometer"
			sersorCell.type = SensorType.barometer
			break
		case 4:
			sersorCell.name.text = "Humidity"
			sersorCell.type = SensorType.humidity
			break
		case 5:
			sersorCell.name.text = "Temperature"
			sersorCell.type = SensorType.temperature
			break
		case 6:
			sersorCell.name.text = "SFL"
			sersorCell.type = SensorType.sfl
			break
		default:
			fatalError("unknown sensor type cell")
			break
		}
		sersorCell.selectionStyle = .none
		return sersorCell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.row {
		case 0:
			router.showDataChartInterface(from: self, device: device, sensor: .accelerometer, range: AccelerometerData.dafaultRange)
			break
		case 1:
			router.showDataChartInterface(from: self, device: device, sensor: .gyroscope, range: GyroscopeData.dafaultRange)
			break
		case 2:
			router.showDataChartInterface(from: self, device: device, sensor: .magnetometer, range: MagnetometerData.defaultRange)
			break
		case 6:
			router.showSceneInterface(from: self, device: device)
			break
		default:
			break
		}
	}

}

extension DeviceVC: SensorCellDelegate {
	func switched(_ sensorCell: SensorCell, type: SensorType, isOn: Bool) {
		device.setNotifyValue(isOn, for: type)
	}
}

extension DeviceVC: HolyDeviceProtocol {
	func connected(_ holyDevice: HolyDevice) {
		connectionSwitch.setOn(true, animated: true)
		updateFirmwareButton.isEnabled = true
	}

	func disconnected(_ holyDevice: HolyDevice) {
		connectionSwitch.setOn(false, animated: true)
		sensorDataSwitch.setOn(false, animated: true)
		updateFirmwareButton.isEnabled = false
		tableView.switchOffAll()
	}

	func holyDevice(_ holyDevice: HolyDevice, didReceiveAccData data: AccelerometerData) {
		tableView.sensorCell(for: 0)?.value.text = data.description
	}

	func holyDevice(_ holyDevice: HolyDevice, didReceiveGyroData data: GyroscopeData) {
		tableView.sensorCell(for: 1)?.value.text = data.description
	}

	func holyDevice(_ holyDevice: HolyDevice, didReceiveMagnetoData data: MagnetometerData) {
		tableView.sensorCell(for: 2)?.value.text = data.description
	}

	func holyDevice(_ holyDevice: HolyDevice, didReceiveBarometerValue value: Int) {
		tableView.sensorCell(for: 3)?.value.text = "\(value)" + "Pa"
	}

	func holyDevice(_ holyDevice: HolyDevice, didReceiveHumidityValue value: Float) {
		tableView.sensorCell(for: 4)?.value.text = String(format: "%.3f", value) + "%"
	}

	func holyDevice(_ holyDevice: HolyDevice, didReceiveTemperatureValue value: Float) {
		tableView.sensorCell(for: 5)?.value.text = String(format: "%.3f", value) + "℃"
	}

	func holyDevice(_ holyDevice: HolyDevice, didReceiveSFLData data: SFLData) {
		tableView.sensorCell(for: 6)?.value.text = data.description
	}
	
	func sensorReady(_ holyDevice: HolyDevice, sensorType: SensorType) {
		
	}
}

extension UITableView {
	func sensorCell(for row: Int) -> SensorCell? {
		let indexPath = IndexPath(row: row, section: 0)
		return cell(SensorCell.self, for: indexPath)
	}

	func switchOffAll() {
		for row in 0..<numberOfRows(inSection: 0) {
			sensorCell(for: row)?.notifySwitch.setOn(false, animated: true)
		}
	}
}
