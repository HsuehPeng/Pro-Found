//
//  CalendarCollectionViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/16.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
	static let reuseIdentifier = "\(CalendarCollectionViewCell.self)"
	
	// MARK: - Properties
	
	let dateLabel = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14),
														 textColor: UIColor.dark, text: "1")
	
	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
		contentView.backgroundColor = .dark20
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UI
	
	func setupUI() {
		contentView.addSubview(dateLabel)
		dateLabel.center(inView: contentView)
	}
	
}
