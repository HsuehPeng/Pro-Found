//
//  PostService.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/18.
//

import Foundation
import FirebaseFirestore

struct PostService {
	
	static let shared = PostService()
	
	func uploadPost(post: Post, user: User, completion: @escaping () -> Void) {
		let postRef = dbPosts.document()
		let postData: [String: Any] = [
			"postID": postRef.documentID,
			"userID": user.userID,
			"contentText": post.contentText,
			"likes": post.likes,
			"timestamp": post.timestamp
		]
		
		postRef.setData(postData) { error in
			if let error = error {
				print("Error writing post: \(error)")
			} else {
				dbUsers.document(user.userID).updateData([
					"posts": FieldValue.arrayUnion([postRef.documentID])
				])
				print("New post successfully created")
				completion()
			}
		}
	}
	
	func getPosts(user: User, completion: @escaping (Result<[Post], Error>) -> Void) {
		
		dbPosts.getDocuments { snapshot, error in
			var posts = [Post]()
			if let error = error {
				completion(.failure(error))
			} else {
				guard let snapshot = snapshot else { return }
				for document in snapshot.documents {
					let postData = document.data()
					let post = Post(dictionary: postData)
					posts.append(post)
				}
				completion(.success(posts))
			}
		}
	}
	
	
	
}
