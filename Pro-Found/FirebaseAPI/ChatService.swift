//
//  ChatService.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/7/1.
//

import Foundation
import FirebaseAuth

struct ChatService {
	
	static let shared = ChatService()
	
	func uploadMessage(_ message: String, to user: User, completion: ((Error?) -> Void)?) {
		guard let currentUid = Auth.auth().currentUser?.uid else { return }
		let timeInterval = Date().timeIntervalSince1970
		let data: [String: Any] = ["text": message, "fromID": currentUid, "toID": user.userID, "timestamp": timeInterval]
		dbChats.document(currentUid).collection(user.userID).addDocument(data: data) { _ in
			dbChats.document(user.userID).collection(currentUid).addDocument(data: data, completion: completion)
			
			dbChats.document(currentUid).collection("recent-messages").document(user.userID).setData(data)
			dbChats.document(user.userID).collection("recent-messages").document(currentUid).setData(data)

		}
	}
	
	func fetchMessages(forUser user: User, completion: @escaping (Result<[Message], Error>) -> Void) {
		var messages = [Message]()
		guard let currentUid = Auth.auth().currentUser?.uid else { return }
		
		let query = dbChats.document(currentUid).collection(user.userID).order(by: "timestamp")
		
		query.addSnapshotListener { snapshot, error in
			snapshot?.documentChanges.forEach({ change in
				if change.type == .added {
					let dictionary = change.document.data()
					messages.append(Message(dictionary: dictionary))
					completion(.success(messages))
				}
			})
		}
	}
	
	func fetchConversation(completion: @escaping (Result<[Conversation], Error>) -> Void) {
		var conversations = [Conversation]()
		guard let currentUid = Auth.auth().currentUser?.uid else { return }
		
		let query = dbChats.document(currentUid).collection("recent-messages").order(by: "timestamp")
		query.addSnapshotListener { snapshot, error in
			snapshot?.documentChanges.forEach({ change in
				if change.type == .added {
					let dictionary = change.document.data()
					let message = Message(dictionary: dictionary)
					
					UserServie.shared.getUserData(uid: message.toID) { result in
						switch result {
						case .success(let user):
							let conversation = Conversation(user: user, message: message)
							conversations.append(conversation)
							completion(.success(conversations))
						case .failure(let error):
							completion(.failure(error))
						}
					}
				}
			})
		}
	}
	
}
