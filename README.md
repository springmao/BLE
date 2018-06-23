
# Getting started
Open a terminal and input:

    git clone https://github.com/sharypovandrey/HOLYIOT_iOS_SDK.git
    cd HOLYIOT_iOS_SDK/HolyIOT

To run the project input:

	carthage update —platform iOS

(it will update libraries for HolyIOT firmware updates https://github.com/NordicSemiconductor/IOS-Pods-DFU-Library)


# API

Copy folder Core form HOLYIOT_iOS_SDK project to your project

Begin to use:

To monitor the activities of HolyCentralManager implement HolyCentralManagerProtocol delegate and bind it to HolyCentralManager

      HolyCentralManager.shared.delegate = self

Use functions for scanning - startScan и stopScan

	HolyCentralManager.shared.startScan()
	HolyCentralManager.shared.stopScan()

You can connect and disconnect HolyDevice that were founded over delegate method detected

	HolyCentralManager.shared.disconnect(id: device.id)
	HolyCentralManager.shared.connect(id: device.id)

To monitor the life-cycle of HolyDevice and get data from sensors implement HolyDeviceProtocol delegate and bind it to HolyDevice

	device.delegate = self

To enable or disable data transmission use this method:

	device.turnOn()
	device.turnOff()

To enable or disable data transmission for certain sensor use SensorType of this sensor and pass it to function:

	device.setNotifyValue(isOn, for: sensorType)

Instead of SensorType use .accelerometer, .gyroscope, .magnetometer, .barometer, .humidity, .temperature, .sfl,

To update HolyIOT firmware call the function

	device.updateFirmware()

And follow instruction of this library from Nordic Semiconductors https://github.com/NordicSemiconductor/IOS-Pods-DFU-Library
