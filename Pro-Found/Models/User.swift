//
//  User.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/14.
//

import Foundation

struct Users {
	let users: [User]
}

struct User {
	let name: String
	let userID: String
	let email: String
	let introContentText: String
	var school: String?
	var schoolMajor: String?
	let rating: Double
	var profileImageURL: String?
	var backgroundImageURL: String?
	let courses: [Course]
	let articles: [Article]
	let events: [Event]
	let posts: [Post]
	let blockedUsers: [String]
	let followers: [String]
	let followerings: [String]
	let isTutor: Bool
}

extension User {
	init(dictionary: [String: Any]) {
		userID = dictionary["userID"] as? String ?? ""
		name = dictionary["name"] as? String ?? "Test Name"
		email = dictionary["email"] as? String ?? "Test Email"
		introContentText = dictionary["introContentText"] as? String ?? "Test intro"
		school = dictionary["school"] as? String ?? "Test School"
		schoolMajor = dictionary["schoolMajor"] as? String ?? "Test Major"
		rating = dictionary["rating"] as? Double ?? 0
		profileImageURL = dictionary["profileImageURL"] as? String ?? nil
		backgroundImageURL = dictionary["backgroundImageURL"] as? String ?? nil
		courses = dictionary["courses"] as? [Course] ?? []
		articles = dictionary["articles"] as? [Article] ?? []
		events = dictionary["events"] as? [Event] ?? []
		posts = dictionary["posts"] as? [Post] ?? []
		blockedUsers = dictionary["blockedUsers"] as? [String] ?? []
		followers = dictionary["followers"] as? [String] ?? []
		followerings = dictionary["followerings"] as? [String] ?? []
		isTutor = dictionary["isTutor"] as? Bool ?? false
	}
}
