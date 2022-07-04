//
//  PostPageVideoCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/7/2.
//

import UIKit
import AVFoundation

protocol PostPageVideoCellDelegate: AnyObject {
	func goToCommentVC(_ cell: PostPageVideoCell)
	func goToPostUserProfile(_ cell: PostPageVideoCell)
	func likePost(_ cell: PostPageVideoCell)
	func checkIfLikedByUser(_ cell: PostPageVideoCell)
	func askToDelete(_ cell: PostPageVideoCell)
	func toggleVideoVolunm(_ cell: PostPageVideoCell)
}

class PostPageVideoCell: UITableViewCell {
	
	static let reuserIdentifier = "\(PostPageVideoCell.self)"
	
	weak var delegate: PostPageVideoCellDelegate?
	
	// MARK: - Properties
	
	var post: Post? {
		didSet {
			configureUI()
		}
	}
	
	var user: User?
	
	var avPlayerLayer = AVPlayerLayer()
	var avQueueplayer = AVQueuePlayer()
	var looper: AVPlayerLooper?
	
	var isVolumnOn: Bool = false {
		didSet {
			if isVolumnOn {
				toggleVolumeButton.isSelected = true
			} else {
				toggleVolumeButton.isSelected = false
			}
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
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
		imageView.addGestureRecognizer(tap)
		imageView.isUserInteractionEnabled = true
		
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
		button.isHidden = true
		button.addTarget(self, action: #selector(handleAskToDelete), for: .touchUpInside)
		return button
	}()
	
	private lazy var deleteButton: UIButton = {
		let button = UIButton()
		button.setTitle("Delete", for: .normal)
		button.setTitleColor(.red, for: .normal)
		button.titleLabel?.font = UIFont.customFont(.interSemiBold, size: 12)
		button.backgroundColor = .orange20
		button.layer.cornerRadius = 5
		button.setDimensions(width: 50, height: 20)
		button.addTarget(self, action: #selector(deleteArticle), for: .touchUpInside)
		button.isHidden = true
		button.alpha = 0
		return button
	}()
	
	private let contentTextLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 16),
												 textColor: UIColor.dark, text: "Content Text")
		label.numberOfLines = 0
		return label
	}()
	
	private let videoContainerView: UIView = {
		let view = UIView()
		view.backgroundColor = .light50
		view.setDimensions(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.height * 0.3)
		view.clipsToBounds = true
		view.layer.cornerRadius = 12
		return view
	}()
	
