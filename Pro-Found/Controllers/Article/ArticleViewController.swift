//
//  ArticleViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/13.
//

import UIKit
import FirebaseAuth

class ArticleViewController: UIViewController {

	// MARK: - Properties
	
	var user: User? {
		didSet {
			guard let user = user else { return }
			if user.isTutor {
				writeArticleButton.isHidden = false
			} else {
				writeArticleButton.isHidden = true
			}
		}
	}
	
	var articles = [Article]()
	
	var subjectDict: [String: [Article]] = [:]
	
	private lazy var refreshControl: UIRefreshControl = {
		let refresh = UIRefreshControl()
		refresh.addTarget(self, action: #selector(pullToRefresh), for: UIControl.Event.valueChanged)
		return refresh
	}()
	
	private let topBarView: UIView = {
		let view = UIView()
		return view
	}()
	
	private let pageTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 24),
												 textColor: UIColor.dark60, text: "Articles")
		return label
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(ArticlePageTableViewCell.self, forCellReuseIdentifier: ArticlePageTableViewCell.reuseidentifier)
		tableView.register(GeneralTableViewHeader.self, forHeaderFooterViewReuseIdentifier: GeneralTableViewHeader.reuseIdentifier)
		tableView.separatorStyle = .none
		return tableView
	}()
	
	private lazy var writeArticleButton: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.edit)?.withTintColor(UIColor.orange)
		button.setImage(image, for: .normal)
		button.isHidden = true
		button.setDimensions(width: 54, height: 54)
		button.layer.cornerRadius = 54 / 2
		button.backgroundColor = .light60
		button.layer.shadowColor = UIColor.dark60.cgColor
		button.layer.shadowOffset = CGSize(width: 0, height: 4)
		button.layer.shadowRadius = 10
		button.layer.shadowOpacity = 0.3
		button.addTarget(self, action: #selector(handleWriteArticle), for: .touchUpInside)

		return button
	}()
	
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .light60
		
		tableView.dataSource = self
		tableView.delegate = self
		
		setupUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		loadUserData()
		setupNavBar()
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(topBarView)
		topBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
						  right: view.rightAnchor, height: 48)
		
		topBarView.addSubview(pageTitleLabel)
		pageTitleLabel.centerY(inView: topBarView, leftAnchor: topBarView.leftAnchor, paddingLeft: 16)
		
		view.addSubview(tableView)
		tableView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
		
		tableView.addSubview(refreshControl)
		
		view.addSubview(writeArticleButton)
		writeArticleButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 24, paddingRight: 16)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = true
		tabBarController?.tabBar.isHidden = false
	}
	
	// MARK: - Actions
	
	@objc func pullToRefresh() {
		ArticleService.shared.fetchArticles { [weak self] result in
			guard let self = self, let user = self.user else { return }
			switch result {
			case.success(let articles):
				let filterBlockedArticles = articles.filter { !user.blockedUsers.contains($0.user.userID) }
				self.articles = filterBlockedArticles
				self.filterArticles()
				self.refreshControl.endRefreshing()
			case .failure(let error):
				self.showAlert(alertText: "Error", alertMessage: "Internate connection issue")
				print(error)
			}
		}
	}
	
	@objc func handleWriteArticle() {
		guard let user = user else { return }
		let writeArticleVC = WriteArticleViewController(user: user)
		writeArticleVC.modalPresentationStyle = .fullScreen
		present(writeArticleVC, animated: true)
	}
	
	// MARK: - Helpers
	
	func loadUserData() {
		guard let uid = Auth.auth().currentUser?.uid  else {
			configureForNoUser()
			return
		}
		UserServie.shared.getUserData(uid: uid) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let user):
				self.user = user
				self.fetchArticles()
			case .failure(let error):
				self.showAlert(alertText: "Error", alertMessage: "Internate connection issue")
				print(error)
			}
		}
	}
	
	func fetchArticles() {
		ArticleService.shared.fetchArticles { [weak self] result in
			guard let self = self, let user = self.user else { return }
			switch result {
			case.success(let articles):
				let filterBlockedArticles = articles.filter { !user.blockedUsers.contains($0.user.userID) }
				self.articles = filterBlockedArticles
				self.filterArticles()
			case .failure(let error):
				self.showAlert(alertText: "Error", alertMessage: "Internate connection issue")
				print(error)
			}
		}
	}
	
	func configureForNoUser() {
		ArticleService.shared.fetchArticles { [weak self] result in
			guard let self = self else { return }
			switch result {
			case.success(let articles):
				self.articles = articles
				self.filterArticles()
			case .failure(let error):
				self.showAlert(alertText: "Error", alertMessage: "Internate connection issue")
				print(error)
			}
		}
	}
	
	func filterArticles() {
		var languageArticles:[Article] = []
		var artArticles:[Article] = []
		var musicArticles:[Article] = []
		var sportArticles:[Article] = []
		var techArticles:[Article] = []
		
		for article in articles {
			switch article.subject {
			case Subject.language.rawValue:
				languageArticles.append(article)
				
			case Subject.art.rawValue:
				artArticles.append(article)
				
			case Subject.music.rawValue:
				musicArticles.append(article)
				
			case Subject.sport.rawValue:
				sportArticles.append(article)
				
			case Subject.technology.rawValue:
				techArticles.append(article)
				
			default:
				break
			}
		}
		subjectDict[Subject.language.rawValue] = languageArticles.sorted { $0.timestamp > $1.timestamp }
		subjectDict[Subject.art.rawValue] = artArticles.sorted { $0.timestamp > $1.timestamp }
		subjectDict[Subject.music.rawValue] = musicArticles.sorted { $0.timestamp > $1.timestamp }
		subjectDict[Subject.sport.rawValue] = sportArticles.sorted { $0.timestamp > $1.timestamp }
		subjectDict[Subject.technology.rawValue] = techArticles.sorted { $0.timestamp > $1.timestamp }
		tableView.reloadData()
	}
	
}

