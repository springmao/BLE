//
//  UIViewController+Router.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 10.01.18.
//

import UIKit

extension UIViewController {

	typealias EmptyBlock = () -> Void

    var router: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

	/**
	Show Blutooth powered off Status warning
	
	on Done action trying to open Settings page to allow user to turn bluetooth on
	*/
    func showBlutoothPoweredOffStatusAlert() {
        let alert = UIAlertController(title: "holy_error".localized, message: "turn_bluetooth_on".localized, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "done".localized, style: .default) { _ in
			let url = URL(string: "App-Prefs:root=General")
			UIApplication.shared.openURL(url!)
			})
        present(alert, animated: true, completion: nil)
    }

	/**
	Show stop updating process warning
	
	- Parameters:
	- onAbort: EmptyBlock complition on user selected abort
	- onCancel: EmptyBlock complition on user selected cancel
	*/
	func showStopProcessWarning(_ onAbort: @escaping EmptyBlock, _ onCancel: @escaping EmptyBlock) {
		let alertView = UIAlertController(title: "warning".localized, message: "ask_stop_process".localized, preferredStyle: .alert)
		alertView.addAction(UIAlertAction(title: "abort".localized, style: .destructive) {
			(_) in
			onAbort()
		})
		alertView.addAction(UIAlertAction(title: "cancel".localized, style: .cancel) {
			(_) in
			onCancel()
		})
		present(alertView, animated: true)
	}
	
	/**
	Show no firmware file zip in pasteboard
	
	- Parameters:
	- onDone: EmptyBlock complition on user selected done
	*/
	func showNoFirmwareFileWarning(_ onDone: EmptyBlock? = nil) {
		let alertView = UIAlertController(title: "warning".localized, message: "no_firmware_file".localized, preferredStyle: .alert)
		alertView.addAction(UIAlertAction(title: "done".localized, style: .cancel) {
			(_) in
			onDone?()
		})
		present(alertView, animated: true)
	}
	
	/**
	Show on updated
	
	- Parameters:
	- onDone: EmptyBlock complition on user selected done
	*/
	func showSuccess(_ onDone: EmptyBlock? = nil) {
		let alertView = UIAlertController(title: "Success", message: nil, preferredStyle: .alert)
		alertView.addAction(UIAlertAction(title: "done".localized, style: .cancel) {
			(_) in
			onDone?()
		})
		present(alertView, animated: true)
	}
}
