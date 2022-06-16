//
//  GeneralHeaderCollectionReusableView.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/16.
//

import UIKit

class GeneralHeaderCollectionReusableView: UICollectionReusableView {
	
	static let reuseIdentifier = "\(GeneralHeaderCollectionReusableView.self)"
	
	// MARK: - Properties
	
	let titleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 16), textColor: UIColor.dark60, text: "Header Title")
		return label
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
	}
}
