//
//  ViewController.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 09.01.18.
//

import UIKit
import CoreBluetooth

enum SectionEnum: Int {
    case connected = 0
    case other = 1

    init(deviceState: State) {
        self = deviceState == .connected ? .connected : .other
    }

    init(rawValue: Int) {
        self = rawValue == 0 ? .connected : .other
    }
}

class DeviceListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var scanSwitch: UISwitch!

    var connectedIds: [String] = []

    var otherIds: [String] = []

    var devices: [String: HolyDevice] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
		
		HolyCentralManager.shared.delegate = self
    }
	
	func reset() {
		HolyCentralManager.shared.stopScan()
		scanSwitch.setOn(false, animated: true)
		devices = [:]
		connectedIds = []
		otherIds = []
		tableView.reloadData()
	}
	
	@IBAction func scanSwitchChanged(_ sender: Any) {
		if scanSwitch.isOn {
			HolyCentralManager.shared.startScan()
		} else {
			HolyCentralManager.shared.stopScan()
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DeviceListVC: UITableViewDelegate, UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch SectionEnum(rawValue: section) {
		case .connected:
			return connectedIds.count
		default:
			return otherIds.count
		}
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch SectionEnum(rawValue: section) {
		case .connected:
			return "connected".localized
		default:
			return "others".localized
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let device = deviceForIndexPath(indexPath)
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!

		if device.state == .connected {
			cell.imageView?.image = #imageLiteral(resourceName: "blue_on")
		} else {
			cell.imageView?.image = #imageLiteral(resourceName: "blue_off")
		}

		cell.textLabel?.text = device.name
		cell.detailTextLabel?.text = device.debugDescription
		return cell
	}

	func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		let device = deviceForIndexPath(indexPath)
		router.showDeviceInfoInterface(from: self, device: device)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let device = deviceForIndexPath(indexPath)
		if device.state == .connected {
			HolyCentralManager.shared.disconnect(id: device.id)
		} else {
			HolyCentralManager.shared.connect(id: device.id)
		}
	}
}

extension DeviceListVC {

	func addDevice(_ device: HolyDevice) {

		devices[device.id] = device

		sortDevices()

		let newIndexPath = indexPathForDevice(device)

		tableView.beginUpdates()

		tableView.insertRows(at: [newIndexPath], with: .fade)

		tableView.endUpdates()
	}

	func updatedDeviceWith(id: String) {

		guard let device = devices[id] else {return}

		let previousIndexPath  = indexPathForDevice(device)

		sortDevices()

		let newIndexPath = indexPathForDevice(device)

		tableView.beginUpdates()
		if previousIndexPath != newIndexPath {
			tableView.deleteRows(at: [previousIndexPath], with: .fade)
			tableView.insertRows(at: [newIndexPath], with: .fade)
		} else {
			tableView.reloadRows(at: [previousIndexPath], with: .fade)
		}
		tableView.endUpdates()
	}

	func sortDevices() {

		connectedIds = []
		otherIds = []

		devices.values.forEach { (device) in
			if device.state == .connected {
				connectedIds.append(device.id)
			} else {
				otherIds.append(device.id)
			}
		}

		connectedIds.sort()
		otherIds.sort()
	}

	func deviceForIndexPath(_ indexPath: IndexPath) -> HolyDevice {
		let section = SectionEnum(rawValue: indexPath.section)
		switch section {
		case .connected:
			return devices[connectedIds[indexPath.row]]!
		default:
			return devices[otherIds[indexPath.row]]!
		}
	}

	func indexPathForDevice(_ device: HolyDevice) -> IndexPath {
		if let index = connectedIds.index(of: device.id) {
			return IndexPath(row: index, section: SectionEnum.connected.rawValue)
		} else {
			return IndexPath(row: otherIds.index(of: device.id)!, section: SectionEnum.other.rawValue)
		}
	}
}

extension DeviceListVC: HolyCentralManagerProtocol {

    func detected(device: HolyDevice) {
		addDevice(device)
    }

    func connected(_ deviceId: String) {
        updatedDeviceWith(id: deviceId)
    }

    func disconnected(_ deviceId: String) {
        updatedDeviceWith(id: deviceId)
    }

	func bluetoothPoweredOff() {
		showBlutoothPoweredOffStatusAlert()
	}
}
