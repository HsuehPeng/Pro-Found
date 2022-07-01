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

	let messageSelfBubbleView: UIView = {
		let view = UIView()
		view.backgroundColor = .orange
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let messageSelf: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "PingFangTC", size: 10)
		label.text = "test"
		label.textColor = .white
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		
		return label
	}()
	
	let messageOtherBubbleView: UIView = {
		let view = UIView()
		view.backgroundColor = .light
		view.translatesAutoresizingMaskIntoConstraints = false
		view.isHidden = true
		return view
	}()
	
	let messageOther: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "PingFangTC", size: 10)
//		label.text = "test"
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
		contentView.addSubview(messageSelfBubbleView)
		messageSelfBubbleView.layer.cornerRadius = 20
		NSLayoutConstraint.activate([
			messageSelfBubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
			messageSelfBubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
			messageSelfBubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
		])
		
		messageSelfBubbleView.addSubview(messageSelf)
		NSLayoutConstraint.activate([
			messageSelf.leadingAnchor.constraint(equalTo: messageSelfBubbleView.leadingAnchor, constant: 8),
			messageSelf.trailingAnchor.constraint(equalTo: messageSelfBubbleView.trailingAnchor, constant: -8),
			messageSelf.bottomAnchor.constraint(equalTo: messageSelfBubbleView.bottomAnchor, constant: -8),
			messageSelf.topAnchor.constraint(equalTo: messageSelfBubbleView.topAnchor, constant: 8),
			messageSelf.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 2/3)
		])
		
		contentView.addSubview(messageOtherBubbleView)
		messageOtherBubbleView.layer.cornerRadius = 20
		NSLayoutConstraint.activate([
			messageOtherBubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
			messageOtherBubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
			messageOtherBubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
		])
		
		messageSelfBubbleView.addSubview(messageOther)
		NSLayoutConstraint.activate([
			messageOther.leadingAnchor.constraint(equalTo: messageOtherBubbleView.leadingAnchor, constant: 8),
			messageOther.trailingAnchor.constraint(equalTo: messageOtherBubbleView.trailingAnchor, constant: -8),
			messageOther.bottomAnchor.constraint(equalTo: messageOtherBubbleView.bottomAnchor, constant: -8),
			messageOther.topAnchor.constraint(equalTo: messageOtherBubbleView.topAnchor, constant: 8),
			messageOther.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 2/3)
		])
	}

}
