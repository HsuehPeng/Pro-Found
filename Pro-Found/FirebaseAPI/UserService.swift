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
	
	func uploadUserData(firebaseUser: FirebaseUser, completion: @escaping () -> Void) {
		let userRef = dbUsers.document(firebaseUser.userID)
		let userData: [String: Any] = [
			"articles": firebaseUser.articles ?? [],
			"backgroundImageURL": firebaseUser.backgroundImageURL ?? "",
			"blockedUsers": firebaseUser.blockedUsers ?? [],
			"courses": firebaseUser.courses ?? [],
			"email": firebaseUser.email,
			"events": firebaseUser.events ?? [],
			"followings": firebaseUser.followings ?? [],
			"followers": firebaseUser.followers ?? [],
			"introContenText": firebaseUser.introContentText ?? "",
			"isTutor": firebaseUser.isTutor,
			"name": firebaseUser.name,
			"posts": firebaseUser.posts ?? [],
			"profileImageURL": firebaseUser.profileImageURL ?? "",
			"rating": firebaseUser.rating ?? 0,
			"school": firebaseUser.school ?? "",
			"schoolMajor": firebaseUser.schoolMajor ?? "",
			"subject": firebaseUser.subject ?? "",
			"userID": firebaseUser.userID,
			"courseBooked": firebaseUser.courseBooked ?? 0
		]
		
		userRef.setData(userData) { error in
			if let error = error {
				print("Error writing userdata: \(error)")
			} else {
				print("User successfully uploaded")
				completion()
			}
		}
		
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
		
		dbUsers.document(tutor.userID).updateData([
			"courseBooked": FieldValue.increment(Int64(1))
		]) { error in
			if let error = error {
				print("Error add one to courseBooked: \(error)")
			} else {
				print("CourseBooked successfully added one")
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
	
	func uploadScheduledEvent(organizerID: String, eventID: String, time: Double) {
		dbUsers.document(organizerID).collection("ScheduledEvent").document().setData([
			"\(eventID)": time
		]) { error in
			if let error = error {
				print("Error writing ScheduledCourse: \(error)")
			} else {
				print("ScheduledEvent successfully uploaded")
			}
		}
	}
	
	func uploadScheduledEvent(participantID: String, eventID: String, time: Double, completion: @escaping () -> Void) {
		dbUsers.document(participantID).collection("ScheduledEvent").document().setData([
			"\(eventID)": time
		]) { error in
			if let error = error {
				print("Error writing ScheduledCourse: \(error)")
			} else {
				print("ScheduledEvent successfully uploaded")
				dbEvents.document(eventID).updateData(["participants": FieldValue.arrayUnion([participantID])])
				completion()
			}
		}
		
		
	}
	
	func getScheduledEventIDs(userID: String, completion: @escaping (Result<[ScheduledEventTime], Error>) -> Void) {
		dbUsers.document(userID).collection("ScheduledEvent").getDocuments { snapshot, error in
			var eventTimes = [ScheduledEventTime]()
			if let error = error {
				completion(.failure(error))
			} else {
				guard let snapshot = snapshot else { return }
				for document in snapshot.documents {
					let eventTimeData = document.data()
					guard let eventID = eventTimeData.keys.first, let time = eventTimeData["\(eventID)"] as? Double else { return }
					let eventTime = ScheduledEventTime(eventID: eventID, time: time)
					eventTimes.append(eventTime)
				}
				completion(.success(eventTimes))
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
	
	func follow(senderID: String, receiverID: String) {
		dbUsers.document(senderID).updateData([
			"followings": FieldValue.arrayUnion([receiverID])
		]) { error in
			if let error = error {
				print("Error updating followings: \(error)")
			} else {
				dbUsers.document(receiverID).updateData([
					"followers": FieldValue.arrayUnion([senderID])
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
	
	func unfollow(senderID: String, receiverID: String) {
		dbUsers.document(senderID).updateData([
			"followings": FieldValue.arrayRemove([receiverID])
		]) { error in
			if let error = error {
				print("Error updating followings: \(error)")
			} else {
				dbUsers.document(receiverID).updateData([
					"followers": FieldValue.arrayRemove([senderID])
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
	
	func checkIfFollow(senderID: String, receiveriD: String, completion: @escaping (Bool) -> Void) {
		
		dbUsers.whereField("userID", isEqualTo: senderID).whereField("followings", arrayContains: receiveriD).getDocuments { snapshot, error in
			if let _ = error {
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
