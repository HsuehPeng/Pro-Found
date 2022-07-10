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
	
	func showAlert(alertText : String, alertMessage : String) {
		let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "Got it", style: UIAlertAction.Style.default, handler: nil))
		//Add more actions as you see fit
		self.present(alert, animated: true, completion: nil)
	}
}