//
//  CourseService.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import Foundation

struct CourseServie {
	
	static let shared = CourseServie()
	
	func uploadNewCourse(userId: String, course: Course) {
		let courseRef = dbCourses.document()
		let courseData: [String: Any] = [
			"courseID": courseRef.documentID,
			"userID": userId,
			"tutorName": course.tutorName,
			"courseTitle": course.courseTitle,
			"subject": course.subject,
			"location": course.location,
			"fee": course.fee,
			"briefIntro": course.briefIntro,
			"detailIntro": course.detailIntro
		]
		
		courseRef.setData(courseData) { error in
			if let error = error {
				print("Error writing document: \(error)")
			} else {
				print("NewCourse successfully uploaded")
			}
		}
	}
	
	func fetchCourse(userID: String) {
		dbCourses.whereField("userID", isEqualTo: userID).getDocuments { snapshot, error in
			if let error = error {
				print("Error getting documents: \(error)")
			} else {
				for document in snapshot!.documents {
					print("\(document.documentID) => \(document.data())")
				}
			}
		}
		
	}
	
}
