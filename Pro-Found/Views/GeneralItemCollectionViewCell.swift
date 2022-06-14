//
//  GeneralItemCollectionViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/14.
//

import UIKit

class GeneralItemCollectionViewCell: UICollectionViewCell {
	
	static let reuseIdentifier = "\(GeneralItemCollectionViewCell.self)"
	
    // MARK: - Properties
	
	private let tutorImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .gray
		imageView.layer.cornerRadius = 10
		return imageView
	}()
	
	private let nameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 12), textColor: UIColor.dark60, text: "Test Name")
		label.numberOfLines = 0
		return label
	}()
	
	private let followersLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 10), textColor: UIColor.dark40, text: "Followers: 100")
		return label
	}()
	
	private let subjectButton: UIButton = {
		let button = UIButton()
		button.setTitle("Subject", for: .normal)
		button.setTitleColor(UIColor.white, for: .normal)
		button.titleLabel?.font = UIFont.customFont(.interSemiBold, size: 9)
		button.backgroundColor = .orange
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
		contentView.addSubview(tutorImageView)
		tutorImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, height: 148)
		
		contentView.addSubview(nameLabel)
		nameLabel.anchor(top: tutorImageView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 12)
		
		contentView.addSubview(followersLabel)
		followersLabel.anchor(top: nameLabel.bottomAnchor, left: contentView.leftAnchor, paddingTop: 4)
		
		contentView.addSubview(subjectButton)
		subjectButton.centerYAnchor.constraint(equalTo: followersLabel.centerYAnchor).isActive = true
		subjectButton.anchor(left: followersLabel.rightAnchor, right: contentView.rightAnchor, paddingLeft: 2)
		
	}
	
}
