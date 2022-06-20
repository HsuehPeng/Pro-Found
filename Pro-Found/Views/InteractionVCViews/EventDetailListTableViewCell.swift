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
	
	private let eventImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.setDimensions(width: 48, height: 48)
		imageView.layer.cornerRadius = 48 / 2
		imageView.image = UIImage.asset(.account_circle)
		return imageView
	}()
	
	private let eventNameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 14), textColor: .dark60, text: "Test Name")
		return label
	}()
	
	lazy var followButton: UIButton = {
		let button = CustomUIElements().makeSmallButton(buttonColor: .white, buttonTextColor: .orange, borderColor: .orange, buttonText: "Follow", borderWidth: 1)
		button.widthAnchor.constraint(equalToConstant: 76).isActive = true
		button.addTarget(self, action: #selector(handleFollowingAction), for: .touchUpInside)
		return button
	}()
	
	private let dividerLine1: UIView = {
		let view = UIView()
		view.backgroundColor = .dark10
		return view
	}()
	
	private let dateImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.setDimensions(width: 48, height: 48)
		imageView.layer.cornerRadius = 48 / 2
		imageView.image = UIImage.asset(.account_circle)
		return imageView
	}()
	
	private let dateLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 14), textColor: .dark60, text: "Test Date")
		return label
	}()
	
	private let timeLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 14), textColor: .dark60, text: "Test Time")
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
		contentView.addSubview(eventImageView)
		eventImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 8, paddingLeft: 16)
		
		contentView.addSubview(eventNameLabel)
		eventNameLabel.centerY(inView: eventImageView, leftAnchor: eventImageView.rightAnchor, paddingLeft: 8)
		
		contentView.addSubview(followButton)
		followButton.anchor(right: contentView.rightAnchor, paddingRight: 16)
		followButton.centerY(inView: eventImageView)
		
		contentView.addSubview(dividerLine1)
		dividerLine1.anchor(top: eventImageView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, height: 1)
		
		contentView.addSubview(dateImageView)
		dateImageView.anchor(top: dividerLine1.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
							 paddingTop: 8, paddingLeft: 16, paddingBottom: 8)
		
		contentView.addSubview(dateLabel)
		dateLabel.centerY(inView: dateImageView, leftAnchor: dateImageView.rightAnchor, paddingLeft: 8)
		
	}
	
	// MARK: - Actions
	
	@objc func handleFollowingAction() {
		delegate?.handleFollowing(self)
	}
	
	// MARK: - Helpers
	
	func configureUI() {
		guard let event = event, let isFollow = isFollow else { return }
		let eventImageUrl = URL(string: event.organizer.profileImageURL)
		eventImageView.kf.setImage(with: eventImageUrl)
		eventNameLabel.text = event.organizerName
		
		let dateformatter = DateFormatter()
		dateformatter.dateFormat = "MMMM dd, yyyy∙HH:mm"
		let eventDate = Date(timeIntervalSince1970: event.timestamp)
		let date = dateformatter.string(from: eventDate)

		dateLabel.text = date
		
		if isFollow {
			followButton.setTitle("Unfollow", for: .normal)
		} else {
			followButton.setTitle("Follow", for: .normal)
		}
	}

}
