//
//  UserService.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import Foundation
import FirebaseFirestore

struct UserServie {
	
	static let shared = UserServie()
	
	func uploadUserData(user: User, uid: String) {
		let userRef = dbUsers.document()
		let userData: [String: Any] = [
			"articles": user.articles,
			"backgroundImageURL": user.backgroundImageURL,
			"blockedUsers": user.blockedUsers,
			"courses": user.courses,
			"email": user.email,
			"events": user.events,
			"followings": user.followerings,
			"followers": user.followers,
			"introContenText": user.introContentText,
			"isTutor": user.isTutor,
			"name": user.name,
			"posts": user.posts,
			"profileImageURL": user.profileImageURL,
			"rating": user.rating,
			"school": user.school,
			"schoolMajor": user.schoolMajor,
			"subject": user.subject,
			"userID": uid,
		]
		
		userRef.setData(userData) { error in
			if let error = error {
				print("Error writing userdata: \(error)")
			} else {
				print("User successfully uploaded")
			}
		}
		
		userRef.collection("ScheduledCourse").document(user.userID).setData([
			"time": []
		])
		
		userRef.collection("ScheduledEvent").document(user.userID).setData([
			"time": []
		])

	}
	
	func uploadScheduledCourse(user: User, tutor: User, courseID: String, time: Double) {
		dbUsers.document(user.userID).collection("ScheduledCourse").document().setData([
			"\(courseID)": time
		]) { error in
			if let error = error {
				print("Error writing ScheduledCourse: \(error)")
			} else {
				print("ScheduledCourse successfully uploaded")
			}
		}
		
		dbUsers.document(tutor.userID).collection("ScheduledCourse").document().setData([
			"\(courseID)": time
		]) { error in
			if let error = error {
				print("Error writing ScheduledCourse: \(error)")
			} else {
				print("ScheduledCourse successfully uploaded")
			}
		}
	}
	
	func getUserData(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
		dbUsers.document(uid).getDocument { snapShot, error in
			if let error = error {
				print("Error getting user data: \(error)")
				completion(.failure(error))
			}
			guard let snapShot = snapShot, let userData = snapShot.data() else {
				print("User snapShot doesn't exist")
				return
			}
			let user = User(dictionary: userData)
			completion(.success(user))
		}
	}
	
	func getTutors(completion: @escaping (Result<[User], Error>) -> Void) {
		dbUsers.whereField("isTutor", isEqualTo: true).getDocuments { snapshot, error in
			var tutors = [User]()
			if let error = error {
				completion(.failure(error))
			} else {
				for document in snapshot!.documents {
					let tutorData = document.data()
					let tutor = User(dictionary: tutorData)
					tutors.append(tutor)
				}
				completion(.success(tutors))
			}
		}
	}
	
	func getScheduledCourseIDs(userID: String, completion: @escaping (Result<[ScheduledCourseTime], Error>) -> Void) {
		dbUsers.document(userID).collection("ScheduledCourse").getDocuments { snapshot, error in
			var courseTimes = [ScheduledCourseTime]()
			if let error = error {
				completion(.failure(error))
			} else {
				guard let snapshot = snapshot else { return }
				for document in snapshot.documents {
					let courseTimeData = document.data()
					guard let courseID = courseTimeData.keys.first, let time = courseTimeData["\(courseID)"] as? Double else { return }
					let courseTime = ScheduledCourseTime(courseID: courseID, time: time)
					courseTimes.append(courseTime)
				}
				completion(.success(courseTimes))
			}
		}
	}
	
	func follow(sender: User, receiver: User) {
		dbUsers.document(sender.userID).updateData([
			"followings": FieldValue.arrayUnion([receiver.userID])
		]) { error in
			if let error = error {
				print("Error updating followings: \(error)")
			} else {
				dbUsers.document(receiver.userID).updateData([
					"followers": FieldValue.arrayUnion([sender.userID])
				]) { error in
					if let error = error {
						print("Error getting followers: \(error)")
					} else {
						print("Successfully followed")
					}
				}
			}
		}
	}
	
	func unfollow(sender: User, receiver: User) {
		dbUsers.document(sender.userID).updateData([
			"followings": FieldValue.arrayRemove([receiver.userID])
		]) { error in
			if let error = error {
				print("Error updating followings: \(error)")
			} else {
				dbUsers.document(receiver.userID).updateData([
					"followers": FieldValue.arrayRemove([sender.userID])
				]) { error in
					if let error = error {
						print("Error getting followers: \(error)")
					} else {
						print("Successfully unfollowed")
					}
				}
			}
		}
	}
	
	func checkIfFollow(sender: User, receiver: User, completion: @escaping (Bool) -> Void) {
		dbUsers.document(sender.userID).parent.whereField("followings", arrayContains: receiver.userID).getDocuments { snapshot, error in
			if let error = error {
				completion(false)
			} else {
				guard let snapshot = snapshot else {
					completion(false)
					return
				}
				completion(!snapshot.isEmpty)
			}
		}
	}
	
}
