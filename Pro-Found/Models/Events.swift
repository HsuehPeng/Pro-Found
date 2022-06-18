//
//  Events.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import Foundation

struct Event {
	let userID: String
	let eventID: String
	let eventTitle: String
	let organizerName: String
	let timestamp: Double
	let location: String
	let introText: String
	let imageURL: String
	var organizer: User
	var participants: [User]
}

extension Event {
	init(organizer: User, dictionary: [String: Any], eventID: String, participants: [User]) {
		self.organizer = organizer
		self.eventID = eventID
		self.participants = participants
		userID = dictionary["userID"] as? String ?? ""
		eventTitle = dictionary["eventTitle"] as? String ?? ""
		organizerName = dictionary["organizerName"] as? String ?? ""
		timestamp = dictionary["timestamp"] as? Double ?? 0
		location = dictionary["location"] as? String ?? ""
		introText = dictionary["introText"] as? String ?? ""
		imageURL = dictionary["ratings"] as? String ?? ""
	}
}

struct FirebaseEvent {
	let userID: String
	let eventID: String
	let eventTitle: String
	let organizerName: String
	let timestamp: Double
	let location: String
	let introText: String
	let imageURL: String
	var participants: [String]
}
