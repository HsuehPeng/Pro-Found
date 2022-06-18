//
//  ArticleDetailIntroTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/18.
//

import UIKit
import Kingfisher

class ArticleDetailIntroTableViewCell: UITableViewCell {
	
	static let reuseIdentifier = "\(ArticleDetailIntroTableViewCell.self)"
	
	// MARK: - Properties
	
	var article: Article? {
		didSet {
			configure()
		}
	}
	
	private let articleImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.setDimensions(width: 132, height: 200)
		imageView.layer.cornerRadius = 12
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private let articleTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 16),
												 textColor: UIColor.dark60, text: "Article Title")
		return label
	}()
	
	private let authorNameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14),
												 textColor: UIColor.dark40, text: "By author name")
		return label
	}()
	
	private let ratingTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: UIColor.dark40, text: "Rating")
		return label
	}()
	
	private let ratingLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 14),
												 textColor: UIColor.dark60, text: "0")
		return label
	}()
	
	private let dateTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: UIColor.dark40, text: "Created Date")
		return label
	}()
	
	private let dateLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 14),
												 textColor: UIColor.dark60, text: "06/18/2022")
		return label
	}()
	
	private let subjectTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: UIColor.dark40, text: "Subject")
		return label
	}()
	
	private let subjectLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 14),
												 textColor: UIColor.dark60, text: "Subject")
		return label
	}()
	
	// MARK: - Lifecycle
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UI
	
	func setupUI() {
		contentView.addSubview(articleImageView)
		articleImageView.centerX(inView: contentView, topAnchor: contentView.topAnchor, paddingTop: 8)
		
		contentView.addSubview(articleTitleLabel)
		articleTitleLabel.centerX(inView: contentView, topAnchor: articleImageView.bottomAnchor, paddingTop: 30)
		
		contentView.addSubview(authorNameLabel)
		authorNameLabel.centerX(inView: contentView, topAnchor: articleTitleLabel.bottomAnchor, paddingTop: 14)
		
		let infoOneVStack = UIStackView(arrangedSubviews: [ratingTitleLabel, ratingLabel])
		infoOneVStack.axis = .vertical
		infoOneVStack.alignment = .center
		infoOneVStack.spacing = 5
		let infoTwoVStack = UIStackView(arrangedSubviews: [dateTitleLabel, dateLabel])
		infoTwoVStack.axis = .vertical
		infoTwoVStack.alignment = .center
		infoTwoVStack.spacing = 5
		let infoThreeVStack = UIStackView(arrangedSubviews: [subjectTitleLabel, subjectLabel])
		infoThreeVStack.axis = .vertical
		infoThreeVStack.alignment = .center
		infoThreeVStack.spacing = 5
		let infoHStack = UIStackView(arrangedSubviews: [infoOneVStack, infoTwoVStack, infoThreeVStack])
		infoHStack.axis = .horizontal
		infoHStack.distribution = .fillEqually
		contentView.addSubview(infoHStack)
		infoHStack.anchor(top: authorNameLabel.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
						  right: contentView.rightAnchor, paddingTop: 36, paddingBottom: 24)
		
	}
	
	// MARK: - Helpers
	
	func configure() {
		guard let article = article else { return }
		let imageUrl = URL(string: article.imageURL)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM dd, yyyy"
		let postDate = Date(timeIntervalSince1970: article.timestamp)
		articleImageView.kf.setImage(with: imageUrl)
		articleTitleLabel.text = article.articleTitle
		authorNameLabel.text = "By \(article.authorName)"

		if article.ratings.isEmpty {
			ratingLabel.text = "0"
		} else {
			let rating = article.ratings.reduce(0.0) { $0 + $1 } / Double(article.ratings.count)
			ratingLabel.text = "\(rating)"
		}
		
		dateLabel.text = dateFormatter.string(from: postDate)
		subjectLabel.text = article.subject
	}
}
