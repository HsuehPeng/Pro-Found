//
//  Pro_FoundTests.swift
//  Pro-FoundTests
//
//  Created by Hsueh Peng Tseng on 2022/7/21.
//

import XCTest
@testable import Pro_Found

class Pro_FoundTests: XCTestCase {
	
	var sut: UserServie!
	let networkMonitor = NetworkMonitor.shared

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		try super.setUpWithError()
		sut = UserServie()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
		sut = nil
		try super.tearDownWithError()
    }
	
	func test_FetchUserData() throws {
		try XCTSkipUnless(networkMonitor.isReachable, "Network connectivity needed for this test.")
		
		let promise = expectation(description: "Get user data back from firebase")
		
		sut.getUserData(uid: "mN1JZWjtHYalteZuLpSn6TtyN9z1") { result in
			switch result {
			case .failure(let error):
				XCTFail("Error: \(error.localizedDescription)")
			case .success(let user):
				promise.fulfill()
			}
		}
		
		wait(for: [promise], timeout: 3)
	}
	
	func test_checkIfUserExistOnFirebase() throws {
		try XCTSkipUnless(networkMonitor.isReachable, "Network connectivity needed for this test.")
		
		let promise = expectation(description: "Check if userExist On Firebase")
		
		sut.checkIfUserExistOnFirebase(uid: "mN1JZWjtHYalteZuLpSn6TtyN9z1") { result in
			switch result {
			case .failure(let error):
				XCTFail("Error: \(error.localizedDescription)")
			case .success(true):
				promise.fulfill()
			case .success(false):
				promise.fulfill()
			}
		}
		wait(for: [promise], timeout: 3)
	}
}