// MARK: - UITableViewDataSource

extension ArticleViewController: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		5
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticlePageTableViewCell.reuseidentifier, for: indexPath)
				as? ArticlePageTableViewCell else { return UITableViewCell() }
		cell.articleTableViewDelegate = self
		
		switch indexPath.section {
		case 0:
			cell.filteredArticles = subjectDict[Subject.language.rawValue] ?? []
			return cell
		case 1:
			cell.filteredArticles = subjectDict[Subject.technology.rawValue] ?? []
			return cell
		case 2:
			cell.filteredArticles = subjectDict[Subject.music.rawValue] ?? []
			return cell
		case 3:
			cell.filteredArticles = subjectDict[Subject.sport.rawValue] ?? []
			return cell
		case 4:
			cell.filteredArticles = subjectDict[Subject.art.rawValue] ?? []
			return cell
		default:
			break
		}
		
		return cell
	}
}

// MARK: - UITableViewDelegate

extension ArticleViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 250
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: GeneralTableViewHeader.reuseIdentifier)
				as? GeneralTableViewHeader else { return  UITableViewHeaderFooterView() }
		header.delegate = self
		switch section {
		case 0:
			header.titleLabel.text = Subject.language.rawValue
			return header
		case 1:
			header.titleLabel.text = Subject.technology.rawValue
			return header
		case 2:
			header.titleLabel.text = Subject.music.rawValue
			return header
		case 3:
			header.titleLabel.text = Subject.sport.rawValue
			return header
		case 4:
			header.titleLabel.text = Subject.art.rawValue
			return header
		default:
			break
		}
		
		return header
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		50
	}
}

// MARK: - ArticlePageTableViewCellDelegate

extension ArticleViewController: ArticlePageTableViewCellDelegate {
	func goArticleDetailVC(_ cell: ArticlePageTableViewCell, article: Article) {
		let articleDetailVC = ArticleDetailViewController(article: article)
		navigationController?.pushViewController(articleDetailVC, animated: true)
	}
}

extension ArticleViewController: GeneralTableViewHeaderDelegate {
	func tappedSeeAll(_ cell: GeneralTableViewHeader) {
		switch cell.titleLabel.text {
		case Subject.language.rawValue:
			pushArticleListPage(subject: Subject.language.rawValue)
		case Subject.technology.rawValue:
			pushArticleListPage(subject: Subject.technology.rawValue)
		case Subject.music.rawValue:
			pushArticleListPage(subject: Subject.music.rawValue)
		case Subject.art.rawValue:
			pushArticleListPage(subject: Subject.art.rawValue)
		case Subject.sport.rawValue:
			pushArticleListPage(subject: Subject.sport.rawValue)
		default:
			break
		}
	}
	
	func pushArticleListPage(subject: String) {
		let articles = subjectDict[subject] ?? []
		let articleListVC = ArticleListViewController(articles: articles)
		navigationController?.pushViewController(articleListVC, animated: true)
	}
}
