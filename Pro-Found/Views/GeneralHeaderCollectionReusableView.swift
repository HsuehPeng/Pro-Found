//
//  GeneralHeaderCollectionReusableView.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/16.
//

import UIKit

protocol GeneralHeaderCollectionReusableViewDelegate: AnyObject {
	func filterByTutorSubject(_ cell: GeneralHeaderCollectionReusableView)
}

class GeneralHeaderCollectionReusableView: UICollectionReusableView {

	static let reuseIdentifier = "\(GeneralHeaderCollectionReusableView.self)"
	
	weak var articleListDelagate: GeneralHeaderCollectionReusableViewDelegate?
	
	// MARK: - Properties
	
	let titleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 16), textColor: UIColor.dark60, text: "Header Title")
		return label
	}()
	
	lazy var actionButton: UIButton = {
		let button = UIButton()
		button.setTitle("Subject", for: .normal)
		button.titleLabel?.font = UIFont.customFont(.interBold, size: 14)
		button.setTitleColor(UIColor.orange, for: .normal)

		return button
	}()
	
	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UI
	
	func setupUI() {
		self.addSubview(titleLabel)
		titleLabel.centerY(inView: self, leftAnchor: self.leftAnchor, paddingLeft: 16)
		
		self.addSubview(actionButton)
		actionButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
		actionButton.anchor(right: self.rightAnchor, paddingRight: 16)

	}
	
}
