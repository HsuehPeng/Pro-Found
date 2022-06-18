//
//  ArticlePageTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/18.
//

import UIKit

class ArticlePageTableViewCell: UITableViewCell {

	static let reuseidentifier = "\(ArticlePageTableViewCell.self)"
		
	// MARK: - Properties
	
	var filteredArticles: [Article]? {
		didSet {
			collectionView.reloadData()
		}
	}
	
	private let collectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		flowLayout.scrollDirection = .horizontal
		flowLayout.itemSize = CGSize(width: 138, height: 236)
		//		flowLayout.minimumInteritemSpacing = 20
		flowLayout.minimumLineSpacing = 20
		flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		collectionView.register(ArticlePageCollectionViewCell.self, forCellWithReuseIdentifier: ArticlePageCollectionViewCell.reuseIdentifier)
		
		return collectionView
	}()
	
	// MARK: - Lifecycle
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		collectionView.dataSource = self
		collectionView.delegate = self
		
		contentView.backgroundColor = .red
		
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

extension ArticlePageTableViewCell: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//		return filteredArticles?.count ?? 0
		return 5
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticlePageCollectionViewCell.reuseIdentifier, for: indexPath)
				as? ArticlePageCollectionViewCell else { fatalError("Can not dequeue ArticlePageCollectionViewCell") }

//		cell.article = filteredArticles[indexPath.item]
		return cell
	}

}

// MARK: - UICollectionViewDelegate

extension ArticlePageTableViewCell: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

	}
}
