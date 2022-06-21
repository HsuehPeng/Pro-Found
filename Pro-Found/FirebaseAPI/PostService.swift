//
//  PostService.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/18.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

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
			"timestamp": firebasePost.timestamp,
			"likedBy": firebasePost.likedBy
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
		
//		do {
//			try postRef.setData(from: firebasePost)
//			dbUsers.document(uid).updateData([
//				"posts": FieldValue.arrayUnion([postRef.documentID])
//			])
//		} catch let error {
//			print("Error writing post to Firestore: \(error)")
//		}
//
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
	
	func uploadComment(firebaseReply: FirebaseReply, completion: @escaping () -> Void) {
		let replyRef = dbReplies.document()
		
		replyRef.setData([
			"userID": firebaseReply.userID,
			"contentText": firebaseReply.contentText,
			"replyID": replyRef.documentID,
			"timestamp": firebaseReply.timestamp,
			"postID": firebaseReply.postID
		]) { error in
			if let error = error {
				print("Error uploading comment: \(error)")
			} else {
				print("Successfully upload comment")
				completion()
			}
		}
	}
	
	func getReplies(completion: @escaping (Result<[Reply], Error>) -> Void) {
		
		dbReplies.getDocuments { snapshot, error in
			var replies = [Reply]()
			
			if let error = error {
				completion(.failure(error))
			} else {
				guard let snapshot = snapshot else { return }
				let group = DispatchGroup()
				for document in snapshot.documents {
					let replyData = document.data()
					group.enter()
					UserServie.shared.getUserData(uid: replyData["userID"] as? String ?? "") { result in
						switch result {
						case .success(let user):
							let reply = Reply(user: user, dictionary: replyData)
							replies.append(reply)
						case .failure(let error):
							print(error)
						}
						group.leave()
					}
				}
				group.notify(queue: DispatchQueue.main) {
					completion(.success(replies))
				}
			}
		}
	}
	
	func likePost(post: Post, userID: String) {
		
		dbPosts.document(post.postID).updateData([
			"likedBy": FieldValue.arrayUnion([userID]),
			"likes": FieldValue.increment(Int64(1))
		]) { error in
			if let error = error {
				print("Error liking post: \(error)")
			} else {
				print("Successfully liked post")
			}
		}
	}
	
	func unlikePost(post: Post, userID: String) {
		
		dbPosts.document(post.postID).updateData([
			"likedBy": FieldValue.arrayRemove([userID]),
			"likes": FieldValue.increment(Int64(-1))
		]) { error in
			if let error = error {
				print("Error unliking post: \(error)")
			} else {
				print("Successfully unliked post")
			}
		}
	}
	
}
