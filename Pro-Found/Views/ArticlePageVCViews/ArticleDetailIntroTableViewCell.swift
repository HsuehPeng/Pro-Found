//
//  ArticleDetailIntroTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/18.
//

import UIKit
import Kingfisher
import Cosmos
import FirebaseAuth

class ArticleDetailIntroTableViewCell: UITableViewCell {
	
	static let reuseIdentifier = "\(ArticleDetailIntroTableViewCell.self)"
	
	// MARK: - Properties
	
	var article: Article? {
		didSet {
			configure()
		}
	}
	
	var rateViewIsUp = false
	
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
	
	private lazy var ratingButtonNumber: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.star)?.withTintColor(.orange40)
		button.setImage(image, for: .normal)
		button.setTitle("0", for: .normal)
		button.setTitleColor(UIColor.orange40, for: .normal)
		button.addTarget(self, action: #selector(handleRateArticle), for: .touchUpInside)
		
		return button
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
	
	private let ratingView: UIView = {
		let view = UIView()
		view.backgroundColor = .dark40
		view.setDimensions(width: 170, height: 40)
		view.layer.cornerRadius = 20

		return view
	}()
	
	private let starView: CosmosView = {
		let starView = CosmosView()
		starView.settings.filledColor = .orange40
		starView.settings.fillMode = .full
		starView.rating = 0
		return starView
	}()
	
	private lazy var sendButton: UIButton = {
		lazy var sentButton = UIButton()
		let image = UIImage.asset(.send)?.withTintColor(.orange40)
		sentButton.setImage(image, for: .normal)
		sentButton.addTarget(self, action: #selector(handleSendRating), for: .touchUpInside)
		return sentButton
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
		
		let infoOneVStack = UIStackView(arrangedSubviews: [ratingTitleLabel, ratingButtonNumber])
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
		
		ratingView.addSubview(starView)
		starView.centerY(inView: ratingView, leftAnchor: ratingView.leftAnchor, paddingLeft: 12)
		
		ratingView.addSubview(sendButton)
		sendButton.centerY(inView: ratingView, leftAnchor: starView.rightAnchor, paddingLeft: 8)
	}
	
	// MARK: - Actions
	
	@objc func handleRateArticle() {
		
		if !rateViewIsUp {
			contentView.addSubview(ratingView)
			ratingView.anchor(left: contentView.leftAnchor, bottom: ratingButtonNumber.topAnchor, paddingLeft: 8,
							  paddingBottom: 8)
			ratingView.alpha = 0
			ratingView.transform = CGAffineTransform(translationX: 10, y: 10)
			rateViewIsUp = true
			UIView.animate(withDuration: 0.3) {
				self.ratingView.alpha = 1
				self.ratingView.transform = CGAffineTransform.identity
			}
		} else {
			rateViewIsUp = false
			UIView.animate(withDuration: 0.3, animations: {
				self.ratingView.alpha = 0
			}) { status in
				self.ratingView.removeFromSuperview()
			}
		}
	}
	
	@objc func handleSendRating() {
		guard let article = article, let uid = Auth.auth().currentUser?.uid else { return }
		ArticleService.shared.rateArticle(senderID: uid, articleID: article.articleID, rating: starView.rating)
		rateViewIsUp = false
		UIView.animate(withDuration: 0.4, animations: {
			self.ratingView.alpha = 0
		}) { status in
			self.ratingView.removeFromSuperview()
		}
	}
	
	// MARK: - Helpers
	
	func configure() {
		guard let article = article else { return }
		let imageUrl = URL(string: article.imageURL)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM dd, yyyy"
		let postDate = Date(timeIntervalSince1970: article.timestamp)
		
		articleImageView.kf.setImage(with: imageUrl)
		articleTitleLabel.text = article.articleTitle
		authorNameLabel.text = "By \(article.authorName)"
		dateLabel.text = dateFormatter.string(from: postDate)
		subjectLabel.text = article.subject

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
