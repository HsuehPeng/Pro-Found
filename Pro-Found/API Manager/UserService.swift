//
//  UserService.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserServie {
	
	static let shared = UserServie()
	
	func uploadUserImageAndDownloadImageURL(userProfileImage: UIImage, user: User, completion: @escaping (Result<String, Error>) -> Void) {
		guard let imageData = userProfileImage.jpegData(compressionQuality: 0.3) else { return }
		let imageFileName = user.userID
		let storageRef = storageUserProfileImages.child(imageFileName)
		
		storageRef.putData(imageData, metadata: nil) { metadata, error in
			
			if let error = error {
				print(error)
			}

			storageRef.downloadURL { url, error in
				guard let url = url?.absoluteString else { return }
				
				dbUsers.document(user.userID).updateData([
					"profileImageURL": url
				]) { error in
					if let error = error {
						completion(.failure(error))
					} else {
						completion(.success(url))
					}
				}
			}
		}
	}
	
	func uploadUserBackgroundImageAndDownloadImageURL(userBackgroundImage: UIImage, user: User, completion: @escaping (Result<String, Error>) -> Void) {
		guard let imageData = userBackgroundImage.jpegData(compressionQuality: 0.3) else { return }
		let imageFileName = user.userID
		let storageRef = storageUserBackgroundImages.child(imageFileName)
		
		storageRef.putData(imageData, metadata: nil) { metadata, error in
			
			if let error = error {
				print(error)
			}

			storageRef.downloadURL { url, error in
				guard let url = url?.absoluteString else { return }
				
				dbUsers.document(user.userID).updateData([
					"backgroundImageURL": url
				]) { error in
					if let error = error {
						completion(.failure(error))
					} else {
						completion(.success(url))
					}
				}
			}
		}
	}
	
	func uploadUserData(user: User, completion: @escaping () -> Void) {
		let userRef = dbUsers.document(user.userID)
		
		do {
			try userRef.setData(from: user)
			completion()
		} catch let error {
			print("Error uploading user to Firestore: \(error)")
		}
		
	}
	
	func updateTutorState(user: User, isTutor: Bool, subject: String, completion: @escaping () -> Void) {
		dbUsers.document(user.userID).updateData([
			"isTutor": isTutor,
			"subject": subject
		]) { error in
			if let error = error {
				print("Error updating tutor state: \(error)")
			} else {
				completion()
			}
		}
	}
	
	func uploadScheduledCourse(user: User, tutor: User, courseID: String, time: Double, completion: @escaping () -> Void) {
		let applicationTime = Date().timeIntervalSince1970
		let ref = dbUsers.document(user.userID).collection("ScheduledCourse").document()
		ref.setData([
			"\(courseID)": time,
			"student": user.userID,
			"applicationTime": applicationTime,
			"status": "Pending",
			"applicationID": ref.documentID
		]) { error in
			if let error = error {
				print("Error writing ScheduledCourse: \(error)")
			} else {
				print("ScheduledCourse successfully uploaded")
				completion()
			}
		}
		
		dbUsers.document(tutor.userID).collection("ScheduledCourse").document(ref.documentID).setData([
			"\(courseID)": time,
			"student": user.userID,
			"applicationTime": applicationTime,
			"status": "Pending",
			"applicationID": ref.documentID
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
	
	func updateScheduledCourseStatus(user: User, tutor: User, applicationID: String, result: String, completion: @escaping () -> Void) {
		dbUsers.document(user.userID).collection("ScheduledCourse").document(applicationID).updateData([
			"status": result
		]) { error in
			if let error = error {
				print("Error updating shceduled course status: \(error)")
			} else {
				print("Application successfully updated")
				completion()
			}
		}
		
		dbUsers.document(tutor.userID).collection("ScheduledCourse").document(applicationID).updateData([
			"status": result
		]) { error in
			if let error = error {
				print("Error updating shceduled course status: \(error)")
			} else {
				print("Application successfully updated")
				completion()
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
				let group = DispatchGroup()
				
				for document in snapshot.documents {
					group.enter()
					let courseTimeData = document.data()
					
					let courseID = courseTimeData.keys.filter({ key in
						let isCourseID = key != "student" && key != "status" && key != "applicationTime" && key != "applicationID"
						return isCourseID
					})
					
					guard let courseID = courseID.first, let time = courseTimeData["\(courseID)"] as? Double,
						  let studentID = courseTimeData["student"] as? String,
						  let applicationTime = courseTimeData["applicationTime"] as? Double,
						  let status = courseTimeData["status"] as? String,
						  let applicationID = courseTimeData["applicationID"] as? String else {
						print("misismsimsimsimism")
						return
					}
					
					CourseServie.shared.fetchCourse(courseID: courseID) { result in
						switch result {
						case .success(let course):
							getUserData(uid: studentID) { result in
								switch result {
								case .failure(let error):
									completion(.failure(error))
								case .success(let user):
									let courseTime = ScheduledCourseTime(courseID: courseID, time: time, student: user, course: course, applicationTime: applicationTime, status: status, applicationID: applicationID)
									courseTimes.append(courseTime)
								}
								group.leave()
							}
						case .failure(let error):
							completion(.failure(error))
						}
					}
				}
				
				group.notify(queue: DispatchQueue.main) {
					completion(.success(courseTimes))
				}
			}
		}
	}
	
	func uploadScheduledEvent(organizerID: String, eventID: String, time: Double) {
		dbUsers.document(organizerID).collection("ScheduledEvent").document().setData([
			"scheduleTime": time,
			"eventID": eventID
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
			"scheduleTime": time,
			"eventID": eventID
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
	
	func deleteEventParticipant(participantID: String, eventID: String, completion: @escaping (Error?) -> Void) {
		dbEvents.document(eventID).updateData([
			"participants": FieldValue.arrayRemove([participantID])
		]) { error in
			if let error = error {
				completion(error)
				print("Error deleting participants: \(error)")
			} else {
				print("Successfully deleted participants")
				
				dbUsers.document(participantID).collection("ScheduledEvent").whereField("eventID", isEqualTo: eventID).getDocuments { snapshot, error in
					if let error = error {
						completion(error)
						print("Error deleting scheduled Event: \(error)")
					} else {
						guard let snapshot = snapshot else { return }
						for document in snapshot.documents {
							dbUsers.document(participantID).collection("ScheduledEvent").document(document.documentID).delete { error in
								if let error = error {
									completion(error)
								} else {
									completion(nil)
								}
							}
						}
					}
				}
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
				
				let group = DispatchGroup()
				
				for document in snapshot.documents {
					group.enter()
					let eventTimeData = document.data()
					guard let eventID = eventTimeData["eventID"] as? String, let time = eventTimeData["scheduleTime"] as? Double else { return }
					
					EventService.shared.fetchEvent(eventID: eventID) { result in
						switch result {
						case .success(let event):
							let eventTime = ScheduledEventTime(eventID: eventID, time: time, event: event)
							eventTimes.append(eventTime)
						case .failure(let error):
							completion(.failure(error))
						}
						group.leave()
					}
				}
				group.notify(queue: DispatchQueue.main) {
					completion(.success(eventTimes))
				}
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
		
//		dbUsers.document(uid).getDocument(as: User.self) { result in
//			switch result {
//			case .success(let user):
//				print(user)
//				completion(.success(user))
//			case .failure(let error):
//				print(error)
//				completion(.failure(error))
//			}
//		}
		
	}
	
	func checkIfUserExistOnFirebase(uid: String, completion: @escaping (Result<Bool, Error>) -> Void)  {
		dbUsers.document(uid).getDocument { snapshot, error in
			if let error = error {
				completion(.failure(error))
			} else if snapshot?.data() == nil {
				completion(.success(false))
			} else {
				completion(.success(true))
			}
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
	
	func getFollowingTutors(userID: String, completion: @escaping (Result<[User], Error>) -> Void) {
		var users = [User]()
		dbUsers.document(userID).getDocument { snapshot, error in
			if let error = error {
				completion(.failure(error))
			} else {
				guard let snapshot = snapshot, let userData = snapshot.data(),
				let followingTutorIDs = userData["followings"] as? [String] else { return }
				let group = DispatchGroup()
				
				for id in followingTutorIDs {
					group.enter()
					getUserData(uid: id) { result in
						switch result {
						case .success(let user):
							users.append(user)
						case .failure(let error):
							completion(.failure(error))
						}
						group.leave()
					}
				}
				group.notify(queue: DispatchQueue.global()) {
					completion(.success(users))
				}
			}
		}
	}
	
	func follow(senderID: String, receiverID: String, completion: @escaping () -> Void) {
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
						completion()
					}
				}
			}
		}
	}
	
	func unfollow(senderID: String, receiverID: String, completion: @escaping () -> Void) {
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
						completion()
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
	
	func rateTutor(senderID: String, receiverID: String, rating: Double, completion: @escaping () -> Void) {
		
		dbUsers.document(receiverID).updateData([
			"ratings": FieldValue.arrayUnion([[senderID: rating]]),
		]) { error in
			if let error = error {
				print("Error rating tutor: \(error)")
			} else {
				DispatchQueue.main.async {
					completion()
				}
				print("Rate tutor successfully")
			}

		}
	}
	
	func toggleTutorStatus(userID: String, subject: String, isTutor: Bool, completion: @escaping () -> Void) {
		if isTutor {
			dbUsers.document(userID).updateData([
				"subject": "Student",
				"isTutor": !isTutor
			]) { error in
				if let error = error {
					print("Error cancelling Tutor: \(error)")
				} else {
					completion()
				}
			}
		} else {
			dbUsers.document(userID).updateData([
				"subject": subject,
				"isTutor": !isTutor
			]) { error in
				if let error = error {
					print("Error becoming Tutor: \(error)")
				} else {
					completion()
				}
			}
		}
	}
	
	func toggleBlockingStatus(senderID: String, receiverID: String, completion: @escaping () -> Void) {
		dbUsers.document(senderID).getDocument { snapshot, error in
			if let error = error {
				print("Error getting user data: \(error)")
			}
			
			guard let snapshot = snapshot, let userData = snapshot.data(),
				  let blockedUsers = userData["blockedUsers"] as? [String] else { return }
			if blockedUsers.contains(receiverID) {
				dbUsers.document(senderID).updateData([
					"blockedUsers": FieldValue.arrayRemove([receiverID])
				]) { error in
					if let error = error {
						print("Error remove blocked user: \(error)")
					} else {
						completion()
					}
				}
			} else {
				dbUsers.document(senderID).updateData([
					"blockedUsers": FieldValue.arrayUnion([receiverID])
				]) { error in
					if let error = error {
						print("Error add blocked user: \(error)")
					} else {
						completion()
					}
				}
			}
		}
	}
	
	func getBlockedTutors(userID: String, completion: @escaping (Result<[User], Error>) -> Void) {
		var users = [User]()
		dbUsers.document(userID).getDocument { snapshot, error in
			if let error = error {
				completion(.failure(error))
			} else {
				guard let snapshot = snapshot, let userData = snapshot.data(),
				let followingTutorIDs = userData["blockedUsers"] as? [String] else { return }
				let group = DispatchGroup()
				
				for id in followingTutorIDs {
					group.enter()
					getUserData(uid: id) { result in
						switch result {
						case .success(let user):
							users.append(user)
						case .failure(let error):
							completion(.failure(error))
						}
						group.leave()
					}
				}
				group.notify(queue: DispatchQueue.global()) {
					completion(.success(users))
				}
			}
		}
	}
}
