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
	
	func inputContainerStackView(labelText: String) -> UIStackView {
		
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 12),
												 textColor: UIColor.dark, text: labelText)
		
		let textField = UITextField()
		textField.font = UIFont.customFont(.manropeRegular, size: 12)
		textField.placeholder = labelText
		
		let dividerView = UIView()
		dividerView.backgroundColor = .dark20
		dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		
		let view = UIStackView(arrangedSubviews: [label, textField, dividerView])
		view.axis = .vertical
		view.spacing = 12
		
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
	
	func makeCircularProfileImageView(width: CGFloat, height: CGFloat) -> UIImageView {
		let imageView = UIImageView()
		imageView.backgroundColor = .orange10
		imageView.setDimensions(width: width, height: height)
		imageView.layer.cornerRadius = width / 2
		imageView.image = UIImage.asset(.account_circle)
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}
	
}
