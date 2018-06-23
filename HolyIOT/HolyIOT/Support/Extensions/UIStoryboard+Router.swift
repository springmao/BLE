//
//  UIStoryboard+Router.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 10.01.18.
//

import UIKit

extension UIStoryboard {

	/**
	instantiate a UIViewController from the UIStoryboard
	
	- Parameters:
	- parameter type: The type of UIViewController to instantiate
	- parameter identifier: The identifier for the UIViewController (optional)
	
	- Returns: instantiated view controller of given type
	*/
    public func instantiate<T: UIViewController>(_ type: T.Type = T.self, withIdentifier identifier: String = String(describing: T.self)) -> T {
        guard let vc = instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Unknown view controller type (\(T.self)) for identifier: \(identifier)")
        }
        return vc
    }
}
