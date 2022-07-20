//
//  UIViewController+Extension.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/7/8.
//

import UIKit
import PhotosUI

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
		
		self.present(alert, animated: true, completion: nil)
	}
	
	func showAlertWithCompletion(alertText : String, alertMessage : String, completion: @escaping () -> Void) {
		let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "Got it", style: UIAlertAction.Style.default, handler: { action in
			completion()
		}))
		
		self.present(alert, animated: true, completion: nil)
	}
	
	func popUpAskToLoginView() {
		let popUpAskToLoginVC = PopUpAskToLoginController()
		popUpAskToLoginVC.modalTransitionStyle = .crossDissolve
		popUpAskToLoginVC.modalPresentationStyle = .overCurrentContext
		self.present(popUpAskToLoginVC, animated: true)
	}
	
	func popUpMissingInputVC() {
		let missingInputVC = MissingInputViewController()
		missingInputVC.modalTransitionStyle = .crossDissolve
		missingInputVC.modalPresentationStyle = .overCurrentContext
		self.present(missingInputVC, animated: true)
	}
	
	func setupAttributeNavBar(titleText: String) {
		navigationController?.navigationBar.isHidden = false
		tabBarController?.tabBar.isHidden = true

		navigationItem.title = titleText
		let titleAttribute: [NSAttributedString.Key: Any] = [
			.font: UIFont.customFont(.interBold, size: 16)
		]
		let appearance = UINavigationBarAppearance()
		appearance.titleTextAttributes = titleAttribute
		appearance.configureWithDefaultBackground()
		navigationController?.navigationBar.standardAppearance = appearance
		navigationController?.navigationBar.compactAppearance = appearance
		navigationController?.navigationBar.scrollEdgeAppearance = appearance
		
	}
	
}
