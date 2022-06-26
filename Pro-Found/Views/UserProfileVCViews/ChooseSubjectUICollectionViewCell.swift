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
		imageView.backgroundColor = .light
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		return imageView
	}()
	

	
	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .red
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UI
	
	func setupUI() {
		addSubview(subjectImageView)
		subjectImageView.addConstraintsToFillView(self)
	}
	
	// MARK: - Actions
	
	// MARK: - Helpers
    
}
