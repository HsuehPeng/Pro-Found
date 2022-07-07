//
//  Courses.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import Foundation

struct Course {
	var courseID: String
	let userID: String
	let tutor: User
	let tutorName: String
	let courseTitle: String
	let subject: String
	let location: String
	let fee: Double
	let briefIntro: String
	let detailIntro: String
	let hours: Int
}

extension Course {
	init(tutor: User, dictionary: [String: Any]) {
		self.tutor = tutor
		courseID = dictionary["courseID"] as? String ?? ""
		userID = dictionary["userID"] as? String ?? ""
		tutorName = dictionary["tutorName"] as? String ?? ""
		courseTitle = dictionary["courseTitle"] as? String ?? ""
		detailIntro = dictionary["detailIntro"] as? String ?? ""
		fee = dictionary["fee"] as? Double ?? 0
		location = dictionary["location"] as? String ?? ""
		subject = dictionary["subject"] as? String ?? ""
		briefIntro = dictionary["briefIntro"] as? String ?? ""
		hours = dictionary["hours"] as? Int ?? 0
	}
}

struct FirebaseCourse {
	let userID: String
	let tutorName: String
	let courseTitle: String
	let subject: String
	let location: String
	let fee: Double
	let briefIntro: String
	let detailIntro: String
	let hours: Int
}

struct ScheduledCourseTime {
	let courseID: String
	let time: Double
	let student: User
	let course: Course
	let applicationTime: Double
	var status: String
	let applicationID: String
}
