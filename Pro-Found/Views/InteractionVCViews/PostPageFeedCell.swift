//
//  PostPageFeedCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import UIKit
import Kingfisher

protocol PostPageFeedCellDelegate: AnyObject {
	func goToCommentVC(_ cell: PostPageFeedCell)
	func goToPostUserProfile(_ cell: PostPageFeedCell)
	func likePost(_ cell: PostPageFeedCell)
	func checkIfLikedByUser(_ cell: PostPageFeedCell)
	func popUpUserContentAlert(_ cell: PostPageFeedCell)
}

extension PostPageFeedCellDelegate {
	func goToPostUserProfile(_ cell: PostPageFeedCell) {}
}

class PostPageFeedCell: UITableViewCell {
	
	static let reuseIdentifier = "\(PostPageFeedCell.self)"
	
	weak var delegate: PostPageFeedCellDelegate?
	
	// MARK: - Properties
	
	var post: Post? {
		didSet {
			configure()
			collectionView.reloadData()
		}
	}
	
	var user: User?
	
	private lazy var profileImageView: UIImageView = {
		let imageView = CustomUIElements().makeCircularProfileImageView(width: 36, height: 36)
		
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
		let image = UIImage.asset(.more)?.withRenderingMode(.alwaysOriginal).withTintColor(.dark40)
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(handleEditButtonAction), for: .touchUpInside)
		return button
	}()
	
	private let contentTextLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 16),
												 textColor: UIColor.dark, text: "Content Text")
		label.numberOfLines = 0
		return label
	}()
	
	private lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
		collectionView.register(ChooseSubjectUICollectionViewCell.self,
								forCellWithReuseIdentifier: ChooseSubjectUICollectionViewCell.reuseIdentifier)
		collectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
		return collectionView
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
		collectionView.dataSource = self
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UI
	
	func setupUI() {
		contentView.addSubview(profileImageView)
		contentView.addSubview(feedNameLabel)
		contentView.addSubview(feedTimeLabel)
		contentView.addSubview(feedEditButton)
		
		profileImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 16, paddingLeft: 16)
		
		feedNameLabel.anchor(top: contentView.topAnchor, left: profileImageView.rightAnchor, right: contentView.rightAnchor,
							 paddingTop: 16, paddingLeft: 12, paddingRight: 24)
		
		feedTimeLabel.anchor(top: feedNameLabel.bottomAnchor, left: profileImageView.rightAnchor, right: contentView.rightAnchor,
							 paddingLeft: 12, paddingRight: 24)
		
		feedEditButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
		feedEditButton.anchor(right: contentView.rightAnchor, paddingRight: 12)
		
		let feedHStack = UIStackView(arrangedSubviews: [likeButton, commentButton])
		feedHStack.axis = .horizontal
		feedHStack.distribution = .fillEqually
		contentView.addSubview(feedHStack)
		
		let feedVStack = UIStackView(arrangedSubviews: [contentTextLabel, collectionView, likeCountLabel, feedHStack])
		contentView.addSubview(feedVStack)
		feedVStack.spacing = 16
		feedVStack.axis = .vertical
		feedVStack.anchor(top: profileImageView.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
						  right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
		
	}
	
	// MARK: - Actions
	
	@objc func handleProfileImageTapped() {
		delegate?.goToPostUserProfile(self)
	}
	
	@objc func goToCommentVC() {
		delegate?.goToCommentVC(self)
	}
	
	@objc func likePost() {
		delegate?.likePost(self)
	}
	
	@objc func handleEditButtonAction() {
		delegate?.popUpUserContentAlert(self)
	}
	
	// MARK: - Helpers
	
	func configure() {
		guard let post = post, let user = user else { return }
		let imageUrl = URL(string: post.user.profileImageURL)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "h:mm a ??? MM/dd/yyyy"
		let postDate = Date(timeIntervalSince1970: post.timestamp)
		
		profileImageView.kf.setImage(with: imageUrl)
		feedNameLabel.text = post.user.name
		feedTimeLabel.text = dateFormatter.string(from: postDate)
		contentTextLabel.text = post.contentText
		likeCountLabel.text = "\(post.likes) likes"
		
		delegate?.checkIfLikedByUser(self)
		
		if post.imagesURL.isEmpty {
			collectionView.isHidden = true
		} else {
			collectionView.isHidden = false
		}
		
	}
	
	func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
		
		let section = NSCollectionLayoutSection(group: group)
		section.orthogonalScrollingBehavior = .continuous
//		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
		
		let layout = UICollectionViewCompositionalLayout(section: section)
		return layout
	}
	
}

// MARK: - UICollectionViewDataSource

extension PostPageFeedCell: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return post?.imagesURL.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChooseSubjectUICollectionViewCell.reuseIdentifier, for: indexPath)
				as? ChooseSubjectUICollectionViewCell else { fatalError("Can not dequeue ChooseSubjectUICollectionViewCell") }
		guard let imageURL = URL(string: post?.imagesURL[indexPath.item] ?? "") else { return cell }
		cell.subjectImageView.kf.setImage(with: imageURL)
		return cell
	}
}
