//
//  User.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/14.
//

import Foundation

struct User {
	let name: String
	let username: String
	let email: String
	let rating: Int
	let profileImageURL: String
	let backgroundImageURL: String
	let courseList: [Course]
	let isTutor: Bool
}

struct Course {
	
}
