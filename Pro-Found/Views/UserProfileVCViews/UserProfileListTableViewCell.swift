//
//  UserProfileListTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/23.
//

import UIKit

class UserProfileListTableViewCell: UITableViewCell {
	
	static let reuserIdentifier = "\(UserProfileListTableViewCell.self)"
	
	// MARK: - Properties
	
	let iconImageView: UIImageView = {
		let imageView = UIImageView()
		return imageView
	}()
	
	let titleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 16), textColor: .dark, text: "")
		return label
	}()
	
	// MARK: - Lifecycle

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UI
	
	func setupUI() {
		contentView.addSubview(iconImageView)
		iconImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
							 paddingTop: 20, paddingLeft: 20, paddingBottom: 20)
		
		contentView.addSubview(titleLabel)
		titleLabel.centerY(inView: contentView, leftAnchor: iconImageView.rightAnchor, paddingLeft: 12)
	}
}
