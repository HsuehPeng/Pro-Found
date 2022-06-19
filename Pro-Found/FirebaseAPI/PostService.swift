//
//  PostService.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/18.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct PostService {
	
	static let shared = PostService()
	
	func uploadPost(firebasePost: FirebasePosts, completion: @escaping () -> Void) {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		let postRef = dbPosts.document()
		let postData: [String: Any] = [
			"postID": postRef.documentID,
			"userID": firebasePost.userID,
			"contentText": firebasePost.contentText,
			"likes": firebasePost.likes,
			"timestamp": firebasePost.timestamp
		]
		
		postRef.setData(postData) { error in
			if let error = error {
				print("Error writing post: \(error)")
			} else {
				dbUsers.document(uid).updateData([
					"posts": FieldValue.arrayUnion([postRef.documentID])
				])
				print("New post successfully created")
				completion()
			}
		}
	}
	
	func getPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
		
		dbPosts.getDocuments { snapshot, error in
			var posts = [Post]()
			if let error = error {
				completion(.failure(error))
			} else {
				guard let snapshot = snapshot else { return }
				let group = DispatchGroup()
				for document in snapshot.documents {
					let postData = document.data()
					group.enter()
					UserServie.shared.getUserData(uid: postData["userID"] as? String ?? "") { result in
						switch result {
						case .success(let user):
							let post = Post(user: user, dictionary: postData)
							posts.append(post)
						case .failure(let error):
							print(error)
						}
						group.leave()
					}
					
				}
				group.notify(queue: DispatchQueue.main) {
					completion(.success(posts))
				}
			}
		}
	}
	
	
	
}
