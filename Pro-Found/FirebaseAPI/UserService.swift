//
//  UserService.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import Foundation

struct UserServie {
	
	static let shared = UserServie()
	
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
	
}
