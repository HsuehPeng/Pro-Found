//
//  Articles.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import Foundation


struct Article {
	let userID: String
	let articleID: String
	let articleTitle: String
	let subject: String
	let timestamp: Double
	let contentText: String
	var user: User
}

extension Article {
	init(user: User, dictionary: [String: Any], articleID: String) {
		self.user = user
		self.articleID = articleID
		userID = dictionary["userID"] as? String ?? ""
		articleTitle = dictionary["articleTitle"] as? String ?? ""
		subject = dictionary["subject"] as? String ?? ""
		timestamp = dictionary["timestamp"] as? Double ?? 0
		contentText = dictionary["contentText"] as? String ?? ""
	}
}
