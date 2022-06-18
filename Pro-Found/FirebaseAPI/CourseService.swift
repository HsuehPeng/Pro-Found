//
//  CourseService.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import Foundation
import FirebaseFirestore

struct CourseServie {
	
	static let shared = CourseServie()
	
	func uploadNewCourse(course: Course, user: User) {
		let courseRef = dbCourses.document()
		let courseData: [String: Any] = [
			"courseID": courseRef.documentID,
			"userID": course.userID,
			"tutorName": course.tutorName,
			"courseTitle": course.courseTitle,
			"subject": course.subject,
			"location": course.location,
			"fee": course.fee,
			"briefIntro": course.briefIntro,
			"detailIntro": course.detailIntro,
			"hours": course.hours
		]
		
		courseRef.setData(courseData) { error in
			if let error = error {
				print("Error writing document: \(error)")
			} else {
				dbUsers.document(user.userID).updateData([
					"courses": FieldValue.arrayUnion([courseRef.documentID])
				])
				print("NewCourse successfully created")
			}
		}
	}
	
//	func deleteCourse(course: Course, user: User) {
//		let courseRef = dbCourses.document(course.courseID)
//		courseRef.delete { error in
//			if let error = error {
//				print("Error removing document: \(error)")
//			} else {
//				dbUsers.document(user.userID).updateData([
//					"courses": FieldValue.arrayRemove([course.courseID])
//				])
//				print("Document successfully removed!")
//			}
//		}
//	}
	
	func fetchUserCourses(userID: String, completion: @escaping (Result<[Course], Error>) -> Void) {
		dbCourses.whereField("userID", isEqualTo: userID).getDocuments { snapshot, error in
			var courses = [Course]()
			if let error = error {
				completion(.failure(error))
			} else {
				for document in snapshot!.documents {
//					print("\(document.documentID) => \(document.data())")
					let data = document.data()
					let course = Course(dictionary: data)
					courses.append(course)
				}
				completion(.success(courses))
			}
		}
	}
	
	func fetchCourses(completion: @escaping (Result<[Course], Error>) -> Void) {
		dbCourses.getDocuments { snapshot, error in
			var courses = [Course]()
			if let error = error {
				completion(.failure(error))
			} else {
				guard let snapshot = snapshot else { return }
				for document in snapshot.documents {
					let data = document.data()
					let course = Course(dictionary: data)
					courses.append(course)
				}
				completion(.success(courses))
			}
		}
	}
	
	func fetchCourse(courseID: String, completion: @escaping (Result<Course, Error>) -> Void) {
		dbCourses.document(courseID).getDocument { snapshot, error in
			if let error = error {
				completion(.failure(error))
			} else {
				guard let snapshot = snapshot, let courseData = snapshot.data() else { return }
				let course = Course(dictionary: courseData)
				completion(.success(course))
			}
		}
	}
	
}
