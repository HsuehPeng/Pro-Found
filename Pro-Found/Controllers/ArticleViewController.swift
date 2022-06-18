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
	
	var user: User?
	
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
	
	private lazy var writePostButton: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.edit)?.withTintColor(UIColor.orange)
		button.setImage(image, for: .normal)
		button.setDimensions(width: 54, height: 54)
		button.layer.cornerRadius = 54 / 2
		button.backgroundColor = .white
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
		view.backgroundColor = .white
		
		tableView.dataSource = self
		tableView.delegate = self
		
		setupUI()
		setupNavBar()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		loadUserData()
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
		
		view.addSubview(writePostButton)
		writePostButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 24, paddingRight: 16)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = true
	}
	
	// MARK: - Actions
	
	@objc func handleWriteArticle() {
		guard let user = user else { return }
		let writeArticleVC = WriteArticleViewController(user: user)
		writeArticleVC.modalPresentationStyle = .fullScreen
		present(writeArticleVC, animated: true)
	}
	
	// MARK: - Helpers
	
	func loadUserData() {
		guard let uid = Auth.auth().currentUser?.uid  else { return }
		UserServie.shared.getUserData(uid: uid) { result in
			switch result {
			case .success(let user):
				self.user = user
			case .failure(let error):
				print(error)
			}
		}
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
		return cell
	}
}

// MARK: - UITableViewDelegate

extension ArticleViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 236
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: GeneralTableViewHeader.reuseIdentifier)
				as? GeneralTableViewHeader else { return  UITableViewHeaderFooterView() }
		return header
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		50
	}
}
