//
//  ProfileMainTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/13.
//

import UIKit
import FirebaseAuth
import Cosmos
import Kingfisher
import PhotosUI

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
	
	var isFollowed: Bool = false
	
	var rateViewIsUp: Bool = false
	
	lazy var backImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.backgroundColor = .systemYellow
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleBackgroudImageTap))
		imageView.isUserInteractionEnabled = true
		imageView.addGestureRecognizer(tapGestureRecognizer)
		return imageView
	}()
	
	private let profileView: UIView = {
		let view = UIView()
		view.backgroundColor = .light60
		view.layer.cornerRadius = 24
		return view
	}()
	
	private let profilePhotoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.layer.cornerRadius = 24
		imageView.backgroundColor = .gray
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private let nameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 20),
											   textColor: UIColor.dark, text: "TestName")
		return label
	}()
	
	private let subjectLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14),
											   textColor: UIColor.dark40, text: "Subject")
				
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
												 textColor: UIColor.orange40, text: "100")
		return label
	}()
	
	private let followersLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14),
											   textColor: UIColor.dark40, text: "Followers")
		return label
	}()
	
	private let classBookedNumber: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 16),
											   textColor: UIColor.orange40, text: "50")
		return label
	}()
	
	private let classBookedLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14),
											   textColor: UIColor.dark40, text: "Class Booked")
		return label
	}()
	
	private lazy var ratingButtonNumber: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.star)?.withTintColor(.orange40)
		button.setImage(image, for: .normal)
		button.setTitle("0", for: .normal)
		button.setTitleColor(UIColor.orange40, for: .normal)
		button.addTarget(self, action: #selector(handleRateTutor), for: .touchUpInside)
		
		return button
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
	
	private let ratingView: UIView = {
		let view = UIView()
		view.backgroundColor = .dark40
		view.setDimensions(width: 170, height: 40)
		view.layer.cornerRadius = 20

		return view
	}()
	
	private let starView: CosmosView = {
		let starView = CosmosView()
		starView.settings.filledColor = .orange40
		starView.settings.fillMode = .full
		starView.rating = 0
		return starView
	}()
	
	private lazy var sendButton: UIButton = {
		lazy var sentButton = UIButton()
		let image = UIImage.asset(.send)?.withTintColor(.orange40)
		sentButton.setImage(image, for: .normal)
		sentButton.addTarget(self, action: #selector(handleSendRating), for: .touchUpInside)
		return sentButton
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
		
		profileView.addSubview(subjectLabel)
		subjectLabel.anchor(top: nameLabel.bottomAnchor, left: profileView.leftAnchor, paddingTop: 4, paddingLeft: 24)
		
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
		
		let ratingVStack = UIStackView(arrangedSubviews: [ratingButtonNumber, ratingLabel])
		ratingVStack.axis = .vertical
		ratingVStack.alignment = .center
		ratingVStack.spacing = 2
		
		let profileViewHStack = UIStackView(arrangedSubviews: [followersVStack, classBookedVStack, ratingVStack])
		profileViewHStack.distribution = .fillEqually
		profileView.addSubview(profileViewHStack)
		profileViewHStack.anchor(top: subjectLabel.bottomAnchor, left: profileView.leftAnchor, right: profileView.rightAnchor, paddingTop: 36)
		
		profileView.addSubview(introTextLabel)
		introTextLabel.anchor(top: profileViewHStack.bottomAnchor, left: profileView.leftAnchor,
							  right: profileView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
		
		profileView.addSubview(schoolLabel)
		schoolLabel.anchor(top: introTextLabel.bottomAnchor, left: profileView.leftAnchor,
							  right: profileView.rightAnchor, paddingTop: 36, paddingLeft: 24, paddingRight: 24)
		
		profileView.addSubview(majorSubjectLabel)
		majorSubjectLabel.anchor(top: schoolLabel.bottomAnchor, left: profileView.leftAnchor, bottom: profileView.bottomAnchor,
							  right: profileView.rightAnchor, paddingLeft: 24, paddingBottom: 36, paddingRight: 24)
		
		ratingView.addSubview(starView)
		starView.centerY(inView: ratingView, leftAnchor: ratingView.leftAnchor, paddingLeft: 12)
		
		ratingView.addSubview(sendButton)
		sendButton.centerY(inView: ratingView, leftAnchor: starView.rightAnchor, paddingLeft: 8)
	}
	
	// MARK: - Actions
	
	@objc func handleBackgroudImageTap() {
		
	}
	
	@objc func handleRateTutor() {
		guard let user = user, let tutor = tutor, user.userID != tutor.userID else { return }
		
		if !rateViewIsUp {
			contentView.addSubview(ratingView)
			ratingView.anchor(bottom: ratingButtonNumber.topAnchor, right: contentView.rightAnchor, paddingBottom: 8, paddingRight: 8)
			ratingView.alpha = 0
			ratingView.transform = CGAffineTransform(translationX: 10, y: 10)
			rateViewIsUp = true
			UIView.animate(withDuration: 0.3) {
				self.ratingView.alpha = 1
				self.ratingView.transform = CGAffineTransform.identity
			}
		} else {
			rateViewIsUp = false
			UIView.animate(withDuration: 0.3, animations: {
				self.ratingView.alpha = 0
			}) { status in
				self.ratingView.removeFromSuperview()
			}
		}
	}
	
	@objc func handleSendRating() {
		guard let user = user, let tutor = tutor else { return }
		UserServie.shared.rateTutor(senderID: user.userID, receiverID: tutor.userID, rating: starView.rating)
		rateViewIsUp = false
		UIView.animate(withDuration: 0.4, animations: {
			self.ratingView.alpha = 0
		}) { status in
			self.ratingView.removeFromSuperview()
		}
	}
	
	@objc func handleProfileAction() {
		guard let user = user, let tutor = tutor else { return }
		
		if isFollowed {
			UserServie.shared.unfollow(senderID: user.userID, receiverID: tutor.userID)
			profileActionButton.setTitle("Follow", for: .normal)
			isFollowed = false
		} else {
			UserServie.shared.follow(senderID: user.userID, receiverID: tutor.userID)
			profileActionButton.setTitle("Unfollow", for: .normal)
			isFollowed = true
		}
	}
	
	// MARK: - Helpers
	
	func configure() {
		guard let tutor = tutor, let user = user else { return }
		let imageUrl = URL(string: tutor.profileImageURL)
		nameLabel.text = tutor.name
		profilePhotoImageView.kf.setImage(with: imageUrl)
		subjectLabel.text = tutor.subject
		followerNumber.text = String(tutor.followers.count)
		classBookedNumber.text = "\(tutor.courseBooked)"
		ratingButtonNumber.setTitle(calculateAverageRating(tutor: tutor), for: .normal)
		introTextLabel.text = tutor.introContentText
		schoolLabel.text = tutor.school
		majorSubjectLabel.text = tutor.schoolMajor
		
		if tutor.userID == user.userID {
			profileActionButton.isEnabled = false
			profileActionButton.backgroundColor = .dark10
		}
		
		if isFollowed {
			profileActionButton.setTitle("Unfollow", for: .normal)
		} else {
			profileActionButton.setTitle("Follow", for: .normal)
		}
	}
	
	func calculateAverageRating(tutor: User) -> String {
		var ratingSum = 0.0
		for rating in tutor.ratings {
			ratingSum += rating.first?.value ?? 0
		}
		let averageRating = ratingSum / Double(tutor.ratings.count)
		let roudedAverageRating = round(averageRating * 10) / 10
		if roudedAverageRating == 0 {
			return "0"
		} else {
			return String(roudedAverageRating)
		}
	}
}
