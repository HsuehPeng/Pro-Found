//
//  ArticlePageCollectionViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/18.
//

import UIKit

class ArticlePageCollectionViewCell: UICollectionViewCell {
	
	static let reuseIdentifier = "\(ArticlePageCollectionViewCell.self)"
	
	// MARK: - Properties
	
	var article: Article? {
		didSet {
			configure()
		}
	}
	
	private let articleImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .gray
		imageView.layer.cornerRadius = 10
		return imageView
	}()
	
	private let titleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 12), textColor: UIColor.dark60, text: "Test Title")
		label.numberOfLines = 0
		return label
	}()
	
	private let authorLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 10), textColor: UIColor.dark40, text: "Test Author Name")
		label.numberOfLines = 0
		return label
	}()
	
	private let subjectButton: UIButton = {
		let button = UIButton()
		button.setTitle("Subject", for: .normal)
		button.setTitleColor(UIColor.white, for: .normal)
		button.titleLabel?.font = UIFont.customFont(.interSemiBold, size: 9)
		button.backgroundColor = .orange
		return button
	}()
	
	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UI
	
	func setupUI() {
		contentView.addSubview(articleImageView)
		articleImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, height: 168)
		
		contentView.addSubview(titleLabel)
		titleLabel.anchor(top: articleImageView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 12)
		
		contentView.addSubview(authorLabel)
		authorLabel.anchor(top: titleLabel.bottomAnchor, left: contentView.leftAnchor, paddingTop: 4)
		
		contentView.addSubview(subjectButton)
		subjectButton.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor).isActive = true
		subjectButton.anchor(left: authorLabel.rightAnchor, right: contentView.rightAnchor, paddingLeft: 2)
		
	}
	
	// MARK: - Helpers
	
	func configure() {

	}
	
}
