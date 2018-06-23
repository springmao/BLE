//
//  DataChartViewController.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 29.04.2018.
//

import UIKit

enum DataChartType {
	case accelerometer, gyroscope, magnetometer
}

class DataChartViewController: UIViewController {

	var device: HolyDevice!

	var dataChartType: DataChartType = .accelerometer

	var range: Range!

	@IBOutlet weak var dataChartView: DataChartView!

	@IBOutlet weak var firstLegendView: UILabel!

	@IBOutlet weak var secondLegendView: UILabel!

	@IBOutlet weak var thirdLegendView: UILabel!

	let firstColor = UIColor.red

	let secondColor = UIColor.purple

	let thirdColor = UIColor.green

	override func viewDidLoad() {
		super.viewDidLoad()

		firstLegendView.textColor = firstColor

		secondLegendView.textColor = secondColor

		thirdLegendView.textColor = thirdColor

		dataChartView.addChart("X", firstColor)

		dataChartView.addChart("Y", secondColor)

		dataChartView.addChart("Z", thirdColor)

		dataChartView.threshold = CGFloat(range.ratio)

		dataChartView.unit = range.unit

	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		device.delegate = self
	}
}

extension DataChartViewController: HolyDeviceProtocol {
	func holyDevice(_ holyDevice: HolyDevice, didReceiveAccData data: AccelerometerData) {
		if dataChartType == .accelerometer {
			dataChartView.addValue(name: "X", data.x)
			dataChartView.addValue(name: "Y", data.y)
			dataChartView.addValue(name: "Z", data.z)

			firstLegendView.text = String(format: "X: %.2f\(range.unit)", data.x)

			secondLegendView.text = String(format: "Y: %.2f\(range.unit)", data.y)

			thirdLegendView.text = String(format: "Z: %.2f\(range.unit)", data.z)

			dataChartView.setNeedsDisplay()
		}
	}

	func holyDevice(_ holyDevice: HolyDevice, didReceiveGyroData data: GyroscopeData) {
		if dataChartType == .gyroscope {
			dataChartView.addValue(name: "X", data.x)
			dataChartView.addValue(name: "Y", data.y)
			dataChartView.addValue(name: "Z", data.z)

			firstLegendView.text = "X: \(Int(data.x))\(range.unit)"

			secondLegendView.text = "Y: \(Int(data.y))\(range.unit)"

			thirdLegendView.text = "Z: \(Int(data.z))\(range.unit)"

			dataChartView.setNeedsDisplay()
		}
	}

	func holyDevice(_ holyDevice: HolyDevice, didReceiveMagnetoData data: MagnetometerData) {
		if dataChartType == .magnetometer {
			dataChartView.addValue(name: "X", data.x)
			dataChartView.addValue(name: "Y", data.y)
			dataChartView.addValue(name: "Z", data.z)

			firstLegendView.text = "X: \(data.x)\(range.unit)"

			secondLegendView.text = "Y: \(data.y)\(range.unit)"

			thirdLegendView.text = "Z: \(data.z)\(range.unit)"

			dataChartView.setNeedsDisplay()
		}
	}

	func holyDevice(_ holyDevice: HolyDevice, didReceiveBarometerValue value: Int) {

	}

	func holyDevice(_ holyDevice: HolyDevice, didReceiveHumidityValue value: Float) {

	}

	func holyDevice(_ holyDevice: HolyDevice, didReceiveTemperatureValue value: Float) {

	}

	func connected(_ holyDevice: HolyDevice) {

	}

	func disconnected(_ holyDevice: HolyDevice) {

	}
	
	func sensorReady(_ holyDevice: HolyDevice, sensorType: SensorType) {
		
	}

	func holyDevice(_ holyDevice: HolyDevice, didReceiveSFLData data: SFLData) {

	}
}
