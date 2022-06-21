//
//  PostCommentTableCellTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/21.
//

import UIKit
import Kingfisher

class PostCommentTableCellTableViewCell: UITableViewCell {
	
	static let reuseIdentifier = "\(PostCommentTableCellTableViewCell.self)"
	
	// MARK: - Properties
	
	var reply: Reply? {
		didSet {
			configureUI()
		}
	}
	
	private lazy var profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true
		imageView.setDimensions(width: 32, height: 32)
		imageView.layer.cornerRadius = 32 / 2
		imageView.backgroundColor = .gray
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
//		let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
//		imageView.addGestureRecognizer(tap)
//		imageView.isUserInteractionEnabled = true
		
		return imageView
	}()
	
	private let feedNameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 12),
												 textColor: UIColor.dark60, text: "Test Name")
		return label
	}()
	
	private let contentLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.customFont(.manropeRegular, size: 12)
		label.text = "Content"
		label.textColor = .dark
		label.numberOfLines = 0
		return label
	}()
	
	private let feedTimeLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 10),
												 textColor: UIColor.dark40, text: "Test time")
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
		contentView.addSubview(profileImageView)
		profileImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 16, paddingLeft: 16)
		
		contentView.addSubview(feedNameLabel)
		feedNameLabel.anchor(top: contentView.topAnchor, left: profileImageView.rightAnchor,
							 right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingRight: 16)
		
		contentView.addSubview(contentLabel)
		contentLabel.anchor(top: feedNameLabel.bottomAnchor, left: profileImageView.rightAnchor,
							right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 16)

		contentView.addSubview(feedTimeLabel)
		feedTimeLabel.anchor(top: contentLabel.bottomAnchor, left: profileImageView.rightAnchor,
							 bottom: contentView.bottomAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 16)
	}
	
	// MARK: - Actions
	
	// MARK: - Helpers
	
	func configureUI() {
		guard let reply = reply else { return }
		let imageUrl = URL(string: reply.user.profileImageURL)
		
		let date = Date(timeIntervalSince1970: reply.timestamp)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "h:mm a ∙ MM/dd/yyyy"
		let replyDate = dateFormatter.string(from: date)
		
		profileImageView.kf.setImage(with: imageUrl)
		feedNameLabel.text = reply.user.name
		contentLabel.text = reply.contentText
		feedTimeLabel.text = replyDate
	}

}
