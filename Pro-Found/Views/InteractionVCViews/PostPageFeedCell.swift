//
//  PostPageFeedCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import UIKit

class PostPageFeedCell: UITableViewCell {
	
	static let reuseIdentifier = "\(PostPageFeedCell.self)"
	
	// MARK: - Properties
	
	var post: Post?
	
	var user: User? {
		didSet {
			configure()
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
	
	private let contentTextLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 16),
												 textColor: UIColor.dark, text: "Content Text")
		label.numberOfLines = 0
		return label
	}()
	
	private let likeCountLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: UIColor.dark40, text: "Likes: 100")
		return label
	}()
	
	private lazy var likeButton: UIButton = {
		let button = UIButton()
		button.setTitle("   Like", for: .normal)
		button.setTitleColor(UIColor.dark, for: .normal)
		button.titleLabel?.font = UIFont.customFont(.manropeRegular, size: 14)
		button.setImage(UIImage.asset(.favorite), for: .normal)
		return button
	}()
	
	private lazy var commentButton: UIButton = {
		let button = UIButton()
		button.setTitle("   Comment", for: .normal)
		button.setTitleColor(UIColor.dark, for: .normal)
		button.titleLabel?.font = UIFont.customFont(.manropeRegular, size: 14)
		button.setImage(UIImage.asset(.chat), for: .normal)
		return button
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
		feedNameLabel.anchor(top: contentView.topAnchor, left: profileImageView.rightAnchor, paddingTop: 16, paddingLeft: 12)
		
		contentView.addSubview(feedTimeLabel)
		feedTimeLabel.anchor(top: feedNameLabel.bottomAnchor, left: profileImageView.rightAnchor, paddingLeft: 12)
		
		contentView.addSubview(feedEditButton)
		feedEditButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
		feedEditButton.anchor(right: contentView.rightAnchor, paddingRight: 12)
		
		contentView.addSubview(contentTextLabel)
		contentTextLabel.anchor(top: profileImageView.bottomAnchor, left: contentView.leftAnchor,
								right: contentView.rightAnchor, paddingTop: 15, paddingLeft: 16, paddingRight: 16)
		
		contentView.addSubview(likeCountLabel)
		likeCountLabel.anchor(top: contentTextLabel.bottomAnchor, left: contentView.leftAnchor,
							  paddingTop: 15, paddingLeft: 16)
		
		let feedHStack = UIStackView(arrangedSubviews: [likeButton, commentButton])
		feedHStack.axis = .horizontal
		feedHStack.distribution = .fillEqually
		contentView.addSubview(feedHStack)
		feedHStack.anchor(top: likeCountLabel.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
						  right: contentView.rightAnchor, paddingTop: 20, paddingBottom: 12)

	}
	
	// MARK: - Helpers
	
	func configure() {
		guard let post = post, let user = user else { return }
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "h:mm a ∙ MM/dd/yyyy"
		let postDate = Date(timeIntervalSince1970: post.timestamp)
		
		feedNameLabel.text = user.name
		feedTimeLabel.text = dateFormatter.string(from: postDate)
		contentTextLabel.text = post.contentText
		likeCountLabel.text = String(post.likes)
	}
}
