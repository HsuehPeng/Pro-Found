//
//  ChatRommViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/30.
//

import UIKit

class TextFieldWithPadding: UITextField {
	var textPadding = UIEdgeInsets(
		top: 10,
		left: 15,
		bottom: 10,
		right: 20
	)

	override func textRect(forBounds bounds: CGRect) -> CGRect {
		let rect = super.textRect(forBounds: bounds)
		return rect.inset(by: textPadding)
	}

	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		let rect = super.editingRect(forBounds: bounds)
		return rect.inset(by: textPadding)
	}
}

class ChatViewController: UIViewController {

	// MARK: - Properties
	
	var messageArray = ["Hi", "How are you", "123123123123123123123123123123123123123123123123123123123123123123123"]
	
	private let messageView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.register(ChatBubbleTableViewCell.self,
						   forCellReuseIdentifier: ChatBubbleTableViewCell.reuseIdentifier)
		tableView.separatorStyle = .none
		return tableView
	}()
	
	private lazy var messageTextField: TextFieldWithPadding = {
		let textField = TextFieldWithPadding()
		textField.placeholder = "message"
		textField.borderStyle = .none
		textField.clipsToBounds = true
		textField.backgroundColor = .white
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	private lazy var sendMessageButton: UIButton = {
		let button = UIButton()
		let image = UIImage(systemName: "paperplane")?.withRenderingMode(.alwaysOriginal)
		button.setImage(image, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
		return button
		
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		
		setupNavigationBar()
		setupUI()
		
		title = "客服訊息"
		view.backgroundColor = .white
		tabBarController?.tabBar.isHidden = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		tabBarController?.tabBar.isHidden = false
	}
	
	// MARK: - UI
	
	func setupNavigationBar() {
		let leftBarButtomItem = UIImage(systemName: "arrow.left")?.withRenderingMode(.alwaysOriginal)
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftBarButtomItem, style: .done, target: self, action: #selector(dismissVC))
	}
	
	func setupUI() {
		view.addSubview(messageView)
		messageView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, height: 50)
//		NSLayoutConstraint.activate([
//			messageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//			messageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//			messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
//			messageView.heightAnchor.constraint(equalToConstant: 50)
//		])
		
		view.addSubview(tableView)
		tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: messageView.topAnchor, right: view.rightAnchor)
//		NSLayoutConstraint.activate([
//			tableView.leadingAnchor.constraint(equalTo: messageView.leadingAnchor),
//			tableView.trailingAnchor.constraint(equalTo: messageView.trailingAnchor),
//			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//			tableView.bottomAnchor.constraint(equalTo: messageView.topAnchor)
//		])
		
		messageView.addSubview(messageTextField)
		messageTextField.centerY(inView: messageView, leftAnchor: messageView.leftAnchor, paddingLeft: 16)
		messageTextField.anchor(right: messageView.rightAnchor, height: 40)
		messageTextField.layer.cornerRadius = 20
//		NSLayoutConstraint.activate([
//			messageTextField.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 16),
//			messageTextField.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -48),
//			messageTextField.centerYAnchor.constraint(equalTo: messageView.centerYAnchor),
//			messageTextField.heightAnchor.constraint(equalToConstant: 40)
//		])
		
		messageView.addSubview(sendMessageButton)
		sendMessageButton.centerY(inView: messageView, leftAnchor: messageTextField.rightAnchor)
		sendMessageButton.anchor(right: messageView.rightAnchor, paddingRight: 2, height: 40)
//		NSLayoutConstraint.activate([
//			sendMessageButton.leadingAnchor.constraint(equalTo: messageTextField.trailingAnchor),
//			sendMessageButton.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -2),
//			sendMessageButton.centerYAnchor.constraint(equalTo: messageView.centerYAnchor),
//			sendMessageButton.heightAnchor.constraint(equalTo: messageTextField.heightAnchor),
//		])

	}
	
	// MARK: - Selectors
	
	@objc func dismissVC() {
		navigationController?.popViewController(animated: true)
	}
	
	@objc func sendMessage() {
		guard let text = messageTextField.text else { return }
		messageArray.append(text)
		messageTextField.text = ""
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
