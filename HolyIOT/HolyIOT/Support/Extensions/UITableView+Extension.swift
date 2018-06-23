//
//  UITableView+Extension.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 09.02.18.
//

import UIKit

extension UITableView {

	/**
	Dequeues a UITableViewCell for use in a UITableView
	
	- Parameters:
	- parameter type: The type of the cell.
	- parameter reuseIdentifier: The reuse identifier for the cell (optional).
	
	- Returns: A force-casted UITableViewCell of the specified type
	*/
    public func dequeueCell<T>(_ type: T.Type = T.self, withIdentifier reuseIdentifier: String = String(describing: T.self)) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) as? T else {
            fatalError("Unknown cell type (\(T.self)) for reuse identifier: \(reuseIdentifier)")
        }
        return cell
    }

	/**
	Returns the table cell at the specified index path
	
	- Parameters:
	- parameter type: The type of the cell
	- parameter indexPath: The index path at which to dequeue a new cell
	
	- Returns: A force-casted UITableViewCell of the specified type
	*/
    func cell<T>(_ type: T.Type = T.self, for indexPath: IndexPath) -> T? where T: UITableViewCell {
        return cellForRow(at: indexPath) as? T
    }

	/**
	Check if Cell for the specified index path is loaded
	
	- Parameters:
	- parameter indexPath: The index path at which the cell should exist
	
	- Returns: is cell loaded
	*/
    func isLoadedCellFor(indexPath: IndexPath) -> Bool {
        return cellForRow(at: indexPath) != nil
    }
}
