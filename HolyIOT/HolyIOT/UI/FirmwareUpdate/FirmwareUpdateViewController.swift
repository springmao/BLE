//
//  FirmwareUpdateViewController.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 18.05.2018.
//

import CoreBluetooth
import iOSDFULibrary
import UIKit

class FirmwareUpdateViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {

	// MARK: - Class Properties
	fileprivate var dfuPeripheral: CBPeripheral!

	fileprivate var dfuController: DFUServiceController?

	fileprivate var selectedFirmware: DFUFirmware? {
		didSet {
			if selectedFirmware != nil {
				stopProcessButton.isHidden = false
				stopProcessButton.setTitle("Start process", for: .normal)
			} else {
				stopProcessButton.isHidden = true
			}
		}
	}

	var device: HolyDevice!

	@IBOutlet weak var dfuActivityIndicator: UIActivityIndicatorView!

	@IBOutlet weak var dfuStatusLabel: UILabel!

	@IBOutlet weak var peripheralNameLabel: UILabel!

	@IBOutlet weak var dfuUploadProgressView: UIProgressView!

	@IBOutlet weak var dfuUploadStatus: UILabel!

	@IBOutlet weak var findFileOnPasteboardButton: UIButton!
	
	@IBOutlet weak var stopProcessButton: UIButton!

	var centralManager: CBCentralManager!

    override func viewDidLoad() {
        super.viewDidLoad()

		centralManager = CBCentralManager(delegate: self, queue: nil)
    }

	// MARK: - View Actions
	@IBAction func findFileButtonTapped(_ sender: Any) {
		
		guard selectedFirmware == nil else { return }
		
		if let data = UIPasteboard.general.data(forPasteboardType: "public.zip-archive"),
			let firmware = DFUFirmware(zipFile: data),
			firmware.valid {
			selectedFirmware = firmware
			findFileOnPasteboardButton.setTitle("File finded successfully", for: .normal)
		} else {
			print("no data")
			findFileOnPasteboardButton.setTitle("Find firmware file on pasteboard", for: .normal)
			showNoFirmwareFileWarning()
		}
	}
	
	@IBAction func stopProcessButtonTapped(_ sender: AnyObject) {
		guard let dfuController = dfuController else {
			print("No DFU peripheral was set")
			if selectedFirmware != nil {
				device.updateFirmware()
			}
			return
		}
		
		if dfuController.aborted {
			dfuController.restart()
		} else {
			print("Action: DFU paused")
			dfuController.pause()
			
			showStopProcessWarning({
				print("Action: DFU aborted")
				_ = self.dfuController?.abort()
			}) {
				print("Action: DFU resumed")
				self.dfuController?.resume()
			}
		}
	}

	func setCentralManager(_ centralManager: CBCentralManager) {
		self.centralManager = centralManager
	}

	func setTargetPeripheral(_ targetPeripheral: CBPeripheral) {
		self.dfuPeripheral = targetPeripheral
	}

	func startDFUProcess() {
		guard dfuPeripheral != nil else {
			print("No DFU peripheral was set")
			return
		}

		let dfuInitiator = DFUServiceInitiator(centralManager: centralManager!, target: dfuPeripheral!)
		dfuInitiator.delegate = self
		dfuInitiator.progressDelegate = self
		dfuInitiator.logger = self
		// Starting from iOS 11 there is a new API that removes the need of PRNs.
		// However, some devices may still work better with them enabled! A specially those
		// based on SDK older than 8.0 where the flash saving was slower and modern phones
		// can send data faster then that which causes the DFU bootloader to abort with an error.
		if #available(iOS 11.0, macOS 10.13, *) {
			dfuInitiator.packetReceiptNotificationParameter = 0
		}

		// This enables the experimental Buttonless DFU feature from SDK 12.
		// Please, read the field documentation before use.
		dfuInitiator.enableUnsafeExperimentalButtonlessServiceInSecureDfu = true

		dfuController = dfuInitiator.with(firmware: selectedFirmware!).start()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		dfuActivityIndicator.startAnimating()
		dfuUploadProgressView.progress = 0.0
		dfuUploadStatus.text = ""
		dfuStatusLabel.text  = ""
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		_ = dfuController?.abort()
		dfuController = nil
	}

	// MARK: - CBCentralManagerDelegate

	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		print("CM did update state: \(central.state.rawValue)")
		centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerRestoredStateScanOptionsKey: true])
	}

	func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		let name = peripheral.name ?? "Unknown"
		print("Connected to peripheral: \(name)")
		peripheral.delegate = self
		peripheral.discoverServices(nil)

		if dfuPeripheral == peripheral {
			peripheralNameLabel.text = "Flashing \(dfuPeripheral.name ?? "no name")..."
			startDFUProcess()

		}
	}

	func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
		print("pereph \(peripheral)")
		if peripheral.name == "DfuTarg" {
			dfuPeripheral = peripheral
			centralManager.connect(dfuPeripheral!)

		}
	}

	func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
		let name = peripheral.name ?? "Unknown"
		print("Disconnected from peripheral: \(name)")
	}
}

extension FirmwareUpdateViewController: DFUServiceDelegate, DFUProgressDelegate, LoggerDelegate {

	// MARK: - DFUServiceDelegate

	func dfuStateDidChange(to state: DFUState) {
		switch state {
		case .completed, .disconnecting:
			self.dfuActivityIndicator.stopAnimating()
			self.dfuUploadProgressView.setProgress(0, animated: false)
			self.stopProcessButton.setTitle("Start process", for: .normal)
			self.stopProcessButton.isEnabled = false
		case .aborted:
			self.dfuActivityIndicator.stopAnimating()
			self.dfuUploadProgressView.setProgress(0, animated: true)
			self.stopProcessButton.setTitle("Restart process", for: .normal)
			self.stopProcessButton.isEnabled = true
		default:
			stopProcessButton.setTitle("Stop process", for: .normal)
			self.stopProcessButton.isEnabled = true
		}

		dfuStatusLabel.text = state.description()
		print("Changed state to: \(state.description())")

		// Forget the controller when DFU is done
		if state == .completed {
			dfuController = nil
			showSuccess {
				if let controllers = self.navigationController?.viewControllers {
					for controller in controllers {
						if let controller = controller as? DeviceListVC {
							controller.reset()
						}
					}
				}
				self.navigationController?.popToRootViewController(animated: true)
			}
		}
	}

	func dfuError(_ error: DFUError, didOccurWithMessage message: String) {
		dfuStatusLabel.text = "Error \(error.rawValue): \(message)"
		dfuActivityIndicator.stopAnimating()
		dfuUploadProgressView.setProgress(0, animated: true)
		print("Error \(error.rawValue): \(message)")

		// Forget the controller when DFU finished with an error
		dfuController = nil
	}

	// MARK: - DFUProgressDelegate

	func dfuProgressDidChange(for part: Int, outOf totalParts: Int, to progress: Int, currentSpeedBytesPerSecond: Double, avgSpeedBytesPerSecond: Double) {
		dfuUploadProgressView.setProgress(Float(progress)/100.0, animated: true)
		dfuUploadStatus.text = String(format: "Part: %d/%d\nSpeed: %.1f KB/s\nAverage Speed: %.1f KB/s",
									  part, totalParts, currentSpeedBytesPerSecond/1024, avgSpeedBytesPerSecond/1024)
	}

	// MARK: - LoggerDelegate

	func logWith(_ level: LogLevel, message: String) {
		print("\(level.name()): \(message)")
	}
}
