//
//  FollowingTutorViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/24.
//

import UIKit

class TutorListViewController: UIViewController {
	
	// MARK: - Properties
	
	var user: User
	
	var tutors: [User]
	
	var filteredTutors = [User]()
	
	var isSearchBarEmpty: Bool {
	  return searchController.searchBar.text?.isEmpty ?? true
	}
	
	var isFiltering: Bool {
	  return searchController.isActive && !isSearchBarEmpty
	}
	
	let searchController = UISearchController()
	
	var forBlockingPage = false
	
	let noCellView: EmptyIndicatorView = {
		let view = EmptyIndicatorView()
		view.indicatorLabel.text = "No Tutor"
		return view
	}()
	
	private lazy var collectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		collectionView.backgroundColor = .light60
		flowLayout.itemSize = CGSize(width: view.frame.size.width, height: 280)
		flowLayout.minimumInteritemSpacing = 20
		flowLayout.minimumLineSpacing = 20
//		flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		flowLayout.headerReferenceSize = CGSize(width: view.frame.size.width, height: 50)
		
		collectionView.register(HomePageTutorCollectionViewCell.self,
								forCellWithReuseIdentifier: HomePageTutorCollectionViewCell.reuseIdentifier)
		
		return collectionView
	}()
	
	// MARK: - Lifecycle
	
	init(tutors: [User], user: User) {
		self.tutors = tutors
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
		
		if tutors.isEmpty {
			collectionView.alpha = 0
			noCellView.indicatorLottie.loadingAnimation()
		} else {
			collectionView.alpha = 1
			noCellView.indicatorLottie.stopAnimation()
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationController?.navigationBar.isHidden = false
		tabBarController?.tabBar.isHidden = true
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(noCellView)
		noCellView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
		
		view.addSubview(collectionView)
		collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
	}
	
	func setupNavBar() {

		let leftBarItemImage = UIImage.asset(.chevron_left)?.withRenderingMode(.alwaysOriginal)
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftBarItemImage, style: .done,
														   target: self, action: #selector(popVC))
		
		title = forBlockingPage ? "Blocked Users" : "Following"
		setupSearchController()
	}

	
	// MARK: - Actions
	
	@objc func popVC() {
		navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Helpers
	func setupSearchController() {
		UISearchBar.appearance().barTintColor = .orange
		searchController.searchBar.delegate = self
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Tutors"
		navigationItem.searchController = searchController
		definesPresentationContext = true

	}
	
	func filterContentForSearchText(_ searchText: String) {
		filteredTutors = tutors.filter { tutor -> Bool in
			return tutor.name.lowercased().contains(searchText.lowercased())
		}
		
		collectionView.reloadData()
	}
}

// MARK: - UICollectionViewDataSource

extension TutorListViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if isFiltering {
			return filteredTutors.count
		}
		return tutors.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let tutorCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePageTutorCollectionViewCell.reuseIdentifier, for: indexPath)
				as? HomePageTutorCollectionViewCell else { fatalError("Can not dequeue HomePageTutorCollectionViewCell") }
		
		if isFiltering {
			tutorCell.tutor = filteredTutors[indexPath.item]
		} else {
			tutorCell.tutor = tutors[indexPath.item]
		}
		return tutorCell
	}

}

// MARK: - UICollectionViewDelegate

extension TutorListViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		if isFiltering {
			let tutorProfileVC = TutorProfileViewController(user: user, tutor: filteredTutors[indexPath.item])
			navigationController?.pushViewController(tutorProfileVC, animated: true)
		} else {
			let tutorProfileVC = TutorProfileViewController(user: user, tutor: tutors[indexPath.item])
			navigationController?.pushViewController(tutorProfileVC, animated: true)
		}
	}
}

extension TutorListViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		filterContentForSearchText(searchBar.text!)
	}
}

extension TutorListViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
	}
}
