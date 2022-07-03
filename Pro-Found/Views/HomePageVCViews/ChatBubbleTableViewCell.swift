//
//  ChantRoomTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/30.
//

import UIKit

class ChatBubbleTableViewCell: UITableViewCell {

	static let reuseIdentifier = "\(ChatBubbleTableViewCell.self)"
	
	// MARK: - Properties
	
	var message: Message? {
		didSet {
			configureUI()
		}
	}
	
	var bubbleLeftAnchor: NSLayoutConstraint?
	var bubbleRightAnchor: NSLayoutConstraint?
	var messageTimeRightAnchor: NSLayoutConstraint?
	var messageTimeLeftAnchor: NSLayoutConstraint?

	let messageBubbleView: UIView = {
		let view = UIView()
		view.backgroundColor = .orange
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 8
		return view
	}()
	
	let messageText: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14), textColor: .dark60, text: "")
		label.numberOfLines = 0
		return label
	}()
	
	let messageTimeLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12), textColor: .dark30, text: "asdfas")
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
		contentView.addSubview(messageBubbleView)
		messageBubbleView.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, paddingTop: 8, paddingBottom: 8)
		messageBubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 2/3).isActive = true
		bubbleLeftAnchor = messageBubbleView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12)
		bubbleLeftAnchor?.isActive = false
		bubbleRightAnchor = messageBubbleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12)
		bubbleRightAnchor?.isActive = false
		
		messageBubbleView.addSubview(messageText)
		messageText.anchor(top: messageBubbleView.topAnchor, left: messageBubbleView.leftAnchor,
						   bottom: messageBubbleView.bottomAnchor, right: messageBubbleView.rightAnchor,
						   paddingTop: 8, paddingLeft: 12, paddingBottom: 8, paddingRight: 12)
		
		contentView.addSubview(messageTimeLabel)
		messageTimeLabel.anchor(bottom: messageBubbleView.bottomAnchor, paddingBottom: 8)
		messageTimeLeftAnchor = messageTimeLabel.leftAnchor.constraint(equalTo: messageBubbleView.rightAnchor, constant: 8)
		messageTimeLeftAnchor?.isActive = false
		messageTimeRightAnchor = messageTimeLabel.rightAnchor.constraint(equalTo: messageBubbleView.leftAnchor, constant: -8)
		messageTimeRightAnchor?.isActive = false
		
	}
	
	// MARK: - Helpers
	
	func configureUI() {
		guard let message = message else { return }
		let viewModel = MessageViewModel(message: message)
		
		messageBubbleView.backgroundColor = viewModel.messageBackgroundColor
		messageText.textColor = viewModel.messageTextColor
		messageText.text = message.text
		messageTimeLabel.text = viewModel.timeString
		
		bubbleLeftAnchor?.isActive = viewModel.leftAnchorActive
		bubbleRightAnchor?.isActive = viewModel.rightAnchorActive
		messageTimeLeftAnchor?.isActive = viewModel.leftAnchorActive
		messageTimeRightAnchor?.isActive = viewModel.rightAnchorActive
	}

}
