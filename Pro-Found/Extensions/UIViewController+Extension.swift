//
//  UIViewController+Extension.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/7/8.
//

import UIKit

extension UIViewController {
	func hideKeyboardWhenTappedAround() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
}
