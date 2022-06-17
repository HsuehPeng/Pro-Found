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
	var introContentText: String?
	var school: String?
	var schoolMajor: String?
	var rating: Double?
	var courseBooked: Int
	var profileImageURL: String?
	var backgroundImageURL: String?
	var courses: [String]?
	var articles: [String]?
	var events: [String]?
	var posts: [String]?
	var blockedUsers: [String]
	var followers: [String]
	var followerings: [String]
	var subject: String?
	var isTutor: Bool
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
		courses = dictionary["courses"] as? [String] ?? []
		articles = dictionary["articles"] as? [String] ?? []
		events = dictionary["events"] as? [String] ?? []
		posts = dictionary["posts"] as? [String] ?? []
		blockedUsers = dictionary["blockedUsers"] as? [String] ?? []
		followers = dictionary["followers"] as? [String] ?? []
		followerings = dictionary["followerings"] as? [String] ?? []
		subject = dictionary["subject"] as? String ?? ""
		isTutor = dictionary["isTutor"] as? Bool ?? false
		courseBooked = dictionary["courseBooked"] as? Int ?? 0
	}
}
