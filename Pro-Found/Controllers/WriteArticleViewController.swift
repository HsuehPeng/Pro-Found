//
//  WriteArticleViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/18.
//

import UIKit

class WriteArticleViewController: UIViewController {
	
	// MARK: - Properties
	
	let user: User

	private let topBarView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		
		let titleLabel = UILabel()
		titleLabel.text = "Write Article"
		titleLabel.font = UIFont.customFont(.interBold, size: 16)
		titleLabel.textColor = .dark
		view.addSubview(titleLabel)
		titleLabel.center(inView: view)
		
		return view
	}()
	
	private lazy var cancelButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.asset(.close), for: .normal)
		button.setDimensions(width: 24, height: 24)
		button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
		return button
	}()
	
	private let articleImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .gray
		imageView.layer.cornerRadius = 10
		imageView.setDimensions(width: 132, height: 200)
		return imageView
	}()
	
	private let articleTitleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: UIColor.dark, text: "Article Title")
		return label
	}()
	
	private let articleTitleTextField: UITextField = {
		let textField = UITextField()
		return textField
	}()
	
	private let articleTitleDividerView: UIView = {
		let dividerView = UIView()
		dividerView.backgroundColor = .dark20
		dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		return dividerView
	}()
	
	private let articleTextView = ArticleTextView()
	
	private let bottomBarView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		
		let dividerView = UIView()
		dividerView.backgroundColor = .dark20
		view.addSubview(dividerView)
		dividerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 1)
		
		return view
	}()
	
	private lazy var pickImageButton: UIButton = {
		let button = UIButton()
		button.setDimensions(width: 24, height: 24)
		button.setImage(UIImage.asset(.photo), for: .normal)
		return button
	}()
	
	private lazy var postButton: UIButton = {
		let button = CustomUIElements().makeMediumButton(buttonColor: .orange, buttonTextColor: .white, borderColor: .clear, buttonText: "Post")
		button.widthAnchor.constraint(equalToConstant: 90).isActive = true
		button.addTarget(self, action: #selector(sendOutArticle), for: .touchUpInside)
		
		return button
	}()
	
	// MARK: - Lifecycle
	
	init(user: User) {
		self.user = user
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		setupUI()
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(topBarView)
		topBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 48)
		
		topBarView.addSubview(cancelButton)
		cancelButton.centerY(inView: topBarView, leftAnchor: topBarView.leftAnchor, paddingLeft: 18)
		
		view.addSubview(articleImageView)
		articleImageView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
		
		view.addSubview(articleTitleLabel)
		articleTitleLabel.anchor(top: topBarView.bottomAnchor, left: articleImageView.rightAnchor,
									right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(articleTitleTextField)
		articleTitleTextField.anchor(top: articleTitleLabel.bottomAnchor, left: articleImageView.rightAnchor,
									right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(articleTitleDividerView)
		articleTitleDividerView.anchor(top: articleTitleTextField.bottomAnchor, left: articleImageView.rightAnchor, right: view.rightAnchor,
									  paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(articleTextView)
		articleTextView.anchor(top: articleImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							   paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
		
		view.addSubview(bottomBarView)
		bottomBarView.anchor(top: articleTextView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
							 right: view.rightAnchor,paddingTop: 16, height: 64)
		
		let actionButtonHStack = UIStackView(arrangedSubviews: [
			pickImageButton
		])
		actionButtonHStack.axis = .horizontal
		actionButtonHStack.spacing = 24
		bottomBarView.addSubview(actionButtonHStack)
		actionButtonHStack.centerY(inView: bottomBarView, leftAnchor: bottomBarView.leftAnchor, paddingLeft: 16)
		
		bottomBarView.addSubview(postButton)
		postButton.centerY(inView: bottomBarView)
		postButton.rightAnchor.constraint(equalTo: bottomBarView.rightAnchor, constant: -16).isActive = true
	}
	
	// MARK: - Actions
	
	@objc func sendOutArticle() {

	}
	
	@objc func dismissVC() {
		dismiss(animated: true)
	}
	
	// MARK: - Helpers
}
