//
//  ArticleService.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/18.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

struct ArticleService {
	
	static let shared = ArticleService()
	
	func createAndDownloadImageURL(articleImage: UIImage, author: User, completion: @escaping (Result<String, Error>) -> Void) {
		guard let imageData = articleImage.jpegData(compressionQuality: 0.3) else { return }
		let imageFileName = NSUUID().uuidString
		let storageRef = storageArticleImages.child(imageFileName)
		
		storageRef.putData(imageData, metadata: nil) { metadata, error in
			
			if let error = error {
				print(error)
			}

			storageRef.downloadURL { url, error in
				guard let url = url?.absoluteString else { return }
				completion(.success(url))
			}
		}
	}
	
	func uploadArticle(article: FirebaseArticle, completion: @escaping () -> Void) {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		let articleRef = dbArticles.document()
		let articleData: [String: Any] = [
			"userID": uid,
			"articleID": articleRef.documentID,
			"articleTitle": article.articleTitle,
			"subject": article.subject,
			"timestamp": article.timestamp,
			"contentText": article.contentText,
			"imageURL": article.imageURL,
			"ratings": article.ratings,
			"authorName": article.authorName
		]
		
		articleRef.setData(articleData) { error in
			if let error = error {
				print("Error writing article: \(error)")
			} else {
				dbUsers.document(uid).updateData([
					"articles": FieldValue.arrayUnion([articleRef.documentID])
				]) { error in
					if let error = error {
						print("Error writing article: \(error)")
					}
					completion()
				}
				print("New article successfully created")
			}
		}
	}
	
	func fetchArticle(articleID: String, completion: @escaping (Result<Article, Error>) -> Void) {
		dbArticles.document(articleID).getDocument { snapshot, error in
			if let error = error {
				completion(.failure(error))
			} else {
				guard let snapshot = snapshot, let articleData = snapshot.data() else { return }
				UserServie.shared.getUserData(uid: articleData["userID"] as? String ?? "") { result in
					switch result {
					case .success(let user):
						let article = Article(user: user, dictionary: articleData, articleID: snapshot.documentID)
						completion(.success(article))
					case .failure(let error):
						print(error)
					}
				}
			}
		}
	}
	
	func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
		dbArticles.getDocuments { snapshot, error in
			var articles = [Article]()
			if let error = error {
				completion(.failure(error))
			} else {
				guard let snapshot = snapshot else { return }
				let group = DispatchGroup()
				for document in snapshot.documents {
					let articleData = document.data()
					group.enter()
					UserServie.shared.getUserData(uid: articleData["userID"] as! String) { result in
						switch result {
						case .success(let user):
							let article = Article(user: user, dictionary: articleData, articleID: document.documentID)
							articles.append(article)
						case .failure(let error):
							print(error)
						}
						group.leave()
					}
					
				}
				group.notify(queue: DispatchQueue.main) {
					completion(.success(articles))
				}
			}
		}
	}
	
	func checkIfBookMarked(articleID: String, userID: String, completion: @escaping (Bool) -> Void) {
		dbUsers.whereField("userID", isEqualTo: userID).whereField("favoriteArticles", arrayContains: articleID).getDocuments {
			snapshot, error in
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
	
	func addFavoriteArticles(articleID: String, userID: String, completion: @escaping () -> Void) {
		dbUsers.document(userID).updateData([
			"favoriteArticles": FieldValue.arrayUnion([articleID])
		]) { error in
			if let error = error {
				print("Error adding favorite article: \(error)")
			} else {
				print("Add article successfully")
				completion()
			}
		}
	}
	
	func cancelFavoriteArticles(articleID: String, userID: String, completion: @escaping () -> Void) {
		dbUsers.document(userID).updateData([
			"favoriteArticles": FieldValue.arrayRemove([articleID])
		]) { error in
			if let error = error {
				print("Error removing favorite article: \(error)")
			} else {
				print("Remove article successfully")
				completion()
			}
		}
	}
	
	func fetchFavoriteArticles(userID: String, completion: @escaping (Result<[Article], Error>) -> Void) {
		var articles = [Article]()
		dbUsers.document(userID).getDocument { snapshot, error in
			if let error = error {
				completion(.failure(error))
			} else {
				guard let snapshot = snapshot, let userData = snapshot.data(),
				let favoriteArticleIDs = userData["favoriteArticles"] as? [String] else { return }
				let group = DispatchGroup()
				
				for id in favoriteArticleIDs {
					group.enter()
					fetchArticle(articleID: id) { result in
						switch result {
						case .success(let article):
							articles.append(article)
						case .failure(let error):
							completion(.failure(error))
						}
						group.leave()
					}
				}
				group.notify(queue: DispatchQueue.global()) {
					completion(.success(articles))
				}
			}
			

		}
	}
	
	func rateArticle(senderID: String, articleID: String, rating: Double) {
		
		dbArticles.document(articleID).updateData([
			"ratings": FieldValue.arrayUnion([[senderID: rating]]),
		]) { error in
			if let error = error {
				print("Error rating article: \(error)")
			} else {
				print("Rate article successfully")
			}
		}
	}
	
	func deleteArticle(articleID: String, userID: String, completion: @escaping () -> Void) {
		dbArticles.document(articleID).delete() { error in
			if let error = error {
				print("Error removing article: \(error)")
			} else {
				dbUsers.document(userID).updateData([
					"articles": FieldValue.arrayRemove([articleID])
				])
				dbUsers.whereField("favoriteArticles", arrayContains: articleID).getDocuments { snapshot, error in
					guard let snapshot = snapshot else { return }
					
					for document in snapshot.documents {
						let userData = document.data()
						let favoriteUserID = userData["userID"] as? String ?? ""
						dbUsers.document(favoriteUserID).updateData([
							"favoriteArticles": FieldValue.arrayRemove([articleID])
						])
					}
				}
				DispatchQueue.main.async {
					completion()
				}
			}
		}
	}
}
