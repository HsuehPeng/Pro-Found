//
//  Message.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/7/1.
//

import Foundation
import FirebaseAuth

struct Message {
	let text: String
	let toID: String
	let fromID: String
	var timestamp: Double
	var user: User?
	let isFromCurrentUser: Bool
}

extension Message {
	init(dictionary: [String: Any]) {
		self.text = dictionary["text"] as? String ?? ""
		self.toID = dictionary["toID"] as? String ?? ""
		self.fromID = dictionary["fromID"] as? String ?? ""
		self.timestamp = dictionary["timestamp"] as? Double ?? 0
		self.isFromCurrentUser = fromID == Auth.auth().currentUser?.uid
	}
}

struct Conversation {
	let user: User
	let message: Message
}
