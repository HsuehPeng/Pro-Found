//
//  CourseService.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct CourseServie {
	
	static let shared = CourseServie()
	
	func uploadNewCourse(fireBasecourse: FirebaseCourse, completion: @escaping () -> Void) {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		let courseRef = dbCourses.document()
		let courseData: [String: Any] = [
			"courseID": courseRef.documentID,
			"userID": fireBasecourse.userID,
			"tutorName": fireBasecourse.tutorName,
			"courseTitle": fireBasecourse.courseTitle,
			"subject": fireBasecourse.subject,
			"location": fireBasecourse.location,
			"fee": fireBasecourse.fee,
			"briefIntro": fireBasecourse.briefIntro,
			"detailIntro": fireBasecourse.detailIntro,
			"hours": fireBasecourse.hours,
			"isdeleted": fireBasecourse.isdeleted
		]
		
		courseRef.setData(courseData) { error in
			if let error = error {
				print("Error writing document: \(error)")
			} else {
				dbUsers.document(uid).updateData([
					"courses": FieldValue.arrayUnion([courseRef.documentID])
				])
				DispatchQueue.main.async {
					completion()
					print("NewCourse successfully created")
				}
			}
		}
	}
	
	func fetchUserCourses(userID: String, completion: @escaping (Result<[Course], Error>) -> Void) {
		dbCourses.whereField("userID", isEqualTo: userID).getDocuments { snapshot, error in
			var courses = [Course]()
			if let error = error {
				completion(.failure(error))
			} else {
				guard let snapshot = snapshot else { return }
				let group = DispatchGroup()
				
				for document in snapshot.documents {
					let courseData = document.data()
					guard let courseID = courseData["courseID"] as? String else { return }
					group.enter()
					fetchCourse(courseID: courseID) { result in
						switch result {
						case .success(let course):
							courses.append(course)
						case .failure(let error):
							print(error)
						}
						group.leave()
					}
					
				}
				
				group.notify(queue: DispatchQueue.main) {
					completion(.success(courses))
				}
				
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
				let group = DispatchGroup()
				
				for document in snapshot.documents {
					let courseData = document.data()
					guard let courseID = courseData["courseID"] as? String else { return }
					group.enter()
					fetchCourse(courseID: courseID) { result in
						switch result {
						case .success(let course):
							courses.append(course)
						case .failure(let error):
							print(error)
						}
						group.leave()
					}
					
				}
				
				group.notify(queue: DispatchQueue.main) {
					completion(.success(courses))
				}
			}
		}
	}
	
	func fetchCourse(courseID: String, completion: @escaping (Result<Course, Error>) -> Void) {
		dbCourses.document(courseID).getDocument { snapshot, error in
			if let error = error {
				completion(.failure(error))
			} else {
				guard let snapshot = snapshot, let courseData = snapshot.data() else { return }
				guard let userID = courseData["userID"] as? String else { return }
				UserServie.shared.getUserData(uid: userID) { result in
					switch result {
					case .success(let user):
						let course = Course(tutor: user, dictionary: courseData)
						completion(.success(course))
					case .failure(let error):
						print(error)
					}
				}
			}
		}
	}
	
	func archiveCourse(courseID: String, userID: String, completion: @escaping (Error?) -> Void) {
		dbCourses.document(courseID).updateData([
			"isdeleted": true
		]) { error in
			if let error = error {
				completion(error)
			} else {
				completion(nil)
			}
		}
		
	}
	
}
