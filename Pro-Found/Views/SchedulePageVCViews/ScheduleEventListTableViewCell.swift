//
//  ScheduleEventTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/22.
//

import UIKit
import FirebaseAuth

class ScheduleEventListTableViewCell: UITableViewCell {
	
	static let reuseIdentifier = "\(ScheduleEventListTableViewCell.self)"
	
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
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 12
		imageView.clipsToBounds = true
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
		return label
	}()
	
	private let addressLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: .dark40, text: "Event address")
		label.numberOfLines = 0
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
	
	private func setupUI() {
		contentView.addSubview(eventImageView)
		eventImageView.centerY(inView: contentView, leftAnchor: contentView.leftAnchor, paddingLeft: 16)
		
		contentView.addSubview(eventTitleLabel)
		eventTitleLabel.anchor(top: contentView.topAnchor, left: eventImageView.rightAnchor, right: contentView.rightAnchor,
							   paddingTop: 16, paddingLeft: 12, paddingRight: 16)

		contentView.addSubview(timeLabel)
		timeLabel.anchor(top: eventTitleLabel.bottomAnchor, left: eventImageView.rightAnchor, right: contentView.rightAnchor,
						 paddingTop: 4, paddingLeft: 12, paddingRight: 16)
		
		contentView.addSubview(addressLabel)
		addressLabel.anchor(top: timeLabel.bottomAnchor, left: eventImageView.rightAnchor,
							right: contentView.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingRight: 16)
		
		contentView.addSubview(organizerImageView)
		organizerImageView.anchor(top: addressLabel.bottomAnchor, left: eventImageView.rightAnchor,
								  bottom: contentView.bottomAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 24)

		contentView.addSubview(organizerNameLabel)
		organizerNameLabel.centerY(inView: organizerImageView, leftAnchor: organizerImageView.rightAnchor, paddingLeft: 8)

	}
	
	// MARK: - Actions

	// MARK: - Helpers
	
	private func configure() {
		guard let event = event else { return }
		let organizerImageUrl = URL(string: event.organizer.profileImageURL)
		let imageUrl = URL(string: event.imageURL)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM dd, yyyy ∙ h:mm a"
		let eventDate = Date(timeIntervalSince1970: event.timestamp)
		eventImageView.kf.setImage(with: imageUrl)
		organizerImageView.kf.setImage(with: organizerImageUrl)
		eventTitleLabel.text = event.eventTitle
		timeLabel.text = dateFormatter.string(from: eventDate)
		addressLabel.text = event.location
		organizerNameLabel.text = event.organizerName
	}
	
}
