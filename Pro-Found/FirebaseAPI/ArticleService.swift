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
	
	func createAndDownloadImageURL(articleImage: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
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
	
	func uploadArticle(article: FirebaseArticle) {
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
				])
				print("New article successfully created")
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
	
	func fetchArticle() {
		
	}
	
}
