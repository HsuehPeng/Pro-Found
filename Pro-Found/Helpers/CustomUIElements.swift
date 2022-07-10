//
//  CustomUIElements.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/13.
//

import UIKit

class CustomUIElements {
	
	func makeLargeButton(buttonColor: UIColor,
					buttonTextColor: UIColor,
					borderColor: UIColor,
					buttonText: String,
					borderWidth: CGFloat = 1) -> UIButton {
		
		let button = UIButton()
		button.backgroundColor = buttonColor
		button.layer.cornerRadius = 5
		button.layer.borderWidth = borderWidth
		button.layer.borderColor = borderColor.cgColor
		button.setTitle(buttonText, for: .normal)
		button.setTitleColor(buttonTextColor, for: .normal)
		button.heightAnchor.constraint(equalToConstant: 48).isActive = true
		button.titleLabel?.font = UIFont.customFont(.interBold, size: 14)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}
	
	func makeMediumButton(buttonColor: UIColor,
					buttonTextColor: UIColor,
					borderColor: UIColor,
					buttonText: String,
					borderWidth: CGFloat = 1) -> UIButton {
		
		let button = UIButton()
		button.backgroundColor = buttonColor
		button.layer.cornerRadius = 5
		button.layer.borderWidth = borderWidth
		button.layer.borderColor = borderColor.cgColor
		button.setTitle(buttonText, for: .normal)
		button.setTitleColor(buttonTextColor, for: .normal)
		button.heightAnchor.constraint(equalToConstant: 40).isActive = true
		button.titleLabel?.font = UIFont.customFont(.interBold, size: 14)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}
	
	func makeSmallButton(buttonColor: UIColor,
					buttonTextColor: UIColor,
					borderColor: UIColor,
					buttonText: String,
					borderWidth: CGFloat = 1) -> UIButton {
		
		let button = UIButton()
		button.backgroundColor = buttonColor
		button.layer.cornerRadius = 5
		button.layer.borderWidth = borderWidth
		button.layer.borderColor = borderColor.cgColor
		button.setTitle(buttonText, for: .normal)
		button.setTitleColor(buttonTextColor, for: .normal)
		button.heightAnchor.constraint(equalToConstant: 32).isActive = true
		button.titleLabel?.font = UIFont.customFont(.interBold, size: 14)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}
	
	func makeLabel(font: UIFont, textColor: UIColor, text: String) -> UILabel {
		let label = UILabel()
		label.font = font
		label.textColor = textColor
		label.text = text
		return label

	}
	
	func inputContainerView(labelText: String) -> UIView {
		let view = UIView()
		
		view.heightAnchor.constraint(equalToConstant: 60).isActive = true
		
		let label = UILabel()
		label.text = labelText
		label.textColor = UIColor.dark
		label.font = UIFont.customFont(.manropeRegular, size: 12)
		view.addSubview(label)
		label.anchor(top: view.topAnchor, left: view.leftAnchor)
		
		let textField = UITextField()
		view.addSubview(textField)
		textField.anchor(top: label.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
		
		let dividerView = UIView()
		dividerView.backgroundColor = .dark20
		view.addSubview(dividerView)
		dividerView.anchor(top: textField.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
						   right: view.rightAnchor, paddingTop: 5, height: 0.75)
		
		return view
	}
	
	func subjectSelectionButton(subject: Subject) -> UIButton {
		let button = UIButton()
		button.layer.cornerRadius = 12
		button.setTitle(subject.rawValue, for: .normal)
		button.setTitleColor(UIColor.light60, for: .selected)
		button.setTitleColor(UIColor.dark30, for: .normal)
		button.backgroundColor = .dark10
		button.heightAnchor.constraint(equalToConstant: 29).isActive = true
		button.titleLabel?.font = UIFont.customFont(.manropeRegular, size: 12)
		return button
	}
	
}
