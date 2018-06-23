//
//  HolyCentralManager.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 09.01.18.
//
import CoreBluetooth
import UIKit

/**
The HolyCentralManagerProtocol protocol defines the methods that a delegate of a HolyCentralManager object must adopt. The methods of the protocol allow the delegate to monitor the discovery, connectivity, retrieval of peripheral devices and bluetooth powered off alert.
*/
protocol HolyCentralManagerProtocol: NSObjectProtocol {

	/**
	Invoked when the holy central manager discovers a device while scanning
	*/
    func detected(device: HolyDevice)

	/**
	Invoked when a connection is successfully created with a peripheral
	*/
    func connected(_ deviceId: String)

	/**
	Invoked when an existing connection with a peripheral is torn down
	*/
    func disconnected(_ deviceId: String)

	/**
	Invoked when the state of the central manager is powered off
	*/
    func bluetoothPoweredOff()
}

/**
HolyCentralManager objects are used to manage discovered or connected remote holy devices (represented by HolyDevice objects), including scanning for, discovering, and connecting to devices.
*/
class HolyCentralManager: NSObject {

    typealias WeakRefDevice = WeakRef<Device>

	/**
	Entry point to the central role
	*/
    var centralManager: CBCentralManager!

	/**
	Dictionary of discovered holy devices
	*/
    private var devices: [String: WeakRefDevice] = [:]

	/**
	The delegate object that will receive holy central events
	*/
    weak var delegate: HolyCentralManagerProtocol?

    private override init() {
        super.init()
        let options = [CBCentralManagerOptionShowPowerAlertKey: true]
        centralManager = CBCentralManager(delegate: self, queue: nil, options: options)

    }

    public static let shared = HolyCentralManager()

	/**
	Add new device to devices dictionary
	if device is not exist there
	
	except that it will return false if the device was added earlier
	
	- Parameters:
	- device: The HolyDevice to add to devices dictionary
	
	- Returns: true if device successfully added
	*/
    func addDevice(device: HolyDevice) -> Bool {
        devices = devices.filter { $0.value.value != nil } //clear dict from empty elements
        if devices[device.id] != nil {return false}
        devices[device.id] = WeakRefDevice(value: device)
        return true
    }

	/**
	Returns the device whose id matches the specified value.
	
	except that it will return nil if the device does not exist
	
	- Parameters:
	- id: The id value to search for
	
	- Returns: The device in the devices dictionary whose id property matches the value in the id parameter
	*/
    func deviceWith(id: String) -> Device? {
        if let wrapper = devices[id] {
            return wrapper.value
        } else {
            return nil
        }
    }
}

/**
The HolyConnectDelegate protocol defines methods to connect or disconnect device with id.
*/
protocol HolyConnectDelegate: NSObjectProtocol {
	/**
	Initiates a connection to device with given <i>id</i>
	*/
    func connect(id: String)

	/**
	Cancels an active or pending connection to device with given <i>id</i>
	*/
    func disconnect(id: String)
}

/**
The HolyConnectDelegate protocol defines methods to scan devices.
*/
protocol HolyScanDelegate: NSObjectProtocol {

	/**
	Starts scanning for devices
	*/
    func startScan()

	/**
	Stops scanning for devices
	*/
    func stopScan()
}

extension HolyCentralManager: CBCentralManagerDelegate, HolyScanDelegate, HolyConnectDelegate {

    func connect(id: String) {
        let peripherals = centralManager.retrievePeripherals(withIdentifiers: [UUID(uuidString: id)!])
        if peripherals.count > 0 {
            centralManager.connect(peripherals[0], options: nil)
        }
    }

    func disconnect(id: String) {
        let peripherals = centralManager.retrievePeripherals(withIdentifiers: [UUID(uuidString: id)!])
        if peripherals.count > 0 {
            centralManager.cancelPeripheralConnection(peripherals[0])
        }
    }

    func stopScan() {
        centralManager.stopScan()
    }

    func startScan() {
        centralManager.scanForPeripherals(withServices: [HolyIOT.cbuuid], options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        if let device = deviceWith(id: peripheral.id) {
            device.connected()
        }
        delegate?.connected(peripheral.id)
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let device = deviceWith(id: peripheral.id) {
            device.disconnected()
        }
        delegate?.disconnected(peripheral.id)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        let device = HolyDevice(peripheral: peripheral, advertisementData: advertisementData, rssi: RSSI)
        if addDevice(device: device) {
            delegate?.detected(device: device)
        }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOff {
            delegate?.bluetoothPoweredOff()
        }
    }
}
