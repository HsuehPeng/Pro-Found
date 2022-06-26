//
//  ArticlePageCollectionViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/18.
//

import UIKit
import Kingfisher

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
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
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
		button.layer.cornerRadius = 5
		button.setTitle("Subject", for: .normal)
		button.setTitleColor(UIColor.white, for: .normal)
		button.titleLabel?.font = UIFont.customFont(.interSemiBold, size: 9)
		button.backgroundColor = .orange
		return button
	}()
	
	private lazy var ratingButtonNumber: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.star)?.withTintColor(.orange40)
		button.setImage(image, for: .normal)
		button.setTitleColor(UIColor.orange40, for: .normal)
		button.titleLabel?.font = UIFont.customFont(.interSemiBold, size: 14)
		
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
		articleImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor,
								right: contentView.rightAnchor, height: 168)
		
		contentView.addSubview(titleLabel)
		titleLabel.anchor(top: articleImageView.bottomAnchor, left: contentView.leftAnchor,
						  right: contentView.rightAnchor, paddingTop: 12)
		
		contentView.addSubview(ratingButtonNumber)
		ratingButtonNumber.anchor(top: titleLabel.bottomAnchor, bottom: contentView.bottomAnchor,
								  right: contentView.rightAnchor, paddingRight: 8)
		
		contentView.addSubview(authorLabel)
		authorLabel.centerY(inView: ratingButtonNumber)
		authorLabel.anchor(left: contentView.leftAnchor)
		
	}
	
	// MARK: - Helpers
	
	func configure() {
		guard let article = article else { return }
		let imageUrl = URL(string: article.imageURL)
		
		articleImageView.kf.setImage(with: imageUrl)
		titleLabel.text = article.articleTitle
		authorLabel.text = article.authorName
		subjectButton.setTitle(article.subject, for: .normal)
		
		if article.ratings.isEmpty {
			ratingButtonNumber.setTitle("0", for: .normal)
		} else {
			ratingButtonNumber.setTitle(calculateAverageRating(article: article), for: .normal)
		}
		
	}
	
	func calculateAverageRating(article: Article) -> String {
		var ratingSum = 0.0
		for rating in article.ratings {
			ratingSum += rating.first?.value ?? 0
		}
		let averageRating = ratingSum / Double(article.ratings.count)
		let roudedAverageRating = round(averageRating * 10) / 10
		return String(roudedAverageRating)
	}
	
}
