//
//  Posts.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import Foundation

struct Post {
	let userID: String
	var postID: String?
	let contentText: String
	let likes: Int
	let timestamp: Double
	let User: User
}

extension Post {
	init(user: User, dictionary: [String: Any]) {
		self.User = user
		userID = dictionary["userID"] as? String ?? ""
		postID = dictionary["postID"] as? String ?? ""
		contentText = dictionary["contentText"] as? String ?? ""
		likes = dictionary["likes"] as? Int ?? 0
		timestamp = dictionary["timestamp"] as? Double ?? 0
	}
}

struct FirebasePosts {
	let userID: String
	let contentText: String
	let likes: Int
	let timestamp: Double
}

struct Reply {
	let userID: String
	let postID: String
	let contentText: String
	let likes: Int
	let timestamp: Double
}
