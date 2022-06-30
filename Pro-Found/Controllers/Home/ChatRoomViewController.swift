//
//  ChatRoomViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/30.
//

import UIKit

class ChatRoomViewController: UIViewController {
	
	// MARK: - Properties
	
	let searchController = UISearchController()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		return tableView
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .light60
		
//		tableView.dataSource = self
		tableView.delegate = self
		
		setupUI()
		setupNavBar()
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(tableView)
		tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
						 right: view.rightAnchor)
	}
	
	func setupNavBar() {
		title = "Message"
		let titleAttribute: [NSAttributedString.Key: Any] = [
			.font: UIFont.customFont(.interBold, size: 16)
		]
		let appearance = UINavigationBarAppearance()
		appearance.titleTextAttributes = titleAttribute
		appearance.configureWithDefaultBackground()
		navigationController?.navigationBar.standardAppearance = appearance
		navigationController?.navigationBar.isHidden = false
		tabBarController?.tabBar.isHidden = true
		let leftImage = UIImage.asset(.chevron_left)?.withRenderingMode(.alwaysOriginal).withTintColor(.dark40)
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage, style: .done, target: self, action: #selector(popVC))
		
		setupSearchController()
	}
	
	func setupSearchController() {
		UISearchBar.appearance().barTintColor = .orange
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Chat"
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}
	
	// MARK: - Actions
	
	@objc func popVC() {
		navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Helpers
	
	func filterContentForSearchText(_ searchText: String) {
//		filteredArticles = articles.filter { article -> Bool in
//			return article.articleTitle.lowercased().contains(searchText.lowercased())
//		}
		tableView.reloadData()
	}
}

// MARK: - UITableViewDataSource

//extension ChatRoomViewController: UITableViewDataSource {
//
//}

// MARK: - UITableViewDelegate

extension ChatRoomViewController: UITableViewDelegate {
	
}

// MARK: - UISearchControllerDelegate

extension ChatRoomViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
//		filterContentForSearchText(searchBar.text!)
	}
}
