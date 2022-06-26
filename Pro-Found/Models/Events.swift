//
//  Events.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/15.
//

import Foundation

struct Event: Codable {
	let userID: String
	let eventID: String
	let eventTitle: String
	let organizerName: String
	let timestamp: Double
	let location: String
	let introText: String
	let imageURL: String
	var organizer: User
	var participants: [String]
}

extension Event {
	init(organizer: User, dictionary: [String: Any]) {
		self.organizer = organizer
		participants = dictionary["participants"] as? [String] ?? []
		userID = dictionary["userID"] as? String ?? ""
		eventTitle = dictionary["eventTitle"] as? String ?? ""
		eventID = dictionary["eventID"] as? String ?? ""
		organizerName = dictionary["organizerName"] as? String ?? ""
		timestamp = dictionary["timestamp"] as? Double ?? 0
		location = dictionary["location"] as? String ?? ""
		introText = dictionary["introText"] as? String ?? ""
		imageURL = dictionary["imageURL"] as? String ?? ""
	}
}

struct FirebaseEvent: Codable {
	let userID: String
	let eventTitle: String
	let organizerName: String
	let timestamp: Double
	let location: String
	let introText: String
	let imageURL: String
	var participants: [String]
}

struct ScheduledEventTime: Codable {
	let eventID: String
	let time: Double
}
