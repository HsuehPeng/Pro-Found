//
//  EventDetailContentTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/20.
//

import UIKit
import Kingfisher

class EventDetailContentTableViewCell: UITableViewCell {
	
	static let reuseIdentifier = "\(EventDetailContentTableViewCell.self)"
	
	// MARK: - Properties
	
	var event: Event?
	
	var participants = [User]() {
		didSet {
			setupUI()
			configureUI()
		}
	}
	
	private let detailTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 14),
												 textColor: .dark60, text: "Detail")
		return label
	}()

	private let detailContentLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14),
												 textColor: .dark40, text: "Detail Content")
		label.numberOfLines = 0
		return label
	}()
	
	private let participantTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 14),
												 textColor: .dark60, text: "Who's coming")
		return label
	}()
	
	private let participantCountLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14),
												 textColor: .dark40, text: "")
		return label
	}()
	
	// MARK: - Lifecycle
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UI
	
	func setupUI() {
		
		contentView.addSubview(detailTitleLabel)
		detailTitleLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor,
							   paddingTop: 16, paddingLeft: 16, paddingRight: 16)
		
		contentView.addSubview(detailContentLabel)
		detailContentLabel.anchor(top: detailTitleLabel.bottomAnchor, left: contentView.leftAnchor,
								 right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		contentView.addSubview(participantTitleLabel)
		participantTitleLabel.anchor(top: detailContentLabel.bottomAnchor, left: contentView.leftAnchor,
									 right: contentView.rightAnchor, paddingTop: 36, paddingLeft: 16)
		
		let participantHStack = UIStackView()
		if participants.count < 8 {
			for i in 0..<participants.count {
				makeParticipantHStack(index: i, hStack: participantHStack)
			}
		} else {
			for i in 0..<8 {
				makeParticipantHStack(index: i, hStack: participantHStack)
			}
		}
		
		participantHStack.spacing = 8
		
		contentView.addSubview(participantHStack)
		participantHStack.anchor(top: participantTitleLabel.bottomAnchor, left: contentView.leftAnchor, paddingTop: 12, paddingLeft: 16)
		
		contentView.addSubview(participantCountLabel)
		participantCountLabel.anchor(top: participantHStack.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
									 right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 16,
									 paddingBottom: 12, paddingRight: 16)
	}
	
	// MARK: - Actions
	
	// MARK: - Helpers
	
	func configureUI() {
		guard let event = event else { return }
		detailContentLabel.text = event.introText
		participantCountLabel.text = "\(event.participants.count) Participants"
	}
	
	func makeParticipantHStack(index: Int, hStack: UIStackView) {
		let participant = participants[index]
		let imageView = makeParticipantImageView(participant: participant, imageURL: participant.profileImageURL)
		imageView.setDimensions(width: 32, height: 32)
		let imageUrl = URL(string: participant.profileImageURL)
		imageView.kf.setImage(with: imageUrl)
		imageView.layer.cornerRadius = 32 / 2
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		hStack.addArrangedSubview(imageView)
	}
	
	func makeParticipantImageView(participant: User, imageURL: String) -> UIImageView {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.setDimensions(width: 32, height: 32)
		imageView.layer.cornerRadius = 32 / 2
		let imageUrl = URL(string: imageURL)
		imageView.kf.setImage(with: imageUrl)
		return imageView
	}

}
