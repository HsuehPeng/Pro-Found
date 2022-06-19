//
//  ProfileMainTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/13.
//

import UIKit
import FirebaseAuth

enum ProfileActions: String {
	case follow = "Follow"
	case following = "Following"
	case becomeTutor = "Become Tutor"
	case resignTutor = "Resign Tutor"
}

class TutorProfileMainTableViewCell: UITableViewCell {

	static let reuseIdentifier = "\(TutorProfileMainTableViewCell.self)"
	
	// MARK: - Properties
	
	var tutor: User? {
		didSet {
			configure()
		}
	}
	
	var user: User?
	
	var isFollowed: Bool = false {
		didSet {
			print(isFollowed)
		}
	}
	
	private let backImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.backgroundColor = .systemYellow
		return imageView
	}()
	
	private let profileView: UIView = {
		let view = UIView()
		view.backgroundColor = .ocean20
		view.layer.cornerRadius = 24
		return view
	}()
	
	private let profilePhotoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.layer.cornerRadius = 24
		imageView.backgroundColor = .gray
		return imageView
	}()
	
	private let nameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 20),
											   textColor: UIColor.dark, text: "TestName")
		return label
	}()
	
	private let usernameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14),
											   textColor: UIColor.dark40, text: "TestUsername")
		return label
	}()
	
	private lazy var profileActionButton: UIButton = {
		let button = CustomUIElements().makeSmallButton(buttonColor: UIColor.clear,
												 buttonTextColor: UIColor.dark30,
															 borderColor: UIColor.dark30,
															 buttonText: "Follow")
		button.widthAnchor.constraint(equalToConstant: 128).isActive = true
		button.addTarget(self, action: #selector(handleProfileAction), for: .touchUpInside)
		return button
	}()
	
	private let followerNumber: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 16),
											   textColor: UIColor.dark60, text: "100")
		return label
	}()
	
	private let followersLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14),
											   textColor: UIColor.dark40, text: "Followers")
		return label
	}()
	
	private let classBookedNumber: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 16),
											   textColor: UIColor.dark60, text: "50")
		return label
	}()
	
	private let classBookedLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14),
											   textColor: UIColor.dark40, text: "Class Booked")
		return label
	}()
	
	private let ratingNumber: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 16),
											   textColor: UIColor.dark60, text: "5/5")
		return label
	}()
	
	private let ratingLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14),
											   textColor: UIColor.dark40, text: "Rating")
		return label
	}()
	
	private let introTextLabel: UILabel = {
		let textLabel = UILabel()
		textLabel.textColor = UIColor.dark40
		textLabel.font = UIFont.customFont(.manropeRegular, size: 14)
		textLabel.numberOfLines = 0
		textLabel.text = """
		Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. \
		Cras vulputate turpis et ipsum suscipit, ac venenatis.Class aptent taciti sociosqu ad litora torquent per conubia nostra, \
		per inceptos himenaeos. Cras vulputate turpis et ipsum suscipit, ac venenatis.
		"""
		textLabel.translatesAutoresizingMaskIntoConstraints = false
		return textLabel
	}()
	
	private let schoolLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 14),
											   textColor: UIColor.dark40, text: "University of Illinois")
		return label
	}()
	
	private let majorSubjectLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
											   textColor: UIColor.dark40, text: "Mechanical Engineering")
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
		contentView.addSubview(backImageView)
		backImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, height: 812 * (280 / 812))
		
		contentView.addSubview(profileView)
		profileView.anchor(top: backImageView.bottomAnchor, left: contentView.leftAnchor,
						   bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: -28)
//		profileView.heightAnchor.constraint(equalToConstant: 560).isActive = true
		
		profileView.addSubview(profilePhotoImageView)
		profilePhotoImageView.anchor(top: profileView.topAnchor, left: profileView.leftAnchor, paddingTop: -56, paddingLeft: 24)
		profilePhotoImageView.setDimensions(width: 84, height: 92)
		
		profileView.addSubview(nameLabel)
		nameLabel.anchor(top: profileView.topAnchor, left: profileView.leftAnchor, paddingTop: 61, paddingLeft: 24)
		
		profileView.addSubview(usernameLabel)
		usernameLabel.anchor(top: nameLabel.bottomAnchor, left: profileView.leftAnchor, paddingTop: 4, paddingLeft: 24)
		
		profileView.addSubview(profileActionButton)
		profileActionButton.centerY(inView: nameLabel)
		profileActionButton.anchor(right: profileView.rightAnchor, paddingRight: 24)
		
		let followersVStack = UIStackView(arrangedSubviews: [followerNumber, followersLabel])
		followersVStack.axis = .vertical
		followersVStack.alignment = .center
		followersVStack.spacing = 2
		
		let classBookedVStack = UIStackView(arrangedSubviews: [classBookedNumber, classBookedLabel])
		classBookedVStack.axis = .vertical
		classBookedVStack.alignment = .center
		classBookedVStack.spacing = 2
		
		let ratingVStack = UIStackView(arrangedSubviews: [ratingNumber, ratingLabel])
		ratingVStack.axis = .vertical
		ratingVStack.alignment = .center
		ratingVStack.spacing = 2
		
		let profileViewHStack = UIStackView(arrangedSubviews: [followersVStack, classBookedVStack, ratingVStack])
		profileViewHStack.distribution = .fillEqually
		profileView.addSubview(profileViewHStack)
		profileViewHStack.anchor(top: usernameLabel.bottomAnchor, left: profileView.leftAnchor, right: profileView.rightAnchor, paddingTop: 36)
		
		profileView.addSubview(introTextLabel)
		introTextLabel.anchor(top: profileViewHStack.bottomAnchor, left: profileView.leftAnchor,
							  right: profileView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
		
		profileView.addSubview(schoolLabel)
		schoolLabel.anchor(top: introTextLabel.bottomAnchor, left: profileView.leftAnchor,
							  right: profileView.rightAnchor, paddingTop: 36, paddingLeft: 24, paddingRight: 24)
		
		profileView.addSubview(majorSubjectLabel)
		majorSubjectLabel.anchor(top: schoolLabel.bottomAnchor, left: profileView.leftAnchor, bottom: profileView.bottomAnchor,
							  right: profileView.rightAnchor, paddingLeft: 24, paddingBottom: 36, paddingRight: 24)
	}
	
	// MARK: - Actions
	
	@objc func handleProfileAction() {
		guard let user = user, let tutor = tutor else { return }
		if isFollowed {
			UserServie.shared.unfollow(sender: user, receiver: tutor)
			profileActionButton.setTitle("Follow", for: .normal)
			isFollowed = false
		} else {
			UserServie.shared.follow(sender: user, receiver: tutor)
			profileActionButton.setTitle("Unfollow", for: .normal)
			isFollowed = true
		}
	}
	
	// MARK: - Helpers
	
	func configure() {
		guard let tutor = tutor, let user = user else { return }
		nameLabel.text = tutor.name
		classBookedNumber.text = "\(tutor.courseBooked)"
		
		if tutor.userID == user.userID {
			profileActionButton.isEnabled = false
			profileActionButton.backgroundColor = .black
		}
		
		if isFollowed {
			profileActionButton.setTitle("Unfollow", for: .normal)
		} else {
			profileActionButton.setTitle("Follow", for: .normal)
		}
		
	}
}
