//
//  AppDelegate+Router.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 10.01.18.
//
import UIKit

extension UIApplicationDelegate {

    var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }

    /**
     Show device info
     
     - Parameters:
     - viewController: viewController
     - device: device
     */

    func showDeviceInfoInterface<C: UIViewController>(from viewController: C, device: HolyDevice) {
        let vc = mainStoryboard.instantiate(DeviceVC.self)
        vc.device = device
        viewController.show(vc, sender: nil)
    }

    /**
     Show device info

     - Parameters:
     - viewController: viewController
     - device: device
     */

    func showSceneInterface<C: UIViewController>(from viewController: C, device: HolyDevice) {
        let vc = mainStoryboard.instantiate(SceneVC.self)
        vc.device = device
        viewController.show(vc, sender: nil)
    }

	/**
	Show device data chart
	
	- Parameters:
	- viewController: viewController
	- device: device
	- sensor type: accelerometer, gyroscope or magnetometer
	- range: range
	*/

	func showDataChartInterface<C: UIViewController>(from viewController: C, device: HolyDevice, sensor type: DataChartType, range: Range) {
		let vc = mainStoryboard.instantiate(DataChartViewController.self)
		vc.device = device
		vc.dataChartType = type
		vc.range = range
		viewController.show(vc, sender: nil)
	}

	/**
	Show firmware update
	
	- Parameters:
	- viewController: viewController
	- device: device
	*/

	func showFirmwareUpdateInterface<C: UIViewController>(from viewController: C, device: HolyDevice) {
		let vc = mainStoryboard.instantiate(FirmwareUpdateViewController.self)
		vc.device = device
		viewController.show(vc, sender: nil)
	}
}
