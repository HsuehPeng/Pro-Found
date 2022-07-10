//
//  ArticleDetailContentTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/18.
//

import UIKit

class ArticleDetailContentTableViewCell: UITableViewCell {

	static let reuseIdentifier = "\(ArticleDetailContentTableViewCell.self)"
	
	// MARK: - Properties
	
	var article: Article? {
		didSet {
			configure()
		}
	}
	
	private let contentTextView: UITextView = {
		let textView = UITextView()
		textView.isEditable = false
		textView.textColor = UIColor.dark
		textView.backgroundColor = .orange10
		textView.font = UIFont.customFont(.manropeRegular, size: 15)
		textView.isScrollEnabled = false
		return textView
	}()
	
	
	
	// MARK: - Lifecycle
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .orange10
		setupUI()
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UI
	
	func setupUI() {
		contentView.addSubview(contentTextView)
		contentTextView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
							   right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16)
		
	}
	
	// MARK: - Helpers
	
	func configure() {
		guard let article = article else { return }
		contentTextView.text = article.contentText
		
		let data = Data(article.contentText.utf8)
		if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
			contentTextView.attributedText = attributedString
		}
	}

}
