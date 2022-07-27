//
//  ArticleVCUnitTest.swift
//  Pro-FoundTests
//
//  Created by Hsueh Peng Tseng on 2022/7/21.
//

import XCTest
@testable import Pro_Found

class ArticleVCUnitTest: XCTestCase {

	var sut: ArticleViewController!
	
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		try super.setUpWithError()
		sut = ArticleViewController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
		sut = nil
		try super.tearDownWithError()
    }

    func test_writeArticleButtonHiddenStatus() throws {
		sut.user = nil
		XCTAssertFalse(!sut.writeArticleButton.isHidden)
		
		sut.user = User(name: "qwe", userID: "qwe", email: "qwe", introContentText: "qwe", school: "qwe", schoolMajor: "qwe",
						ratings: [], courseBooked: 0, profileImageURL: "Qwe", backgroundImageURL: "qwe", courses: [],
						articles: [], favoriteArticles: [], events: [], posts: [], blockedUsers: [], followers: [],
						followings: [], subject: "qwe", isTutor: true)
		XCTAssertFalse(sut.writeArticleButton.isHidden)
    }
	
	func test_filterArticleToSubjectDictionaryCount() throws {
		
		let articleLanguage = Article(userID: "1", articleID: "1", articleTitle: "1", authorName: "1", subject: "Language",
									  timestamp: 1, contentText: "1", imageURL: "1", ratings: [], user: User(dictionary: [:]))
		let articleTech = Article(userID: "1", articleID: "q", articleTitle: "q", authorName: "q", subject: "Technology",
								  timestamp: 1, contentText: "", imageURL: "", ratings: [], user: User(dictionary: [:]))
		
		let subjectDict: [String: [Article]] = [Subject.language.rawValue: [articleLanguage],
												Subject.music.rawValue: [],
												Subject.art.rawValue: [],
												Subject.sport.rawValue: [],
												Subject.technology.rawValue: [articleTech]
		]
		
		sut.articles = [articleLanguage, articleTech]
		sut.filterArticles()
		
		XCTAssertEqual(sut.subjectDict[Subject.language.rawValue]?.count, subjectDict[Subject.language.rawValue]?.count)
		// Article must comform equatable protocol
		XCTAssertEqual(sut.subjectDict[Subject.language.rawValue], subjectDict[Subject.language.rawValue])
		XCTAssertEqual(sut.subjectDict, subjectDict)
	}

}
