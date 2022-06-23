//
//  TutorProfileContentHeader.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/23.
//

import UIKit

protocol TutorProfileContentHeaderDelegate: AnyObject {
	func changeContent(_ cell: TutorProfileContentHeader, pressedButton type: UIButton)
}

class TutorProfileContentHeader: UITableViewHeaderFooterView {

	static let reuseIdentifier = "\(TutorProfileContentHeader.self)"
	
	weak var delegate: TutorProfileContentHeaderDelegate?
	
	// MARK: - Properties
	
	lazy var articleButton: UIButton = {
		let button = makeButton(title: "Articles", titleColor: UIColor.dark60, selectedColor: UIColor.orange)
		button.isSelected = true
		return button
	}()
	
	lazy var eventButton: UIButton = {
		let button = makeButton(title: "Events", titleColor: UIColor.dark60, selectedColor: UIColor.orange)
		return button
	}()
	
	lazy var postButton: UIButton = {
		let button = makeButton(title: "Posts", titleColor: UIColor.dark60, selectedColor: UIColor.orange)
		return button
	}()
	
	// MARK: - Lifecycle
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .light60
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UI
	
	func setupUI() {
		let hStackView = UIStackView(arrangedSubviews: [articleButton, eventButton, postButton])
		contentView.addSubview(hStackView)
		hStackView.distribution = .fillEqually
		hStackView.addConstraintsToFillView(contentView)
	}
	
	// MARK: - Actions
	
	@objc func handleChangeContent(_ sender: UIButton) {
		delegate?.changeContent(self, pressedButton: sender)
	}
	
	// MARK: - Helpers
	
	func makeButton(title: String, titleColor: UIColor, selectedColor: UIColor) -> UIButton {
		let button = UIButton()
		button.setTitle(title, for: .normal)
		button.setTitleColor(titleColor, for: .normal)
		button.setTitleColor(selectedColor, for: .selected)
		button.titleLabel?.font = UIFont.customFont(.interBold, size: 16)
		button.addTarget(self, action: #selector(handleChangeContent), for: .touchUpInside)
		return button
	}
}
