//
//  UserService.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import Foundation

struct UserServie {
	
	static let shared = UserServie()
	
	func uploadUserData(user: User) {
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
			"userID": user.userID
		]
		
		userRef.setData(userData) { error in
			if let error = error {
				print("Error writing userdata: \(error)")
			} else {
				print("User successfully uploaded")
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
	
}
