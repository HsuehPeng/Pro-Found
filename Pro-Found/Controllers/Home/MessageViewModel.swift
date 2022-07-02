//
//  MessageViewModel.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/7/1.
//

import UIKit

struct MessageViewModel {
	private let message: Message
	
	var messageBackgroundColor: UIColor {
		return message.isFromCurrentUser ? .orange : .light50
	}
	
	var messageTextColor: UIColor {
		return message.isFromCurrentUser ? .light60 : .dark60
	}
	
	var rightAnchorActive: Bool {
		return message.isFromCurrentUser
	}
	
	var leftAnchorActive: Bool {
		return !message.isFromCurrentUser
	}
	
	var timeString: String {
		let date = Date(timeIntervalSince1970: message.timestamp)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		return dateFormatter.string(from: date)
	}
	
	init(message: Message) {
		self.message = message
	}
}
