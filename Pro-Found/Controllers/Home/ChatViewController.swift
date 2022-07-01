//
//  ChatRommViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/30.
//

import UIKit

class ChatViewController: UIViewController {

	// MARK: - Properties
	
	var messageArray = ["Hi", "How are you", "123123123123123123123123123123123123123123123123123123123123123123123"]
	
	let user: User
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.register(ChatBubbleTableViewCell.self,
						   forCellReuseIdentifier: ChatBubbleTableViewCell.reuseIdentifier)
		tableView.separatorStyle = .none
		tableView.alwaysBounceVertical = true
		return tableView
	}()
	
	private let bottomBarView: UIView = {
		let view = UIView()
		view.backgroundColor = .light60
		return view
	}()
	
	private let senderImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.setDimensions(width: 32, height: 32)
		imageView.layer.cornerRadius = 32 / 2
		imageView.backgroundColor = .orange10
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private lazy var messageTextView: CaptionTextView = {
		let textView = CaptionTextView()
//		textView.isScrollEnabled = false
		textView.layer.cornerRadius = 12
		return textView
	}()
	
	private lazy var sendMessageButton: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.send)?.withRenderingMode(.alwaysOriginal).withTintColor(.dark40)
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
		button.setDimensions(width: 32, height: 32)
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
		
		tableView.dataSource = self
		tableView.delegate = self
		
		setupNavigationBar()
		setupUI()
		
		title = "客服訊息"
		view.backgroundColor = .white
		
	}
	
	// MARK: - UI
	
	func setupNavigationBar() {
		title = "User Name"
		navigationController?.navigationBar.isHidden = false
		let titleAttribute: [NSAttributedString.Key: Any] = [
			.font: UIFont.customFont(.interBold, size: 16)
		]
		let appearance = UINavigationBarAppearance()
		appearance.titleTextAttributes = titleAttribute
		appearance.configureWithDefaultBackground()
		navigationController?.navigationBar.standardAppearance = appearance
		navigationController?.navigationBar.compactAppearance = appearance
		navigationController?.navigationBar.scrollEdgeAppearance = appearance
		let leftBarButtomItem = UIImage.asset(.chevron_left)?.withRenderingMode(.alwaysOriginal).withTintColor(.dark40)
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftBarButtomItem, style: .done, target: self, action: #selector(dismissVC))
	}
	
	func setupUI() {
		view.addSubview(bottomBarView)
		view.addSubview(tableView)
		
		tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: bottomBarView.topAnchor, right: view.rightAnchor)
		
		bottomBarView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.4).isActive = true
		bottomBarView.anchor(top: tableView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
							 right: view.rightAnchor)
		
		bottomBarView.addSubview(senderImageView)
		senderImageView.anchor(top: bottomBarView.topAnchor, left: bottomBarView.leftAnchor, paddingTop: 14, paddingLeft: 16)
		
		bottomBarView.addSubview(messageTextView)
		messageTextView.anchor(top: bottomBarView.topAnchor, left: senderImageView.rightAnchor,
							   bottom: bottomBarView.bottomAnchor, paddingTop: 14, paddingLeft: 16, paddingBottom: 14)
		
		bottomBarView.addSubview(sendMessageButton)
		sendMessageButton.anchor(top: bottomBarView.topAnchor, left: messageTextView.rightAnchor,
								 right: bottomBarView.rightAnchor, paddingTop: 14, paddingLeft: 8, paddingRight: 16)
	}
	
	// MARK: - Selectors
	
	@objc func dismissVC() {
		navigationController?.popViewController(animated: true)
	}
	
	@objc func sendMessage() {
		guard let text = messageTextView.text else { return }
		messageArray.append(text)
		messageTextView.text = ""
		tableView.reloadData()
	}
	
	// MARK: - Helpers

}


// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messageArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatBubbleTableViewCell.reuseIdentifier, for: indexPath)
				as? ChatBubbleTableViewCell else { fatalError("Can not dequeue ChatRoomTableViewCell") }
		
		return cell
	}
}

// MARK: - UITableViewDelegate

extension ChatViewController: UITableViewDelegate {
	
}
