//
//  allItemTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/14.
//

import UIKit

class GeneralItemTableViewCell: UITableViewCell {

	static let reuseidentifier = "\(GeneralItemTableViewCell.self)"
	
	// MARK: - Properties
	
	private let collectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		flowLayout.scrollDirection = .horizontal
		flowLayout.itemSize = CGSize(width: 138, height: 216)
//		flowLayout.minimumInteritemSpacing = 20
		flowLayout.minimumLineSpacing = 20
		flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		collectionView.register(GeneralItemCollectionViewCell.self, forCellWithReuseIdentifier: GeneralItemCollectionViewCell.reuseIdentifier)
		
		return collectionView
	}()
	
	// MARK: - Lifecycle
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		collectionView.dataSource = self
		collectionView.delegate = self
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UI
	
	func setupUI() {
		contentView.addSubview(collectionView)
		collectionView.addConstraintsToFillView(contentView)
	}
	
}

// MARK: - UICollectionViewDataSource
 
extension GeneralItemTableViewCell: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 3
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GeneralItemCollectionViewCell.reuseIdentifier, for: indexPath)
				as? GeneralItemCollectionViewCell else { return UICollectionViewCell() }
		return cell
	}
	
}

// MARK: - UICollectionViewDelegate

extension GeneralItemTableViewCell: UICollectionViewDelegate {
	
}
