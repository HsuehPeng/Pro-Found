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
 
protocol TutorProfileMainTableViewCellDelegate: AnyObject {
	func chooseBackgroundImage(_ cell: TutorProfileMainTableViewCell)
	func rateTutor(_ cell: TutorProfileMainTableViewCell)
	func changeBlockingStatus(_ cell: TutorProfileMainTableViewCell)
	func handleGoChat(_ cell: TutorProfileMainTableViewCell)
	func toggleFollowingStatus(_ cell: TutorProfileMainTableViewCell)
}

class TutorProfileMainTableViewCell: UITableViewCell {

	static let reuseIdentifier = "\(TutorProfileMainTableViewCell.self)"
	
	weak var delegate: TutorProfileMainTableViewCellDelegate?
	
	// MARK: - Properties
	
	var tutor: User? {
		didSet {
			configure()
		}
	}
	
	var user: User? {
		didSet {
			configure()
		}
	}
	
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
	
	lazy var chatButton: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.chat_new)?.withRenderingMode(.alwaysOriginal).withTintColor(.dark40)
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(handleChat), for: .touchUpInside)
		return button
	}()
	
	lazy var blockUserButton: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.password_show)?.withRenderingMode(.alwaysOriginal).withTintColor(.dark40)
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(handleBlockUser), for: .touchUpInside)
		return button
	}()
	
	private let nameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 20),
												 textColor: UIColor.dark60, text: "TestName")
		label.numberOfLines = 2
		return label
	}()
	
	private let subjectButton: UIButton = {
		let button = UIButton()
		button.setTitle("Student", for: .normal)
		button.setTitleColor(UIColor.light60, for: .normal)
		button.titleLabel?.font = UIFont.customFont(.interSemiBold, size: 10)
		button.widthAnchor.constraint(equalToConstant: 70).isActive = true
		button.heightAnchor.constraint(equalToConstant: 25).isActive = true
		button.layer.cornerRadius = 5
		button.backgroundColor = .orange
		return button
	}()
	
	lazy var profileActionButton: UIButton = {
		let button = CustomUIElements().makeSmallButton(buttonColor: UIColor.light60, buttonTextColor: UIColor.orange,
														borderColor: .orange, buttonText: "Follow")
		button.setTitleColor(UIColor.dark20, for: .disabled)
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
		button.setTitleColor(UIColor.orange40, for: .normal)
		button.titleLabel?.font = UIFont.customFont(.interSemiBold, size: 16)
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
	
	let ratingView: UIView = {
		let view = UIView()
		view.backgroundColor = .dark40
		view.setDimensions(width: 170, height: 40)
		view.layer.cornerRadius = 20

		return view
	}()
	
	let starView: CosmosView = {
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
		profileView.addSubview(profileActionButton)
		contentView.addSubview(profileView)
		profileView.addSubview(profilePhotoImageView)
		profileView.addSubview(blockUserButton)
		profileView.addSubview(chatButton)
		profileView.addSubview(nameLabel)
		profileView.addSubview(subjectButton)
		profileActionButton.centerY(inView: nameLabel)
		
		backImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, height: 812 * (280 / 812))
		
		profileView.anchor(top: backImageView.bottomAnchor, left: contentView.leftAnchor,
						   bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: -28)
//		profileView.heightAnchor.constraint(equalToConstant: 560).isActive = true
		
		profilePhotoImageView.anchor(top: profileView.topAnchor, left: profileView.leftAnchor, paddingTop: -56, paddingLeft: 24)
		profilePhotoImageView.setDimensions(width: 84, height: 92)
		
		blockUserButton.anchor(top: profileView.topAnchor, right: profileView.rightAnchor, paddingTop: 16, paddingRight: 24)
		
		chatButton.anchor(top: profileView.topAnchor, right: blockUserButton.leftAnchor, paddingTop: 16, paddingRight: 24)
		
		nameLabel.anchor(top: profileView.topAnchor, left: profileView.leftAnchor,
						 right: profileActionButton.leftAnchor, paddingTop: 61, paddingLeft: 24, paddingRight: 12)
		
		subjectButton.anchor(top: nameLabel.bottomAnchor, left: profileView.leftAnchor, paddingTop: 4, paddingLeft: 24)
		
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
		profileViewHStack.alignment = .lastBaseline
		profileView.addSubview(profileViewHStack)
		profileViewHStack.anchor(top: subjectButton.bottomAnchor, left: profileView.leftAnchor, right: profileView.rightAnchor, paddingTop: 36)
		
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
	
	@objc func handleChat() {
		delegate?.handleGoChat(self)
	}
	
	@objc func handleBlockUser() {
		delegate?.changeBlockingStatus(self)
	}
	
	@objc func handleBackgroudImageTap() {
		delegate?.chooseBackgroundImage(self)
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
		delegate?.rateTutor(self)
	}
	
	@objc func handleProfileAction() {
		
		delegate?.toggleFollowingStatus(self)
	}
	
	// MARK: - Helpers
	
	func configure() {
		guard let tutor = tutor, let user = user else { return }
		let profileImageUrl = URL(string: tutor.profileImageURL)
		let backgroundImageUrl = URL(string: tutor.backgroundImageURL)
		
		nameLabel.text = tutor.name
		profilePhotoImageView.kf.setImage(with: profileImageUrl)
		backImageView.kf.setImage(with: backgroundImageUrl)
		followerNumber.text = String(tutor.followers.count)
		
		setTutorProfileColor(subject: tutor.subject, targetView: profileView)
		setSubjectButtonColor(subject: tutor.subject, targetView: subjectButton)
		subjectButton.setTitle(tutor.subject, for: .normal)
		
		classBookedNumber.text = "\(tutor.courseBooked)"
		ratingButtonNumber.setTitle(calculateAverageRating(tutor: tutor), for: .normal)
		introTextLabel.text = tutor.introContentText
		schoolLabel.text = tutor.school
		majorSubjectLabel.text = tutor.schoolMajor
		
		
		if user.blockedUsers.contains(tutor.userID) {
			print("Ture")
			blockUserButton.setImage(UIImage.asset(.password_hide), for: .normal)
		} else {
			print("false")
			blockUserButton.setImage(UIImage.asset(.password_show), for: .normal)
		}
		
		if tutor.userID == user.userID {
			blockUserButton.isHidden = true
			chatButton.isHidden = true
			profileActionButton.isEnabled = false
			profileActionButton.layer.borderColor = UIColor.dark20.cgColor
		}
		
		if isFollowed {
			profileActionButton.setTitle("Unfollow", for: .normal)
		} else {
			profileActionButton.setTitle("Follow", for: .normal)
		}
	}
	
	func calculateAverageRating(tutor: User) -> String {
		guard !tutor.ratings.isEmpty else { return "Non"}
		var ratingSum = 0.0
		for rating in tutor.ratings {
			ratingSum += rating.first?.value ?? 0
		}
		let averageRating = ratingSum / Double(tutor.ratings.count)
		let roudedAverageRating = round(averageRating * 10) / 10
		return String(roudedAverageRating)
	}
}
