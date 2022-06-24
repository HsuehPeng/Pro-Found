//
//  FollowingTutorViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/24.
//

import UIKit

class FollowingTutorViewController: UIViewController {
	
	// MARK: - Properties
	
	var followingTutors: [User]
	
	var user: User
	
	private lazy var collectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		collectionView.backgroundColor = .light60
		flowLayout.itemSize = CGSize(width: view.frame.size.width, height: 280)
		flowLayout.minimumInteritemSpacing = 20
		flowLayout.minimumLineSpacing = 20
//		flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		flowLayout.headerReferenceSize = CGSize(width: view.frame.size.width, height: 50)
		collectionView.register(HomePageTutorCollectionViewCell.self, forCellWithReuseIdentifier: HomePageTutorCollectionViewCell.reuseIdentifier)
		return collectionView
	}()
	
	// MARK: - Lifecycle
	
	init(followingTutors: [User], user: User) {
		self.followingTutors = followingTutors
		self.user = user
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		collectionView.dataSource = self
		collectionView.delegate = self
		setupNavBar()
		setupUI()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationController?.navigationBar.isHidden = false
		tabBarController?.tabBar.isHidden = true
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(collectionView)
		collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
	}
	
	func setupNavBar() {

		let leftBarItemImage = UIImage.asset(.chevron_left)?.withRenderingMode(.alwaysOriginal)
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftBarItemImage, style: .done,
														   target: self, action: #selector(popVC))
		title = "Following"		
	}

	
	// MARK: - Actions
	
	@objc func popVC() {
		navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Helpers
	
	
}

// MARK: - UICollectionViewDataSource

extension FollowingTutorViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return followingTutors.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let tutorCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePageTutorCollectionViewCell.reuseIdentifier, for: indexPath)
				as? HomePageTutorCollectionViewCell else { fatalError("Can not dequeue HomePageTutorCollectionViewCell") }
		tutorCell.tutor = followingTutors[indexPath.item]
		return tutorCell
	}

}

// MARK: - UITableViewDataSource

extension FollowingTutorViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let tutor = followingTutors[indexPath.item]
		let tutorProfileVC = TutorProfileViewController(user: user, tutor: tutor)
		navigationController?.pushViewController(tutorProfileVC, animated: true)
	}
}
