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
	
	private lazy var goSignUpButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Sign up", for: .normal)
		button.setTitleColor(UIColor.orange, for: .normal)
		button.backgroundColor = .white
		button.heightAnchor.constraint(equalToConstant: 50).isActive = true
		button.layer.cornerRadius = 5
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(goSignUp), for: .touchUpInside)
		return button
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Login"
		view.backgroundColor = .ocean
		setupUI()
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(emailTextField)
		emailTextField.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
							  paddingTop: 100, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(passwordTextField)
		passwordTextField.anchor(top: emailTextField.bottomAnchor, left: view.leftAnchor,
								 right: view.rightAnchor, paddingTop: 50, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(loginButton)
		loginButton.anchor(top: passwordTextField.bottomAnchor, left: view.leftAnchor,
								 right: view.rightAnchor, paddingTop: 50, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(goSignUpButton)
		(goSignUpButton).anchor(top: loginButton.bottomAnchor, left: view.leftAnchor,
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
			
			guard let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).flatMap({ $0.windows }).first(where: { $0.isKeyWindow }) else { return }
			
			guard let tab = window.rootViewController as? MainTabController else { return }
			
			tab.authenticateUserAndConfigureUI()
			self.dismiss(animated: true, completion: nil)
		}
	}
	
	@objc func goSignUp() {
		let loginVC = SignUpViewController()
		navigationController?.pushViewController(loginVC, animated: true)
	}

	// MARK: - Helpers

}
