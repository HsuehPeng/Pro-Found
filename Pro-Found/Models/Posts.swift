//
//  Posts.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import Foundation

struct Post: Codable {
	let userID: String
	var postID: String
	let contentText: String
	var likes: Int
	let timestamp: Double
	let likedBy: [String]
	let user: User
	let imagesURL: [String]
}

extension Post {
	init(user: User, dictionary: [String: Any]) {
		self.user = user
		userID = dictionary["userID"] as? String ?? ""
		postID = dictionary["postID"] as? String ?? ""
		contentText = dictionary["contentText"] as? String ?? ""
		likes = dictionary["likes"] as? Int ?? 0
		timestamp = dictionary["timestamp"] as? Double ?? 0
		likedBy = dictionary["likedBy"] as? [String] ?? []
		imagesURL = dictionary["imagesURL"] as? [String] ?? []
	}
}

struct FirebasePosts: Codable {
	let userID: String
	let contentText: String
	let likes: Int
	let timestamp: Double
	let likedBy: [String]
	let imagesURL: [String]
}

struct Reply: Codable {
	let userID: String
	let postID: String
	let replyID: String
	let contentText: String
	let timestamp: Double
	let user: User
}

extension Reply {
	init(user: User, dictionary: [String: Any]) {
		self.user = user
		userID = dictionary["userID"] as? String ?? ""
		postID = dictionary["postID"] as? String ?? ""
		contentText = dictionary["contentText"] as? String ?? ""
		timestamp = dictionary["timestamp"] as? Double ?? 0
		replyID = dictionary["replyID"] as? String ?? ""
	}
}

struct FirebaseReply: Codable {
	let userID: String
	let postID: String
	let contentText: String
	let timestamp: Double
}
