//
//  EventDetailListTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/20.
//

import UIKit
import FirebaseAuth
import Kingfisher

protocol EventDetailListTableViewCellDelegate: AnyObject {
	func handleFollowing(_ cell: EventDetailListTableViewCell)
	func goToPublicProfile(_ cell: EventDetailListTableViewCell)
}

class EventDetailListTableViewCell: UITableViewCell {
	
	static let reuseIdentifier = "\(EventDetailListTableViewCell.self)"
	
	weak var delegate: EventDetailListTableViewCellDelegate?
		
	// MARK: - Properties
		
	var event: Event? {
		didSet {
			configureUI()
		}
	}
	
	var isFollow: Bool? {
		didSet {
			configureUI()
		}
	}
	
	private lazy var eventOrganizerImageView: UIImageView = {
		let imageView = CustomUIElements().makeCircularProfileImageView(width: 48, height: 48)

		let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
		imageView.addGestureRecognizer(tap)
		imageView.isUserInteractionEnabled = true
		
		return imageView
	}()
	
	private let eventOrganizerNameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 14), textColor: .dark60, text: "Test Name")
		return label
	}()
	
	lazy var followButton: UIButton = {
		let button = CustomUIElements().makeSmallButton(buttonColor: UIColor.light60, buttonTextColor: UIColor.orange,
														borderColor: .orange, buttonText: "Follow")
		button.setTitleColor(UIColor.dark20, for: .disabled)
		button.widthAnchor.constraint(equalToConstant: 76).isActive = true
		button.addTarget(self, action: #selector(handleFollowingAction), for: .touchUpInside)
		return button
	}()
	
	private let dateImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.setDimensions(width: 48, height: 48)
		imageView.layer.cornerRadius = 48 / 2
		imageView.image = UIImage.asset(.calendar_selected)?.withTintColor(.orange)
		return imageView
	}()
	
	private let dateLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12), textColor: .dark40, text: "Test Date")
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
		contentView.addSubview(eventOrganizerImageView)
		contentView.addSubview(eventOrganizerNameLabel)
		contentView.addSubview(followButton)
		contentView.addSubview(dateImageView)
		contentView.addSubview(dateLabel)
		
		eventOrganizerImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 8, paddingLeft: 16)
		
		eventOrganizerNameLabel.centerY(inView: eventOrganizerImageView, leftAnchor: eventOrganizerImageView.rightAnchor, paddingLeft: 8)
		eventOrganizerNameLabel.rightAnchor.constraint(equalTo: followButton.leftAnchor, constant: -16).isActive = true
		
		followButton.anchor(right: contentView.rightAnchor, paddingRight: 16)
		followButton.centerY(inView: eventOrganizerImageView)
		
		dateImageView.anchor(top: eventOrganizerImageView.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
							 paddingTop: 16, paddingLeft: 16, paddingBottom: 8)
		
		dateLabel.centerY(inView: dateImageView, leftAnchor: dateImageView.rightAnchor, paddingLeft: 8)
		dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
	}
	
	// MARK: - Actions
	
	@objc func handleProfileImageTapped() {
		delegate?.goToPublicProfile(self)
	}
	
	@objc func handleFollowingAction() {
		delegate?.handleFollowing(self)
	}
	
	// MARK: - Helpers
	
	func configureUI() {
		guard let event = event, let isFollow = isFollow, let uid = Auth.auth().currentUser?.uid else { return }
		let eventImageUrl = URL(string: event.organizer.profileImageURL)
		eventOrganizerImageView.kf.setImage(with: eventImageUrl)
		eventOrganizerNameLabel.text = event.organizer.name
		
		let dateformatter = DateFormatter()
		dateformatter.dateFormat = "MMMM dd, yyyy∙HH:mm"
		let eventDate = Date(timeIntervalSince1970: event.timestamp)
		let date = dateformatter.string(from: eventDate)

		dateLabel.text = date
		
		if event.userID == uid {
			followButton.isEnabled = false
			followButton.layer.borderColor = UIColor.dark20.cgColor
		}
		
		if isFollow {
			followButton.setTitle("Unfollow", for: .normal)
		} else {
			followButton.setTitle("Follow", for: .normal)
		}
	}

}
