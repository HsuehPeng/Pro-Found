//
//  GeneralItemCollectionViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/14.
//

import UIKit
import Kingfisher

class HomePageTutorCollectionViewCell: UICollectionViewCell {
	
	static let reuseIdentifier = "\(HomePageTutorCollectionViewCell.self)"
	
    // MARK: - Properties
	
	var tutor: User? {
		didSet {
			configure()
		}
	}
	
	private let tutorImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .gray
		imageView.layer.cornerRadius = 10
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		return imageView
	}()
	
	private let nameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 13),
												 textColor: UIColor.dark60, text: "Test Name")
		label.numberOfLines = 0
		return label
	}()
	
	private let schoolLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: UIColor.dark40, text: "University")
		label.numberOfLines = 0
		return label
	}()
	
	private lazy var ratingButton: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.star)?.withTintColor(.orange40)
		button.setImage(image, for: .normal)
		button.titleLabel?.font = UIFont.customFont(.interSemiBold, size: 14)
		button.setTitleColor(UIColor.orange40, for: .normal)
		return button
	}()
	
	private let followersLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12), textColor: UIColor.dark40, text: "Followers: 100")
		return label
	}()
	
	private let subjectButton: UIButton = {
		let button = UIButton()
		button.setTitle("Subject", for: .normal)
		button.setTitleColor(UIColor.white, for: .normal)
		button.titleLabel?.font = UIFont.customFont(.interSemiBold, size: 10)
		button.widthAnchor.constraint(equalToConstant: 70).isActive = true
		button.heightAnchor.constraint(equalToConstant: 25).isActive = true
		button.layer.cornerRadius = 5
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
		contentView.addSubview(tutorImageView)
		tutorImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor,
							  right: contentView.rightAnchor, paddingLeft: 16, paddingRight: 16, height: 200)
		
		contentView.addSubview(nameLabel)
		nameLabel.anchor(top: tutorImageView.bottomAnchor, left: tutorImageView.leftAnchor, paddingTop: 12)
		nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7).isActive = true
		
		contentView.addSubview(schoolLabel)
		schoolLabel.anchor(top: nameLabel.bottomAnchor, left: tutorImageView.leftAnchor, paddingTop: 2)
		schoolLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7).isActive = true
		
		contentView.addSubview(ratingButton)
		ratingButton.anchor(top: tutorImageView.bottomAnchor, right: tutorImageView.rightAnchor, paddingTop: 6)
		
		contentView.addSubview(followersLabel)
		followersLabel.anchor(top: schoolLabel.bottomAnchor, left: tutorImageView.leftAnchor, paddingTop: 2)
		followersLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7).isActive = true
		
		contentView.addSubview(subjectButton)
		subjectButton.anchor(top: ratingButton.bottomAnchor, right: tutorImageView.rightAnchor, paddingTop: 8)
		
	}
	
	// MARK: - Helpers
	
	func configure() {
		guard let tutor = tutor else { return }
		let imageUrl = URL(string: tutor.profileImageURL)
		nameLabel.text = tutor.name
		tutorImageView.kf.setImage(with: imageUrl)
		followersLabel.text = "\(tutor.followers.count)  Followers ・ \(tutor.courseBooked)  Courses Booked"
		subjectButton.setTitle(tutor.subject, for: .normal)
		ratingButton.setTitle(calculateAverageRating(tutor: tutor), for: .normal)
		schoolLabel.text = tutor.school
		
		setSubjectButtonColor(subject: tutor.subject, targetView: subjectButton)
		
	}
	
	func calculateAverageRating(tutor: User) -> String {
		guard !tutor.ratings.isEmpty else { return "Non" }
		var ratingSum = 0.0
		for rating in tutor.ratings {
			ratingSum += rating.first?.value ?? 0
		}
		let averageRating = ratingSum / Double(tutor.ratings.count)
		let roudedAverageRating = round(averageRating * 10) / 10
		return String(roudedAverageRating)
	}
	
}
