//
//  Articles.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import Foundation

struct Article: Codable, Equatable {
	let userID: String
	let articleID: String
	let articleTitle: String
	let authorName: String
	let subject: String
	let timestamp: Double
	let contentText: String
	let imageURL: String
	let ratings: [[String: Double]]
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
		authorName = dictionary["authorName"] as? String ?? ""
		imageURL = dictionary["imageURL"] as? String ?? ""
		ratings = dictionary["ratings"] as? [[String: Double]] ?? []
	}
}

struct FirebaseArticle: Codable {
	let userID: String
	let articleTitle: String
	let authorName: String
	let subject: String
	let timestamp: Double
	let contentText: String
	let imageURL: String
	let ratings: [[String: Double]]
}
