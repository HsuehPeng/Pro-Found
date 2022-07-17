//
//  LoginService.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/16.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift

enum ContentTyep {
	case article
	case post
	case event
	case course
}

struct ReportService {
	
	static let shared = ReportService()
	
	func uploadReport(contentID: String, report: Report, contentTyep: ContentTyep, completion: (Error?) -> Void) {
//
//		do {
//			switch contentTyep {
//			case .article:
//
//			case .post:
//
//			case .event:
//
//			case .course:
//
//			}
//
//		} catch {
//			print("Error uploading user to Firestore: \(error)")
//			completion(error)
//		}
	}
}
