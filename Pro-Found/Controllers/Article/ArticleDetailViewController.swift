//
//  ArticleDetailViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/18.
//

import UIKit
import FirebaseAuth
import Lottie

class ArticleDetailViewController: UIViewController {
	
	// MARK: - Properties
	
	let article: Article
	
	var isBookMarked: Bool = false
	
	var articleImage: UIImage?
	
	private let topBarView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		return view
	}()
	
	private lazy var backButton: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.chevron_left)?.withTintColor(.dark40)
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(popVC), for: .touchUpInside)
		return button
	}()
	
	private lazy var shareButton: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.share)?.withTintColor(.dark40)
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(sharePDFArticle), for: .touchUpInside)
		return button
	}()
	
	private lazy var bookmarkButton: UIButton = {
		let button = UIButton()
		button.setTitleColor((UIColor.orange), for: .selected)
		let isBookMarkedimage = UIImage.asset(.bookmark)?.withTintColor(.orange)
		let notBookMarkedimage = UIImage.asset(.bookmark)?.withTintColor(.dark40)
		button.setImage(isBookMarkedimage, for: .selected)
		button.setImage(notBookMarkedimage, for: .normal)
		button.addTarget(self, action: #selector(bookmarkArticle), for: .touchUpInside)
		return button
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(ArticleDetailIntroTableViewCell.self, forCellReuseIdentifier: ArticleDetailIntroTableViewCell.reuseIdentifier)
		tableView.register(ArticleDetailContentTableViewCell.self, forCellReuseIdentifier: ArticleDetailContentTableViewCell.reuseIdentifier)
		tableView.separatorStyle = .none
		tableView.allowsSelection = false
		return tableView
	}()
	
	// MARK: - Lifecycle
	
	init(article: Article) {
		self.article = article
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		
		tableView.dataSource = self
		checkIfBookMarded()
		setupNavBar()
		setupUI()
		fetchArticleImage()
    }
	
	// MARK: - UI
	
	func setupUI() {
		
		view.addSubview(topBarView)
		topBarView.anchor(top:view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 48)
		
		topBarView.addSubview(backButton)
		backButton.centerY(inView: topBarView, leftAnchor: topBarView.leftAnchor, paddingLeft: 18)
		
		topBarView.addSubview(bookmarkButton)
		bookmarkButton.anchor(right: topBarView.rightAnchor, paddingRight: 18)
		bookmarkButton.centerY(inView: topBarView)
		
		topBarView.addSubview(shareButton)
		shareButton.anchor(right: bookmarkButton.leftAnchor, paddingRight: 16)
		shareButton.centerY(inView: backButton)
		
		view.addSubview(tableView)
		tableView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = true
		tabBarController?.tabBar.isHidden = true
	}
	
	// MARK: - Actions
	
	@objc func sharePDFArticle() {
		guard let articleImage = articleImage else { return }
		let title = article.articleTitle
		let author = article.authorName
		
		let data = Data(article.contentText.utf8)
		
		if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {

			let pdfRenderer = PDFDINA4PrintRenderer(title: title, image: articleImage, authorName: author, attributedBody: attributedString)
			let printFormatter = UISimpleTextPrintFormatter(attributedText: attributedString)
			pdfRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
			let pdfData = pdfRenderer.createFlyer()
			let vc = UIActivityViewController(activityItems: [pdfData], applicationActivities: [])
			present(vc, animated: true, completion: nil)

		}
	}
	
	@objc func bookmarkArticle() {
		guard let uid = Auth.auth().currentUser?.uid else {
			let popUpAskToLoginVC = PopUpAskToLoginController()
			popUpAskToLoginVC.modalTransitionStyle = .crossDissolve
			popUpAskToLoginVC.modalPresentationStyle = .overCurrentContext
			present(popUpAskToLoginVC, animated: true)
			return
		}
		
		let loadingLottie = Lottie(superView: view, animationView: AnimationView.init(name: "loadingAnimation"))
		loadingLottie.loadingAnimation()
		
		if isBookMarked {
			ArticleService.shared.cancelFavoriteArticles(articleID: article.articleID, userID: uid) { [weak self] in
				guard let self = self else { return }
				self.bookmarkButton.isSelected = false
				self.isBookMarked = false
				loadingLottie.stopAnimation()
			}
		} else {
			ArticleService.shared.addFavoriteArticles(articleID: article.articleID, userID: uid) { [weak self] in
				guard let self = self else { return }
				self.bookmarkButton.isSelected = true
				self.isBookMarked = true
				loadingLottie.stopAnimation()
			}
		}
	}
	
	@objc func popVC() {
		navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Helpers
	
	func fetchArticleImage() {
		guard let url = URL(string: article.imageURL) else { return }
		DispatchQueue.global().async {
			if let data = try? Data(contentsOf: url) {
				self.articleImage = UIImage(data: data)
			}
		}
	}
	
	func checkIfBookMarded() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		ArticleService.shared.checkIfBookMarked(articleID: article.articleID, userID: uid) { [weak self] isBookMarked in
			guard let self = self else { return }
			self.isBookMarked = isBookMarked
			if isBookMarked {
				self.bookmarkButton.isSelected = true
			} else {
				self.bookmarkButton.isSelected = false
			}
		}
	}

}

// MARK: - UITableViewDataSource

extension ArticleDetailViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let introCell = tableView.dequeueReusableCell(withIdentifier: ArticleDetailIntroTableViewCell.reuseIdentifier, for: indexPath)
				as? ArticleDetailIntroTableViewCell else { fatalError("Can not dequeue ArticleDetailIntroTableViewCell") }
		guard let contentCell = tableView.dequeueReusableCell(withIdentifier: ArticleDetailContentTableViewCell.reuseIdentifier, for: indexPath)
				as? ArticleDetailContentTableViewCell else { fatalError("Can not dequeue ArticleDetailContentTableViewCell") }
		introCell.article = article
		introCell.delegate = self
		contentCell.article = article
		
		if indexPath.section == 0 {
			return introCell
		} else {
			return contentCell
		}
	}
}

// MARK: - ArticleDetailIntroTableViewCellDelegate

extension ArticleDetailViewController: ArticleDetailIntroTableViewCellDelegate {
	func sharePDF(_ cell: ArticleDetailIntroTableViewCell) {
		
	}
	
	func handleRateArticlePopUp(_ cell: ArticleDetailIntroTableViewCell) {
		
	}
	
	func handleSendRating(_ cell: ArticleDetailIntroTableViewCell) {
		guard Auth.auth().currentUser != nil else {
			let popUpAskToLoginVC = PopUpAskToLoginController()
			popUpAskToLoginVC.modalTransitionStyle = .crossDissolve
			popUpAskToLoginVC.modalPresentationStyle = .overCurrentContext
			present(popUpAskToLoginVC, animated: true)
			return
		}
		return
	}
}
