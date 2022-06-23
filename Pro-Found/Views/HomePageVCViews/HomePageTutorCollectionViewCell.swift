//
//  GeneralItemCollectionViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/14.
//

import UIKit
import Kingfisher

class HomePageTutorCollectionViewCell: UICollectionViewCell {
	
	static let reuseIdentifier = "\(HomePageTutorCollectionViewCell.self)"
	
    // MARK: - Properties
	
	var tutor: User? {
		didSet {
			configure()
		}
	}
	
	private let tutorImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .gray
		imageView.layer.cornerRadius = 10
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		return imageView
	}()
	
	private let nameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 12), textColor: UIColor.dark60, text: "Test Name")
		label.numberOfLines = 0
		return label
	}()
	
	private lazy var ratingButton: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.star)?.withTintColor(.systemYellow)
		button.setImage(image, for: .normal)
		button.setTitle("0", for: .normal)
		button.setTitleColor(UIColor.systemYellow, for: .normal)
		return button
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
		button.widthAnchor.constraint(equalToConstant: 50).isActive = true
		button.heightAnchor.constraint(equalToConstant: 25).isActive = true
		button.layer.cornerRadius = 5
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
		tutorImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor,
							  right: contentView.rightAnchor, paddingLeft: 16, paddingRight: 24, height: 200)
		
		contentView.addSubview(nameLabel)
		nameLabel.anchor(top: tutorImageView.bottomAnchor, left: contentView.leftAnchor,
						 right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 16, paddingRight: 16)
		
		contentView.addSubview(ratingButton)
		ratingButton.anchor(top: tutorImageView.bottomAnchor, right: tutorImageView.rightAnchor, paddingTop: 4)
		
		contentView.addSubview(followersLabel)
		followersLabel.anchor(top: nameLabel.bottomAnchor, left: tutorImageView.leftAnchor, paddingTop: 16)
		
		contentView.addSubview(subjectButton)
		subjectButton.centerYAnchor.constraint(equalTo: followersLabel.centerYAnchor).isActive = true
		subjectButton.anchor(right: tutorImageView.rightAnchor)
		
	}
	
	// MARK: - Helpers
	
	func configure() {
		guard let tutor = tutor else { return }
		let imageUrl = URL(string: tutor.profileImageURL)
		nameLabel.text = tutor.name
		tutorImageView.kf.setImage(with: imageUrl)
		followersLabel.text = "\(tutor.followers.count)  Followers"
		subjectButton.setTitle(tutor.subject, for: .normal)
	}
	
}
