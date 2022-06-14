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
					buttonWidth: CGFloat,
					buttonText: String,
					borderWidth: CGFloat = 1) -> UIButton {
		
		let button = UIButton()
		button.layer.cornerRadius = 5
		button.layer.borderWidth = borderWidth
		button.layer.borderColor = borderColor.cgColor
		button.setTitle(buttonText, for: .normal)
		button.setTitleColor(buttonTextColor, for: .normal)
		button.heightAnchor.constraint(equalToConstant: 48).isActive = true
		button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
		button.titleLabel?.font = UIFont.customFont(.interBold, size: 14)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}
	
	func makeMediumButton(buttonColor: UIColor,
					buttonTextColor: UIColor,
					borderColor: UIColor,
					buttonWidth: CGFloat,
					buttonText: String,
					borderWidth: CGFloat = 1) -> UIButton {
		
		let button = UIButton()
		button.layer.cornerRadius = 5
		button.layer.borderWidth = borderWidth
		button.layer.borderColor = borderColor.cgColor
		button.setTitle(buttonText, for: .normal)
		button.setTitleColor(buttonTextColor, for: .normal)
		button.heightAnchor.constraint(equalToConstant: 40).isActive = true
		button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
		button.titleLabel?.font = UIFont.customFont(.interBold, size: 14)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}
	
	func makeSmallButton(buttonColor: UIColor,
					buttonTextColor: UIColor,
					borderColor: UIColor,
					buttonWidth: CGFloat,
					buttonText: String,
					borderWidth: CGFloat = 1) -> UIButton {
		
		let button = UIButton()
		button.layer.cornerRadius = 5
		button.layer.borderWidth = borderWidth
		button.layer.borderColor = borderColor.cgColor
		button.setTitle(buttonText, for: .normal)
		button.setTitleColor(buttonTextColor, for: .normal)
		button.heightAnchor.constraint(equalToConstant: 32).isActive = true
		button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
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
	
}
