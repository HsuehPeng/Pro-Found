//
//  ArticleListViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/23.
//

import UIKit
import Lottie
import FirebaseAuth

class ArticleListViewController: UIViewController {
	
	// MARK: - Properties
	
	var articles: [Article]
	
	var filteredArticles = [Article]()
	
	var isSearchBarEmpty: Bool {
	  return searchController.searchBar.text?.isEmpty ?? true
	}
	
	var isFiltering: Bool {
	  return searchController.isActive && !isSearchBarEmpty
	}

	let searchController = UISearchController()
	
	private let noCellView: EmptyIndicatorView = {
		let view = EmptyIndicatorView()
		view.indicatorLabel.text = "No Saved Article"
		return view
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(ArticleListTableViewCell.self, forCellReuseIdentifier: ArticleListTableViewCell.reuseIdentifier)
		tableView.separatorStyle = .none
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
		setupSearchController()
		
		if articles.isEmpty {
			tableView.alpha = 0
			noCellView.indicatorLottie.loadingAnimation()
		} else {
			tableView.alpha = 1
			noCellView.indicatorLottie.stopAnimation()
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.isHidden = false
	}
	
	// MARK: - UI
	
	func setupUI() {
		
		view.addSubview(noCellView)
		noCellView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
		
		view.addSubview(tableView)
		tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
	}
	
	func setupNavBar() {
		setupAttributeNavBar(titleText: "Articles")
		let leftBarItemImage = UIImage.asset(.chevron_left)?.withRenderingMode(.alwaysOriginal)
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftBarItemImage, style: .done,
														   target: self, action: #selector(popVC))
	}
	
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
	
	func deleteArticle(article: Article, indexPath: IndexPath) {
		let loadingLottie = Lottie(superView: view, animationView: AnimationView.init(name: "loadingAnimation"))
		let controller = UIAlertController(title: "Are you sure to delete this article?", message: nil, preferredStyle: .alert)
		
		let okAction = UIAlertAction(title: "Sure", style: .destructive) { _ in
			loadingLottie.loadingAnimation()
			ArticleService.shared.deleteArticle(articleID: article.articleID, userID: article.userID) { [weak self] in
				guard let self = self else { return }
				if self.isFiltering {
					self.filteredArticles.remove(at: indexPath.row)
					self.tableView.deleteRows(at: [indexPath], with: .fade)
				} else {
					self.articles.remove(at: indexPath.row)
					self.tableView.deleteRows(at: [indexPath], with: .fade)
				}

				loadingLottie.stopAnimation()
			}
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		controller.addAction(okAction)
		controller.addAction(cancelAction)
		
		present(controller, animated: true, completion: nil)
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
		cell.delegate = self
		if isFiltering {
			let article = filteredArticles[indexPath.row]
			cell.article = article
		} else {
			let article = articles[indexPath.row]
			cell.article = article
		}
		cell.selectionStyle = .none
		return cell
	}
}

// MARK: - UITableViewDelegate

extension ArticleListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if isFiltering {
			let articleDetailVC = ArticleDetailViewController(article: filteredArticles[indexPath.row])
			navigationController?.pushViewController(articleDetailVC, animated: true)
		} else {
			let articleDetailVC = ArticleDetailViewController(article: articles[indexPath.row])
			navigationController?.pushViewController(articleDetailVC, animated: true)
		}
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

// MARK: - ArticleListTableViewCellDelegate

extension ArticleListViewController: ArticleListTableViewCellDelegate {
	func popUpUserContentAlert(_ cell: ArticleListTableViewCell) {
		guard let article = cell.article, let indexPath = tableView.indexPath(for: cell),
			  let uid = Auth.auth().currentUser?.uid else { return }
		
		let actionSheet = UIAlertController(title: "Actions", message: nil,
											preferredStyle: .actionSheet)
		
		let reportAction = UIAlertAction(title: "Report", style: .destructive) { [weak self] action in
			guard let self = self else { return }
			let reportVC = ReportViewController(contentID: article.articleID, contentType: ContentTyep.article)
			if let reportSheet = reportVC.presentationController as? UISheetPresentationController {
				reportSheet.detents = [.large()]
			}
			self.present(reportVC, animated: true)
		}
		actionSheet.addAction(reportAction)
		
		if article.user.userID == uid {
			let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] action in
				guard let self = self else { return }
				self.deleteArticle(article: article, indexPath: indexPath)
			}
			actionSheet.addAction(deleteAction)
		}

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		actionSheet.addAction(cancelAction)
		
		self.present(actionSheet, animated: true, completion: nil)
	}
}
