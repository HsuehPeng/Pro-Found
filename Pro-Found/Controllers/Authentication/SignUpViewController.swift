//
//  SignUpViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/17.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

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
	
	private lazy var nameTextField: UITextField = {
		let textField = UITextField()
		textField.borderStyle = .roundedRect
		textField.autocapitalizationType = .none
		textField.placeholder = "Name"
		return textField
	}()

	private lazy var signUpButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Sign up", for: .normal)
		button.setTitleColor(UIColor.orange, for: .normal)
		button.backgroundColor = .white
		button.heightAnchor.constraint(equalToConstant: 50).isActive = true
		button.layer.cornerRadius = 5
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
		return button
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Sign up"
		view.backgroundColor = .orange
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
		
		view.addSubview(nameTextField)
		nameTextField.anchor(top: passwordTextField.topAnchor, left: view.leftAnchor,
								 right: view.rightAnchor, paddingTop: 50, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(signUpButton)
		signUpButton.anchor(top: nameTextField.topAnchor, left: view.leftAnchor,
								 right: view.rightAnchor, paddingTop: 50, paddingLeft: 16, paddingRight: 16)
	}
	
	// MARK: - Selectors
	
	@objc func handleSignup() {
		guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else { return }
		
		Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
			guard let self = self else { return }
			if let error = error {
				print("Error signing in: \(error)")
			}
			
			guard let uid = authResult?.user.uid else { return }
			let firebaseUser = FirebaseUser(name: name, userID: uid, email: email, isTutor: false)
			
			UserServie.shared.uploadUserData(firebaseUser: firebaseUser) { [weak self] in
				guard let self = self else { return }
				guard let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).flatMap({ $0.windows }).first(where: { $0.isKeyWindow }) else { return }
				
				guard let tab = window.rootViewController as? MainTabController else { return }
				
				tab.authenticateUserAndConfigureUI()
				self.dismiss(animated: true, completion: nil)
			}
		}
	}

	// MARK: - Helpers

}
