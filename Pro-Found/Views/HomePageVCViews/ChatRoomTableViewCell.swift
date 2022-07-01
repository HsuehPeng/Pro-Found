//
//  ChatRoomTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/30.
//

import UIKit
import Kingfisher

class ChatRoomTableViewCell: UITableViewCell {
	
	static let reuserIdentifier = "\(ChatRoomTableViewCell.self)"
	
	// MARK: - Properties
	
	var user: User? {
		didSet {
			configureUI()
		}
	}
	
	private let profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.setDimensions(width: 48, height: 48)
		imageView.layer.cornerRadius = 48 / 2
		imageView.backgroundColor = .orange10
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		return imageView
	}()
	
	private let nameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 14),
												 textColor: .dark60, text: "Name")
		return label
	}()
	
	private let latestMessageLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: .dark40, text: "Latest Message")
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
	
	// MARK: - properties
	
	func setupUI() {
		contentView.addSubview(profileImageView)
		profileImageView.centerY(inView: contentView, leftAnchor: contentView.leftAnchor, paddingLeft: 16)
		
		let labelVStack = UIStackView(arrangedSubviews: [nameLabel, latestMessageLabel])
		labelVStack.axis = .vertical
		labelVStack.spacing = 2
		contentView.addSubview(labelVStack)
		labelVStack.centerY(inView: contentView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 16)
	}
	
	// MARK: - Helpers
	
	func configureUI() {
		guard let user = user, let imageURL = URL(string: user.profileImageURL) else { return }
		profileImageView.kf.setImage(with: imageURL)
		nameLabel.text = user.name
		
	}
	

}
