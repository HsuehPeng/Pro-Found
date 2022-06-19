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
		imageView.image = UIImage.asset(.event)
		imageView.setDimensions(width: 100, height: 128)
//		imageView.contentMode = .scaleAspectFit
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
		return imageView
	}()
	
	private let organizerNameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: .dark40, text: "Organizer Name")
		return label
	}()
	
	private let addressLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: .dark40, text: "Event address")
		return label
	}()
	
	lazy var bookEventButton: UIButton = {
		let button = CustomUIElements().makeSmallButton(buttonColor: .orange, buttonTextColor: .white, borderColor: .clear, buttonText: "Book")
		button.addTarget(self, action: #selector(bookEvent), for: .touchUpInside)
		button.setTitle("Booked", for: .disabled)
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
		eventImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
							  paddingTop: 16, paddingLeft: 16, paddingBottom: 16)
		
		contentView.addSubview(eventTitleLabel)
		eventTitleLabel.anchor(top: eventImageView.topAnchor, left: eventImageView.rightAnchor, right: contentView.rightAnchor,
							   paddingTop: 4, paddingLeft: 12, paddingRight: 16)

		contentView.addSubview(timeLabel)
		timeLabel.anchor(top: eventTitleLabel.bottomAnchor, left: eventImageView.rightAnchor, right: contentView.rightAnchor,
						 paddingTop: 4, paddingLeft: 12, paddingRight: 16)
		
		contentView.addSubview(addressLabel)
		addressLabel.anchor(top: timeLabel.bottomAnchor, left: eventImageView.rightAnchor,
							right: contentView.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingRight: 16)
		
		contentView.addSubview(bookEventButton)
		bookEventButton.anchor(top: addressLabel.bottomAnchor, left: eventImageView.rightAnchor,
							right: contentView.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingRight: 16)

		contentView.addSubview(organizerImageView)
		organizerImageView.anchor(left: eventImageView.rightAnchor, bottom: contentView.bottomAnchor, paddingLeft: 12, paddingBottom: 16)

		contentView.addSubview(organizerNameLabel)
		organizerNameLabel.centerY(inView: organizerImageView, leftAnchor: organizerImageView.rightAnchor, paddingLeft: 8)
	}
	
	// MARK: - Actions
	
	@objc func bookEvent() {
		delegate?.bookEvent(self)
	}
	
	// MARK: - Helpers
	
	private func configure() {
		guard let event = event else { return }
		
		checkIfBooked(event: event)
		
		let imageUrl = URL(string: event.imageURL)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM dd, yyyy ∙ h:mm a"
		let eventDate = Date(timeIntervalSince1970: event.timestamp)
		eventImageView.kf.setImage(with: imageUrl)
		eventTitleLabel.text = event.eventTitle
		timeLabel.text = dateFormatter.string(from: eventDate)
		addressLabel.text = event.location
		organizerNameLabel.text = event.organizerName
	}
	
	private func checkIfBooked(event: Event) {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		if event.participants.contains(uid) {
			bookEventButton.backgroundColor = .dark20
			bookEventButton.isEnabled = false
		}
	}
}
