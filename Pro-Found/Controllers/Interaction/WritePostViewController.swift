//
//  WritePostViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/17.
//

import UIKit

class WritePostViewController: UIViewController {
	
	// MARK: - Properties
	
	let user: User
	
	private let topBarView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		
		let titleLabel = UILabel()
		titleLabel.text = "Write Post"
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
	
	private let profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .gray
		imageView.setDimensions(width: 42, height: 42)
		imageView.layer.cornerRadius = 42 / 2
		return imageView
	}()
	
	private let postTextView = CaptionTextView()
	
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
		
		view.addSubview(profileImageView)
		profileImageView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 16)
		
		view.addSubview(postTextView)
		postTextView.anchor(top: topBarView.bottomAnchor, left: profileImageView.rightAnchor, right: view.rightAnchor,
							paddingTop: 12, paddingLeft: 12, paddingRight: 16)
		postTextView.heightAnchor.constraint(equalToConstant: 300).isActive = true
		
		view.addSubview(bottomBarView)
		bottomBarView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, height: 64)
		
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
		guard let postText = postTextView.text else { return }
		let date = Date()
		let timestamp = date.timeIntervalSince1970
		let firebasepost = FirebasePosts(userID: user.userID, contentText: postText, likes: 0, timestamp: timestamp)
		PostService.shared.uploadPost(firebasePost: firebasepost) { [weak self] in
			guard let self = self else { return }
			self.dismiss(animated: true)
		}
	}
	
	@objc func dismissVC() {
		dismiss(animated: true)
	}
}
