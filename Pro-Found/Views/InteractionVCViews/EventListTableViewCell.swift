//
//  EventListTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/19.
//

import UIKit
import FirebaseAuth
import Kingfisher

protocol EventListTableViewCellDelegate: AnyObject {
	func bookEvent(_ cell: EventListTableViewCell)
}

class EventListTableViewCell: UITableViewCell {
	
	static let reuseIdentifier = "\(EventListTableViewCell.self)"
	
	weak var delegate: EventListTableViewCellDelegate?

	// MARK: - Properties
	
	var event: Event? {
		didSet {
			configure()
		}
	}
	
	private let eventImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .orange10
		imageView.setDimensions(width: 100, height: 128)
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.layer.cornerRadius = 12
		return imageView
	}()
	
	private let eventTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 14),
												 textColor: .dark60, text: "Event Title")
		return label
	}()
	
	private let timeLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: .dark40, text: "Event Time")
		return label
	}()
	
	private let organizerImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.setDimensions(width: 32, height: 32)
		imageView.layer.cornerRadius = 16
		imageView.backgroundColor = .dark40
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		return imageView
	}()
	
	private let organizerNameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: .dark40, text: "Organizer Name")
		label.numberOfLines = 2
		return label
	}()
	
	private let addressLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: .dark40, text: "Event address")
		label.numberOfLines = 2
		return label
	}()
	
	private lazy var bookEventButton: UIButton = {
		let button = UIButton()
		button.addTarget(self, action: #selector(bookEvent), for: .touchUpInside)
		button.backgroundColor = .light60
		button.layer.borderColor = UIColor.orange.cgColor
		button.layer.borderWidth = 1
		button.layer.cornerRadius = 36 / 2
		button.setImage(UIImage.asset(.arrow_right)?.withTintColor(.orange), for: .normal)
		button.setDimensions(width: 36, height: 36)
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
	
	private func setupUI() {
		contentView.addSubview(eventImageView)
		contentView.addSubview(eventTitleLabel)
		contentView.addSubview(timeLabel)
		contentView.addSubview(addressLabel)
		contentView.addSubview(organizerImageView)
		contentView.addSubview(organizerNameLabel)
		contentView.addSubview(bookEventButton)
		
		eventImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
							  paddingTop: 16, paddingLeft: 16 ,paddingBottom: 16)
		
		eventTitleLabel.anchor(top: contentView.topAnchor, left: eventImageView.rightAnchor, right: contentView.rightAnchor,
							   paddingTop: 16, paddingLeft: 12, paddingRight: 16)

		timeLabel.anchor(top: eventTitleLabel.bottomAnchor, left: eventImageView.rightAnchor, right: contentView.rightAnchor,
						 paddingTop: 6, paddingLeft: 12, paddingRight: 16)
		
		addressLabel.anchor(top: timeLabel.bottomAnchor, left: eventImageView.rightAnchor,
							right: contentView.rightAnchor, paddingTop: 6, paddingLeft: 12, paddingRight: 16)
		
		organizerImageView.anchor(top: addressLabel.bottomAnchor, left: eventImageView.rightAnchor,
								  paddingTop: 8, paddingLeft: 12)

		organizerNameLabel.centerY(inView: organizerImageView, leftAnchor: organizerImageView.rightAnchor, paddingLeft: 8)
		organizerNameLabel.rightAnchor.constraint(equalTo: bookEventButton.leftAnchor, constant: -16).isActive = true
		
		bookEventButton.centerY(inView: organizerImageView)
		bookEventButton.anchor(right: contentView.rightAnchor, paddingRight: 32)
	}
	
	// MARK: - Actions
	
	@objc func bookEvent() {
		delegate?.bookEvent(self)
	}
	
	// MARK: - Helpers
	
	private func configure() {
		guard let event = event else { return }
		
		let organizerImageUrl = URL(string: event.organizer.profileImageURL)
		let eventImageUrl = URL(string: event.imageURL)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM dd, yyyy ∙ h:mm a"
		let eventDate = Date(timeIntervalSince1970: event.timestamp)
		
		eventImageView.kf.setImage(with: eventImageUrl)
		organizerImageView.kf.setImage(with: organizerImageUrl)
		eventTitleLabel.text = event.eventTitle
		timeLabel.text = dateFormatter.string(from: eventDate)
		addressLabel.text = event.location
		organizerNameLabel.text = event.organizer.name
	}

}
