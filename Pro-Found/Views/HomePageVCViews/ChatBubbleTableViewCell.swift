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

	let messageBubbleView: UIView = {
		let view = UIView()
		view.backgroundColor = .orange
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 8
		return view
	}()
	
	let messageText: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "PingFangTC", size: 10)
		label.textColor = .white
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		
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
						   paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
		
		
	}
	
	// MARK: - Helpers
	
	func configureUI() {
		guard let message = message else { return }
		let viewModel = MessageViewModel(message: message)
		messageBubbleView.backgroundColor = viewModel.messageBackgroundColor
		messageText.textColor = viewModel.messageTextColor
		messageText.text = message.text
		
		bubbleLeftAnchor?.isActive = viewModel.leftAnchorActive
		bubbleRightAnchor?.isActive = viewModel.rightAnchorActive
	}

}
