//
//  PostCommentTableHeader.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/21.
//

import UIKit
import Kingfisher
import FirebaseAuth

protocol PostCommentTableHeaderDelegate: AnyObject {
	func askToDelete(_ cell: PostCommentTableHeader)
	func goToPublicProfile(_ cell: PostCommentTableHeader)
}

class PostCommentTableHeader: UITableViewHeaderFooterView {
	
	static let reuserIdentifier = "\(PostCommentTableHeader.self)"
	
	weak var delegate: PostCommentTableHeaderDelegate?

	// MARK: - Properties
	
	var post: Post? {
		didSet {
			configureUI()
			collectionView.reloadData()
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
	
	private let contentLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.customFont(.manropeRegular, size: 16)
		label.text = "Content"
		label.textColor = .dark
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
	
	private let dividerView: UIView = {
		let view = UIView()
		view.backgroundColor = .dark20
//		view.heightAnchor.constraint(equalToConstant: 1).isActive = true
		return view
	}()
	
	// MARK: - Lifecycle
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		setupUI()
		collectionView.dataSource = self
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

//		contentView.addSubview(contentLabel)
//		contentLabel.anchor(top: profileImageView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor,
//							paddingTop: 16, paddingLeft: 16, paddingRight: 16)
//

		let postCommentHeaderVStack = UIStackView(arrangedSubviews: [contentLabel, collectionView])
		postCommentHeaderVStack.axis = .vertical
		postCommentHeaderVStack.spacing = 16
		contentView.addSubview(postCommentHeaderVStack)
		postCommentHeaderVStack.anchor(top: profileImageView.bottomAnchor, left: contentView.leftAnchor,
									    right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
		contentView.addSubview(dividerView)
		dividerView.anchor(top: postCommentHeaderVStack.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
						   right: contentView.rightAnchor, paddingTop: 16, paddingBottom: 1, height: 1)
		
		
	}
	
	// MARK: - Actions
	
	@objc func handleProfileImageTapped() {
		delegate?.goToPublicProfile(self)
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
	}
	
	// MARK: - Helpers
	
	func configureUI() {
		guard let post = post, let uid = Auth.auth().currentUser?.uid else { return }
		let imageUrl = URL(string: post.user.profileImageURL)
		profileImageView.kf.setImage(with: imageUrl)
		
		let date = Date(timeIntervalSince1970: post.timestamp)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "h:mm a ∙ MM/dd/yyyy"
		let postDate = dateFormatter.string(from: date)
		
		feedNameLabel.text = post.user.name
		feedTimeLabel.text = postDate
		contentLabel.text = post.contentText
		
		if post.userID == uid{
			feedEditButton.isHidden = false
		}
		
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
		
		let layout = UICollectionViewCompositionalLayout(section: section)
		return layout
	}

}

// MARK: - UICollectionViewDataSource

extension PostCommentTableHeader: UICollectionViewDataSource {
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
