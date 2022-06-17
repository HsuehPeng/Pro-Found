//
//  ScheduleActivityListCollectionViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/16.
//

import UIKit

class ScheduleActivityListCollectionViewCell: UICollectionViewCell {
    
	static let reuseIdentifier = "\(ScheduleActivityListCollectionViewCell.self)"
	
	// MARK: - Properties
	
	var course: Course? {
		didSet {
			configure()
		}
	}
	
	var event: Event?
	
	private let titleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 14),
												 textColor: .dark60, text: "Class Test Title")
		return label
	}()
	
	private let organizerLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 14),
												 textColor: .dark60, text: "Organizer Test Name")
		return label
	}()
	
	// MARK: - Lifecycle 
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
		contentView.backgroundColor = .dark20
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UI
	
	func setupUI() {
		contentView.addSubview(titleLabel)
		titleLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 16, paddingLeft: 16)
		
		contentView.addSubview(organizerLabel)
		organizerLabel.anchor(top: titleLabel.bottomAnchor, left: contentView.leftAnchor, paddingTop: 16, paddingLeft: 16)
	}
	
	// MARK: - Helpers
	
	func configure() {
		guard let course = course else { return }
		titleLabel.text = course.courseTitle
		organizerLabel.text = course.tutorName
	}
	
}
