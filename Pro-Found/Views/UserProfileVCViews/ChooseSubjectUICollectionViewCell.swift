//
//  ChooseSubjectUICollectionViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/25.
//

import UIKit

class ChooseSubjectUICollectionViewCell: UICollectionViewCell {
	
	static let reuseIdentifier = "\(ChooseSubjectUICollectionViewCell.self)"
	
	// MARK: - Properties
	
	let subjectImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .orange10
		imageView.layer.cornerRadius = 12
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
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
		contentView.addSubview(subjectImageView)
		subjectImageView.addConstraintsToFillView(contentView)
	}
	
	// MARK: - Actions
	
	// MARK: - Helpers
    
}
