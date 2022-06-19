//
//  EventListTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/19.
//

import UIKit

class EventListTableViewCell: UITableViewCell {
	
	static let reuseIdentifier = "\(EventListTableViewCell.self)"

	// MARK: - Properties
	
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

		contentView.addSubview(organizerImageView)
		organizerImageView.anchor(left: eventImageView.rightAnchor, bottom: contentView.bottomAnchor, paddingLeft: 12, paddingBottom: 16)

		contentView.addSubview(organizerNameLabel)
		organizerNameLabel.centerY(inView: organizerImageView, leftAnchor: organizerImageView.rightAnchor, paddingLeft: 8)


	}
}
