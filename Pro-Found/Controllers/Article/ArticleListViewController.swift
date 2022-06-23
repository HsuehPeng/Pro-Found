//
//  ArticleListViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/23.
//

import UIKit

class ArticleListViewController: UIViewController {
	
	// MARK: - Properties
	
	let articles: [Article]
	
	var filteredArticles = [Article]()
	
	var isSearchBarEmpty: Bool {
	  return searchController.searchBar.text?.isEmpty ?? true
	}
	
	var isFiltering: Bool {
	  return searchController.isActive && !isSearchBarEmpty
	}

	
	let searchController = UISearchController()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(ArticleListTableViewCell.self, forCellReuseIdentifier: ArticleListTableViewCell.reuseIdentifier)
		return tableView
	}()
	
	// MARK: - Lifecycle
	
	init(articles: [Article]) {
		self.articles = articles
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .light60
		
		tableView.dataSource = self
		tableView.delegate = self
		
		setupUI()
		setupNavBar()
    }
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(tableView)
		tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = false
		tabBarController?.tabBar.isHidden = true
		let leftBarItemImage = UIImage.asset(.chevron_left)?.withRenderingMode(.alwaysOriginal)
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftBarItemImage, style: .done,
														   target: self, action: #selector(popVC))
		title = "Articles"
		setupSearchController()	}
	
	func setupSearchController() {
		UISearchBar.appearance().barTintColor = .orange
		searchController.searchBar.delegate = self
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Articles"
		navigationItem.searchController = searchController
		definesPresentationContext = true

	}
	
	// MARK: - Actions
	
	@objc func popVC() {
		navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Helpers
	
	func filterContentForSearchText(_ searchText: String) {
		filteredArticles = articles.filter { article -> Bool in
			return article.articleTitle.lowercased().contains(searchText.lowercased())
		}
		
		tableView.reloadData()
	}
}

// MARK: - UITableViewDataSource

extension ArticleListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isFiltering {
			return filteredArticles.count
		}
		
		return articles.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleListTableViewCell.reuseIdentifier, for: indexPath)
				as? ArticleListTableViewCell else { fatalError("Can not dequeue ArticleListTableViewCell") }
		
		if isFiltering {
			let article = filteredArticles[indexPath.row]
			cell.article = article
		} else {
			let article = articles[indexPath.row]
			cell.article = article
		}
		return cell
	}
}

// MARK: - UITableViewDelegate

extension ArticleListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let articleDetailVC = ArticleDetailViewController(article: articles[indexPath.row])
		navigationController?.pushViewController(articleDetailVC, animated: true)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 144
	}
}

// MARK: - UISearchControllerDelegate

extension ArticleListViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		filterContentForSearchText(searchBar.text!)
	}
	
	
}

extension ArticleListViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
	}
}
