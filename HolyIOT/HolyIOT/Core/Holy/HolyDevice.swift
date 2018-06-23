//
//  HolyDevice.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 09.01.18.
//

import CoreBluetooth

/**
The delegate of a HolyDevice object must adopt the HolyDeviceDelegate protocol. Methods of the protocol allow the delegate to receive different types of holy device data(e.g. accelerometer, barometer, magnetometer and so on) and to monitor the connectivity of the holy device
*/
protocol HolyDeviceProtocol: NSObjectProtocol {

	/**
	Invoked when the peripheral device notifies app's object that the Accelerometer values has changed
	
	- Parameters:
	- holyDevice: The HolyDevice object requesting this information
	- data: Information derived from the characteristic's value provided by the peripheral
	*/
    func holyDevice(_ holyDevice: HolyDevice, didReceiveAccData data: AccelerometerData)

	/**
	Invoked when the peripheral device notifies app's object that the Gyroscope values has changed
	
	- Parameters:
	- holyDevice: The HolyDevice object requesting this information
	- data: Information derived from the characteristic's value provided by the peripheral
	*/
    func holyDevice(_ holyDevice: HolyDevice, didReceiveGyroData data: GyroscopeData)

	/**
	Invoked when the peripheral device notifies app's object that the Magnetometer values has changed
	
	- Parameters:
	- holyDevice: The HolyDevice object requesting this information
	- data: Information derived from the characteristic's value provided by the peripheral
	*/
    func holyDevice(_ holyDevice: HolyDevice, didReceiveMagnetoData data: MagnetometerData)

	/**
	Invoked when the peripheral device notifies app's object that the Barometer value has changed
	
	- Parameters:
	- holyDevice: The HolyDevice object requesting this information
	- data: Information derived from the characteristic's value provided by the peripheral
	*/
    func holyDevice(_ holyDevice: HolyDevice, didReceiveBarometerValue value: Int)

	/**
	Invoked when the peripheral device notifies app's object that the Humidity value has changed
	
	- Parameters:
	- holyDevice: The HolyDevice object requesting this information
	- data: Information derived from the characteristic's value provided by the peripheral
	*/
    func holyDevice(_ holyDevice: HolyDevice, didReceiveHumidityValue value: Float)

	/**
	Invoked when the peripheral device notifies app's object that the Temperature value has changed
	
	- Parameters:
	- holyDevice: The HolyDevice object requesting this information
	- data: Information derived from the characteristic's value provided by the peripheral
	*/
    func holyDevice(_ holyDevice: HolyDevice, didReceiveTemperatureValue value: Float)

	/**
	Invoked when the peripheral device notifies app's object that the SFL values has changed
	
	- Parameters:
	- holyDevice: The HolyDevice object requesting this information
	- data: Information derived from the value
	*/
    func holyDevice(_ holyDevice: HolyDevice, didReceiveSFLData data: SFLData)

	/**
	Tells the delegate that the device was successfully connected
	
	- Parameters:
	- holyDevice: The HolyDevice object informing the delegate of this event
	*/
    func connected(_ holyDevice: HolyDevice)

	/**
	Tells the delegate that the device was disconnected
	
	- Parameters:
	- holyDevice: The HolyDevice object informing the delegate of this event
	*/
    func disconnected(_ holyDevice: HolyDevice)
	
	/**
	Tells the delegate that the device sensor with given SensorType is active
	
	- Parameters:
	- holyDevice: The HolyDevice object informing the delegate of this event
	- sensorType: The type of sersor which ready to receive commands
	*/
	func sensorReady(_ holyDevice: HolyDevice, sensorType: SensorType)
}

class HolyDevice: Device {

    fileprivate var accelerometerRange: AccelerometerRange = AccelerometerRange.ACC_2G

    fileprivate var gyroscopeRange: GyroscopeRange = GyroscopeRange.GYRO_2000

    fileprivate var magnetometerRange: MagnetometerRange = MagnetometerRange.MAGNETO_2000

	weak var delegate: HolyDeviceProtocol? {
		didSet {
			requestSensorsReadiness()
		}
	}
	
	var sensorTypes: [SensorType] = [.power, .accelerometer, .gyroscope, .magnetometer, .barometer, .humidity, .temperature, .sfl]

    override func connected() {
        super.connected()
        delegate?.connected(self)
    }

    override func disconnected() {
        super.disconnected()
        delegate?.disconnected(self)
    }

    override func discoverSensor(_ sensor: Sensor) {
		delegate?.sensorReady(self, sensorType: sensor.sensorType)
    }

    override func didUpdateValueFor(_ sensor: Sensor) {
        switch sensor.sensorType {
        case .accelerometer:
            delegate?.holyDevice(self, didReceiveAccData: sensor.fetchAccelerometerData(accelerometerRange))
            break
        case .gyroscope:
            delegate?.holyDevice(self, didReceiveGyroData: sensor.fetchGyroscopeData(gyroscopeRange))
            break
        case .magnetometer:
            delegate?.holyDevice(self, didReceiveMagnetoData: sensor.fetchMagnetometerData(magnetometerRange))
            break
        case .barometer:
            delegate?.holyDevice(self, didReceiveBarometerValue: sensor.barometerData)
            break
        case .humidity:
            delegate?.holyDevice(self, didReceiveHumidityValue: sensor.humidityData)
            break
        case .temperature:
            delegate?.holyDevice(self, didReceiveTemperatureValue: sensor.temperatureData)
            break
        case .sfl:
            delegate?.holyDevice(self, didReceiveSFLData: sensor.sflData)
            break
        default:
            break
        }
    }
	
	func requestSensorsReadiness() {
		guard let delegate = delegate else { return }
		for sensorType in sensorTypes {
			if isSensorTypeReady(sensorType) {
				delegate.sensorReady(self, sensorType: sensorType)
			}
		}
	}
}
