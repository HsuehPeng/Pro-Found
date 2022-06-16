//
//  allItemTableViewCell.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/14.
//

import UIKit

protocol HomePageTutorListTableViewCellDelegate: AnyObject {
	func goToTutorProfile(_ cell: HomePageTutorListTableViewCell, tutor: User)
}

class HomePageTutorListTableViewCell: UITableViewCell {

	static let reuseidentifier = "\(HomePageTutorListTableViewCell.self)"
	
	weak var delegate: HomePageTutorListTableViewCellDelegate?
	
	// MARK: - Properties
	
	var tutors: [User]? {
		didSet {
			collectionView.reloadData()
		}
	}
	
	private let collectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		flowLayout.scrollDirection = .horizontal
		flowLayout.itemSize = CGSize(width: 138, height: 216)
//		flowLayout.minimumInteritemSpacing = 20
		flowLayout.minimumLineSpacing = 20
		flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		collectionView.register(HomePageTutorCollectionViewCell.self, forCellWithReuseIdentifier: HomePageTutorCollectionViewCell.reuseIdentifier)
		
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
 
extension HomePageTutorListTableViewCell: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return tutors?.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePageTutorCollectionViewCell.reuseIdentifier, for: indexPath)
				as? HomePageTutorCollectionViewCell, let tutors = tutors else { return UICollectionViewCell() }

		cell.tutor = tutors[indexPath.row]
		return cell
	}
	
}

// MARK: - UICollectionViewDelegate

extension HomePageTutorListTableViewCell: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let tutors = tutors else { return }
		let tutor = tutors[indexPath.row]
		delegate?.goToTutorProfile(self, tutor: tutor)
	}
}
