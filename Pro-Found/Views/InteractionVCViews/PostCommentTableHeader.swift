//
//  PostCommentTableHeader.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/21.
//

import UIKit
import Kingfisher

class PostCommentTableHeader: UITableViewHeaderFooterView {
	
	static let reuserIdentifier = "\(PostCommentTableHeader.self)"

	// MARK: - Properties
	
	var post: Post? {
		didSet {
			configureUI()
		}
	}
	
	private lazy var profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true
		imageView.setDimensions(width: 36, height: 36)
		imageView.layer.cornerRadius = 36 / 2
		imageView.backgroundColor = .gray
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
//		let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
//		imageView.addGestureRecognizer(tap)
//		imageView.isUserInteractionEnabled = true
		
		return imageView
	}()
	
	private let feedNameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 14),
												 textColor: UIColor.dark60, text: "Test Name")
		return label
	}()
	
	private let feedTimeLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: UIColor.dark40, text: "Test time")
		return label
	}()
	
	private lazy var feedEditButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.asset(.more), for: .normal)
		return button
	}()
	
	private let contentLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.customFont(.manropeRegular, size: 16)
		label.text = "Content"
		label.textColor = .dark
		label.numberOfLines = 0
		return label
	}()
	
	private let dividerView: UIView = {
		let view = UIView()
		view.backgroundColor = .dark20
		return view
	}()
	
	// MARK: - Lifecycle
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
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
		feedNameLabel.anchor(top: contentView.topAnchor, left: profileImageView.rightAnchor, paddingTop: 16, paddingLeft: 12)

		contentView.addSubview(feedTimeLabel)
		feedTimeLabel.anchor(top: feedNameLabel.bottomAnchor, left: profileImageView.rightAnchor, paddingLeft: 12)

		contentView.addSubview(feedEditButton)
		feedEditButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
		feedEditButton.anchor(right: contentView.rightAnchor, paddingRight: 12)

		contentView.addSubview(contentLabel)
		contentLabel.anchor(top: profileImageView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor,
							paddingTop: 16, paddingLeft: 16, paddingRight: 16)

		contentView.addSubview(dividerView)
		dividerView.anchor(top: contentLabel.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
						   right: contentView.rightAnchor, paddingTop: 16, height: 1)
		
	}
	
	// MARK: - Actions
	
	// MARK: - Helpers
	
	func configureUI() {
		guard let post = post else { return }
		let imageUrl = URL(string: post.user.profileImageURL)
		profileImageView.kf.setImage(with: imageUrl)
		
		let date = Date(timeIntervalSince1970: post.timestamp)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "h:mm a ∙ MM/dd/yyyy"
		let postDate = dateFormatter.string(from: date)
		
		feedNameLabel.text = post.user.name
		feedTimeLabel.text = postDate
		contentLabel.text = post.contentText
	}

}
