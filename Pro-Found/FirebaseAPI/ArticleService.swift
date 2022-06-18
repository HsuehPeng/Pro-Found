//
//  ArticleService.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/18.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct ArticleService {
	
	func uploadArticle(article: Article) {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		let articleRef = dbArticles.document()
		let articleData: [String: Any] = [
			"userID": uid,
			"articleID": articleRef.documentID,
			"articleTitle": article.articleTitle,
			"subject": article.subject,
			"timestamp": article.timestamp,
			"contentText": article.contentText
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
	
}
