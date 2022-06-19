//
//  EventService.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/18.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

struct EventService {
	
	static let shared = EventService()
	
	func createAndDownloadImageURL(eventImage: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
		guard let imageData = eventImage.jpegData(compressionQuality: 0.3) else { return }
		let imageFileName = NSUUID().uuidString
		let storageRef = storageEventImages.child(imageFileName)
		
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
	
	func uploadEvent(event: FirebaseEvent) {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		let eventRef = dbEvents.document()
		let eventData: [String: Any] = [
			"userID": uid,
			"eventID": eventRef.documentID,
			"eventTitle": event.eventTitle,
			"organizerName": event.organizerName,
			"timestamp": event.timestamp,
			"location": event.location,
			"introText": event.introText,
			"imageURL": event.imageURL,
			"participants": event.participants
		]
		
		eventRef.setData(eventData) { error in
			if let error = error {
				print("Error uploading event: \(error)")
			} else {
				dbUsers.document(uid).updateData([
					"events": FieldValue.arrayUnion([eventRef.documentID])
				])
				UserServie.shared.uploadScheduledEvent(organizerID: uid, eventID: eventRef.documentID, time: event.timestamp)
				print("New event successfully created")
			}
		}
	}
	
	func fetchEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
		dbEvents.getDocuments { snapshot, error in
			var events = [Event]()
			if let error = error {
				completion(.failure(error))
			} else {
				guard let snapshot = snapshot else { return }
				let group = DispatchGroup()
				for document in snapshot.documents {
					let eventData = document.data()
					group.enter()
					UserServie.shared.getUserData(uid: eventData["userID"] as? String ?? "") { result in
						switch result {
						case .success(let user):
							let event = Event(organizer: user, dictionary: eventData)
							events.append(event)
						case .failure(let error):
							print(error)
						}
						group.leave()
					}
					
				}
				group.notify(queue: DispatchQueue.main) {
					completion(.success(events))
				}
			}
		}
	}
	
	func fetchEvent(user: User, eventID: String, completion: @escaping (Result<Event, Error>) -> Void) {
		dbEvents.document(eventID).getDocument { snapshot, error in
			if let error = error {
				completion(.failure(error))
			} else {
				guard let snapshot = snapshot, let eventData = snapshot.data() else { return }
				let event = Event(organizer: user, dictionary: eventData)
				completion(.success(event))
			}
		}
		
	}
	
}

