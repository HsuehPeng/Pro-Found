//
//  ArticleListTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/21.
//

import UIKit
import Kingfisher

class ArticleListTableViewCell: UITableViewCell {
	
	static let reuseIdentifier = "\(ArticleListTableViewCell.self)"

	// MARK: - Properties
	
	var article: Article? {
		didSet {
			configureUI()
		}
	}
	
	private let articleImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.layer.cornerRadius = 10
		imageView.setDimensions(width: 100, height: 128)
		imageView.backgroundColor = .dark20
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private let articleTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 14),
												 textColor: .dark60, text: "Test Title")
		label.numberOfLines = 0
		return label
	}()
	
	private lazy var editButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.asset(.more), for: .normal)
		return button
	}()
	
	private let authorLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: .dark40, text: "Author Name")
		label.numberOfLines = 0
		return label
	}()
	
	private let dateLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: .dark40, text: "June 21, 2022")
		label.numberOfLines = 0
		return label
	}()
	
	private lazy var subjectButton: UIButton = {
		let button = UIButton()
		button.layer.cornerRadius = 5
		button.setTitle("Subject", for: .normal)
		button.setTitleColor(UIColor.white, for: .normal)
		button.titleLabel?.font = UIFont.customFont(.interSemiBold, size: 10)
		button.setDimensions(width: 80, height: 25)
		button.backgroundColor = .orange
		return button
	}()
	
	private lazy var ratingButtonNumber: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.star)?.withTintColor(.orange40)
		button.setImage(image, for: .normal)
		button.setTitle("0", for: .normal)
		button.setTitleColor(UIColor.orange40, for: .normal)
		
		return button
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
		articleImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
								paddingTop: 8, paddingLeft: 16, paddingBottom: 8)
		
		contentView.addSubview(articleTitleLabel)
		articleTitleLabel.anchor(top: articleImageView.topAnchor, left: articleImageView.rightAnchor,
								 right: contentView.rightAnchor, paddingLeft: 12)
		
		contentView.addSubview(editButton)
		editButton.centerY(inView: articleTitleLabel)
		editButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
		
		contentView.addSubview(dateLabel)
		dateLabel.anchor(top: articleTitleLabel.bottomAnchor, left: articleImageView.rightAnchor,
								 right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 12)
		
		contentView.addSubview(authorLabel)
		authorLabel.anchor(top: dateLabel.bottomAnchor, left: articleImageView.rightAnchor,
								 right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 12)
		
		contentView.addSubview(subjectButton)
		subjectButton.anchor(top: authorLabel.bottomAnchor, left: articleImageView.rightAnchor,
							 paddingTop: 16, paddingLeft: 12)
		contentView.addSubview(ratingButtonNumber)
		ratingButtonNumber.centerY(inView: subjectButton, leftAnchor: subjectButton.rightAnchor, paddingLeft: 60)
	}
	
	// MARK: - Actions
	
	// MARK: - Helpers
	
	func configureUI() {
		guard let article = article else { return }
		let imageURL = URL(string: article.imageURL)
		let timestamp = article.timestamp
		let date = Date(timeIntervalSince1970: timestamp)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM dd, yyyy"
		let articleDate = dateFormatter.string(from: date)
		
		articleImageView.kf.setImage(with: imageURL)
		articleTitleLabel.text = article.articleTitle
		dateLabel.text = articleDate
		authorLabel.text = article.authorName
		subjectButton.setTitle(article.subject, for: .normal)
		
		if article.ratings.count == 0 {
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
