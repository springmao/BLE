//
//  String+Extension.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 19.05.2018.
//

import Foundation

extension String {

	/**
	Localization
	
	In case, the string is key of Localizable.strings record
	
	- Returns: localized string
	*/
	var localized: String {
		return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
	}
}
