//
//  ArticleTextView.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/18.
//

import UIKit

class ArticleTextView: UITextView {

	// MARK: - Properties
	
	let placeholderLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.customFont(.manropeRegular, size: 14)
		label.textColor = .dark30
		label.text = "Tell your story..."
		return label
	}()
	
	// MARK: - Lifecycle
	
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		
		font = UIFont.customFont(.manropeRegular, size: 14)
		isScrollEnabled = true
		
		addSubview(placeholderLabel)
		placeholderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4)
		
		NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Selectors
	
	@objc func handleTextInputChange() {
		placeholderLabel.isHidden = !text.isEmpty
	}
}
