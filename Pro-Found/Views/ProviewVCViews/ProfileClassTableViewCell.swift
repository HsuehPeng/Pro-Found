//
//  ProfileClassTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/14.
//

import UIKit

class ProfileClassTableViewCell: UITableViewCell {

	static let reuseIdentifier = "\(ProfileClassTableViewCell.self)"
	
	// MARK: - Properties
	
	private let classView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 16
		view.backgroundColor = .orange20
		view.setDimensions(width: 335, height: 186)
		
		return view
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
		contentView.addSubview(classView)
		classView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
						 right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 20, paddingBottom: 12, paddingRight: 20)
	}
	
	// MARK: - Actions
	
	// MARK: - Helpers

}
