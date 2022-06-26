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
	
	private lazy var closeButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.asset(.close_circle)?.withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
		return button
	}()
	
	private let appImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.setDimensions(width: 32, height: 32)
		imageView.layer.cornerRadius = 16
		imageView.backgroundColor = .light50
		return imageView
	}()
	
	private let appLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interSemiBold, size: 16),
												 textColor: .dark60, text: "Pro-Found")
		return label
	}()
	
	private let welcomeLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 24),
												 textColor: .dark, text: "Welcome Back!")
		return label
	}()
	
	private let askToLoginLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14),
												 textColor: .dark40, text: "Login to your account to continue")
		return label
	}()
	
	private let emailLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: .dark, text: "Email")
		return label
	}()
	
	private lazy var emailTextField: UITextField = {
		let textField = UITextField()
		textField.autocapitalizationType = .none
		textField.placeholder = "Input email"
		return textField
	}()
	
	private let emailDividerView: UIView = {
		let view = UIView()
		view.backgroundColor = .dark30
		return view
	}()
	
	private let passwordLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: .dark, text: "Password")
		return label
	}()
	
	private lazy var passwordTextField: UITextField = {
		let textField = UITextField()
		textField.autocapitalizationType = .none
		textField.placeholder = "Input password"
		return textField
	}()
	
	private let passwordDividerView: UIView = {
		let view = UIView()
		view.backgroundColor = .dark30
		return view
	}()

	private lazy var loginButton: UIButton = {
		let button = CustomUIElements().makeLargeButton(buttonColor: .orange, buttonTextColor: .white,
														borderColor: .clear, buttonText: "Log In")
		button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
		return button
	}()
	
	private lazy var dontHaveAccountButton: UIButton = {
		let button = UIButton()
		
		let attributedTitle = NSMutableAttributedString(string: "Don't have an account?", attributes: [
			NSAttributedString.Key.font: UIFont.customFont(.manropeRegular, size: 16),
			NSAttributedString.Key.foregroundColor: UIColor.white
		])
		
		attributedTitle.append(NSAttributedString(string: " Sign Up", attributes: [
			NSAttributedString.Key.font: UIFont.customFont(.interSemiBold, size: 16),
			NSAttributedString.Key.foregroundColor: UIColor.white
		]))
		
		button.setAttributedTitle(attributedTitle, for: .normal)
		button.addTarget(self, action: #selector(goSignUp), for: .touchUpInside)
		return button
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Login"
		view.backgroundColor = .white
		setupUI()
	}
	
	// MARK: - UI
	
	func setupUI() {
		
		view.addSubview(closeButton)
		closeButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 16, paddingRight: 16)
		
		view.addSubview(appImageView)
		appImageView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 168, paddingLeft: 16)
		
		view.addSubview(appLabel)
		appLabel.centerY(inView: appImageView, leftAnchor: appImageView.rightAnchor, paddingLeft: 16)
		
		view.addSubview(welcomeLabel)
		welcomeLabel.anchor(top: appImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							paddingTop: 40, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(askToLoginLabel)
		askToLoginLabel.anchor(top: welcomeLabel.bottomAnchor, left: view.leftAnchor,
							   right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(emailLabel)
		emailLabel.anchor(top: askToLoginLabel.bottomAnchor, left: view.leftAnchor,
						  right: view.rightAnchor, paddingTop: 44, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(emailTextField)
		emailTextField.anchor(top: emailLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							  paddingTop: 4, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(emailDividerView)
		emailDividerView.anchor(top: emailTextField.bottomAnchor, left: view.leftAnchor,
								right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 1)
		
		view.addSubview(passwordLabel)
		passwordLabel.anchor(top: emailDividerView.bottomAnchor, left: view.leftAnchor,
						  right: view.rightAnchor, paddingTop: 26, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(passwordTextField)
		passwordTextField.anchor(top: passwordLabel.bottomAnchor, left: view.leftAnchor,
								 right: view.rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(passwordDividerView)
		passwordDividerView.anchor(top: passwordTextField.bottomAnchor, left: view.leftAnchor,
								right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 1)
		
		view.addSubview(loginButton)
		loginButton.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 25, paddingRight: 25)
		
		view.addSubview(dontHaveAccountButton)
		(dontHaveAccountButton).anchor(top: loginButton.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
									   right: view.rightAnchor, paddingTop: 50, paddingLeft: 40, paddingRight: 40)
	}
	
	// MARK: - Actions
	
	@objc func dismissVC() {
		dismiss(animated: true)
	}
	
	@objc func handleLogin() {
		guard let email = emailTextField.text, let password = passwordTextField.text else { return }
		Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
			
			guard let self = self else { return }
			if let error = error {
				print("Error signing in: \(error)")
			}
			
			guard let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene
				
			}).flatMap({ $0.windows }).first(where: { $0.isKeyWindow }) else { return }
			
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
