//
//  LoginViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/16.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

	// MARK: - Properties
	
	private lazy var emailTextField: UITextField = {
		let textField = UITextField()
		textField.borderStyle = .roundedRect
		textField.autocapitalizationType = .none
		textField.placeholder = "email"
		return textField
	}()
	
	private lazy var passwordTextField: UITextField = {
		let textField = UITextField()
		textField.borderStyle = .roundedRect
		textField.autocapitalizationType = .none
		textField.placeholder = "password"
		return textField
	}()

	private lazy var loginButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Log In", for: .normal)
		button.setTitleColor(UIColor.orange, for: .normal)
		button.backgroundColor = .white
		button.heightAnchor.constraint(equalToConstant: 50).isActive = true
		button.layer.cornerRadius = 5
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
		return button
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		setupUI()
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(emailTextField)
		emailTextField.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
							  paddingTop: 100, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(passwordTextField)
		passwordTextField.anchor(top: emailTextField.topAnchor, left: view.leftAnchor,
								 right: view.rightAnchor, paddingTop: 50, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(loginButton)
		loginButton.anchor(top: passwordTextField.topAnchor, left: view.leftAnchor,
								 right: view.rightAnchor, paddingTop: 50, paddingLeft: 16, paddingRight: 16)
	}
	
	// MARK: - Selectors
	
	@objc func handleLogin() {
		guard let email = emailTextField.text, let password = passwordTextField.text else { return }
		Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
			
			guard let self = self else { return }
			if let error = error {
				print("Error signing in: \(error)")
			}

			self.navigationController?.dismiss(animated: true)
		}
	}

	// MARK: - Helpers

}