	private lazy var toggleVolumeButton: UIButton = {
		let button = UIButton()
		let offImage = UIImage.asset(.media_volume_off)?.withRenderingMode(.alwaysOriginal)
		let onImage = UIImage.asset(.media_volume)?.withRenderingMode(.alwaysOriginal)
		button.setImage(offImage, for: .normal)
		button.setImage(onImage, for: .selected)
		button.addTarget(self, action: #selector(handleVolumn), for: .touchUpInside)
		button.setDimensions(width: 50, height: 50)
		return button
	}()
	
	let likeCountLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: UIColor.dark40, text: "Likes: 100")
		return label
	}()
	
	lazy var likeButton: UIButton = {
		let button = UIButton()
		button.setTitle("   Like", for: .normal)
		button.setTitleColor(UIColor.dark, for: .normal)
		button.setTitleColor(UIColor.red40, for: .selected)
		button.titleLabel?.font = UIFont.customFont(.manropeRegular, size: 14)
		button.setImage(UIImage.asset(.favorite), for: .normal)
		button.setImage(UIImage.asset(.favorite)?.withTintColor(.red40), for: .selected)
		button.addTarget(self, action: #selector(likePost), for: .touchUpInside)
		return button
	}()
	
	private lazy var commentButton: UIButton = {
		let button = UIButton()
		button.setTitle("   Comment", for: .normal)
		button.setTitleColor(UIColor.dark, for: .normal)
		button.titleLabel?.font = UIFont.customFont(.manropeRegular, size: 14)
		button.setImage(UIImage.asset(.chat), for: .normal)
		button.addTarget(self, action: #selector(goToCommentVC), for: .touchUpInside)
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
		
		contentView.addSubview(deleteButton)
		deleteButton.anchor(top: feedEditButton.bottomAnchor, right: contentView.rightAnchor, paddingTop: 6, paddingRight: 12)
		
		videoContainerView.addSubview(toggleVolumeButton)
		toggleVolumeButton.anchor(bottom: videoContainerView.bottomAnchor, right: videoContainerView.rightAnchor,
								  paddingBottom: 8, paddingRight: 8)
		
		let feedHStack = UIStackView(arrangedSubviews: [likeButton, commentButton])
		feedHStack.axis = .horizontal
		feedHStack.distribution = .fillEqually
		contentView.addSubview(feedHStack)
		
		let feedVStack = UIStackView(arrangedSubviews: [contentTextLabel, videoContainerView, likeCountLabel, feedHStack])
		contentView.addSubview(feedVStack)
		feedVStack.spacing = 16
		feedVStack.axis = .vertical
		feedVStack.anchor(top: profileImageView.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
						  right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
	}
	
	func setupAvPlayer() {
		guard let post = post else { return }
		guard let urlString = post.videoURL else { return }
		
		CacheManager.shared.getFileWith(stringUrl: urlString) { [weak self] result in
			guard let self = self else { return }
			
			switch result {
			case .success(let url):
				
				let item = AVPlayerItem(url: url)
				self.avQueueplayer = AVQueuePlayer()
				self.looper = AVPlayerLooper(player: self.avQueueplayer, templateItem: item)
				self.avPlayerLayer = AVPlayerLayer(player: self.avQueueplayer)
				self.avPlayerLayer.videoGravity = .resizeAspectFill
				self.avPlayerLayer.player?.actionAtItemEnd = .none
				
				self.videoContainerView.layer.addSublayer(self.avPlayerLayer)
				self.avPlayerLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32,
											 height: UIScreen.main.bounds.height * 0.3)
				self.avPlayerLayer.addSublayer(self.toggleVolumeButton.layer)
				self.avQueueplayer.volume = 0
				
				self.avQueueplayer.play()
				
			case .failure(let error):
				print(error)
			}
		}
		
	}
	
	// MARK: - Actions
	
	@objc func handleVolumn() {
		isVolumnOn.toggle()
		delegate?.toggleVideoVolunm(self)
	}
	
	@objc func handleProfileImageTapped() {
		delegate?.goToPostUserProfile(self)
	}
	
	@objc func goToCommentVC() {
		delegate?.goToCommentVC(self)
	}
	
	@objc func likePost() {
		delegate?.likePost(self)
	}
	
	@objc func handleAskToDelete() {
		if deleteButton.isHidden {
			UIView.animate(withDuration: 0.3) {
				self.deleteButton.alpha = 1
				self.deleteButton.isHidden = !self.deleteButton.isHidden
			}
		} else {
			UIView.animate(withDuration: 0.3) {
				self.deleteButton.alpha = 0
			} completion: { done in
				if done {
					self.deleteButton.isHidden = !self.deleteButton.isHidden
				}
			}
		}
	}
	
	@objc func deleteArticle() {
		delegate?.askToDelete(self)
		deleteButton.isHidden = true
	}
	
	// MARK: - Helpers
	
	func configureUI() {
		guard let post = post, let user = user else { return }
		let imageUrl = URL(string: post.user.profileImageURL)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "h:mm a ∙ MM/dd/yyyy"
		let postDate = Date(timeIntervalSince1970: post.timestamp)
		
		profileImageView.kf.setImage(with: imageUrl)
		feedNameLabel.text = post.user.name
		feedTimeLabel.text = dateFormatter.string(from: postDate)
		contentTextLabel.text = post.contentText
		likeCountLabel.text = "\(post.likes) likes"
		
		delegate?.checkIfLikedByUser(self)
				
		if post.userID == user.userID {
			feedEditButton.isHidden = false
		} else {
			feedEditButton.isHidden = true
		}
	}
	
}
