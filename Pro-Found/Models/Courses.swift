//
//  Courses.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import Foundation

struct Courses: Codable {
	let courses: [Course]
}

struct Course: Codable {
	let courseID: String
	let userID: String
	let tutorName: String
	let courseTitle: String
	let subject: String
	let location: String
	let fee: Double
	let detailIntro: String
}
