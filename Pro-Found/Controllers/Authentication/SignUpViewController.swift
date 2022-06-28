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
	
	private let signUpLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 24),
												 textColor: .dark, text: "Sign Up")
		return label
	}()
	
	private let askToSignUpLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 14),
												 textColor: .dark40, text: "Let's start the wonderful journey!")
		return label
	}()
	
	private let nameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: .dark, text: "Name")
		return label
	}()
	
	private lazy var nameTextField: UITextField = {
		let textField = UITextField()
		textField.autocapitalizationType = .none
		textField.font = UIFont.customFont(.manropeRegular, size: 14)
		textField.placeholder = "Input your name"
		return textField
	}()
	
	private let nameDividerView: UIView = {
		let view = UIView()
		view.backgroundColor = .dark30
		return view
	}()
	
	private let emailLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
												 textColor: .dark, text: "Email")
		return label
	}()
	
	private lazy var emailTextField: UITextField = {
		let textField = UITextField()
		textField.autocapitalizationType = .none
		textField.font = UIFont.customFont(.manropeRegular, size: 14)
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
		textField.font = UIFont.customFont(.manropeRegular, size: 14)
		textField.autocapitalizationType = .none
		textField.placeholder = "Input password"
		textField.isSecureTextEntry = true
		return textField
	}()
	
	private let passwordDividerView: UIView = {
		let view = UIView()
		view.backgroundColor = .dark30
		return view
	}()
	
	private lazy var signUpButton: UIButton = {
		let button = CustomUIElements().makeLargeButton(buttonColor: .orange, buttonTextColor: .white,
														borderColor: .clear, buttonText: "Sign Up")
		button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
		return button
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Sign up"
		view.backgroundColor = .white
		passwordTextField.delegate = self
		setupNavBar()
		setupUI()
	}
	
	// MARK: - UI
	
	func setupNavBar() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.asset(.chevron_left)?.withRenderingMode(.alwaysOriginal),
														   style: .done, target: self, action: #selector(dismissVC))
	}
	
	func setupUI() {
		
		view.addSubview(appImageView)
		appImageView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 168, paddingLeft: 16)
		
		view.addSubview(appLabel)
		appLabel.centerY(inView: appImageView, leftAnchor: appImageView.rightAnchor, paddingLeft: 16)
		
		view.addSubview(signUpLabel)
		signUpLabel.anchor(top: appImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							paddingTop: 40, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(askToSignUpLabel)
		askToSignUpLabel.anchor(top: signUpLabel.bottomAnchor, left: view.leftAnchor,
							   right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(nameLabel)
		nameLabel.anchor(top: askToSignUpLabel.bottomAnchor, left: view.leftAnchor,
						  right: view.rightAnchor, paddingTop: 44, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(nameTextField)
		nameTextField.anchor(top: nameLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							  paddingTop: 4, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(nameDividerView)
		nameDividerView.anchor(top: nameTextField.bottomAnchor, left: view.leftAnchor,
								right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 1)
		
		view.addSubview(emailLabel)
		emailLabel.anchor(top: nameDividerView.bottomAnchor, left: view.leftAnchor,
						  right: view.rightAnchor, paddingTop: 26, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(emailTextField)
		emailTextField.anchor(top: emailLabel.bottomAnchor, left: view.leftAnchor,
								 right: view.rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(emailDividerView)
		emailDividerView.anchor(top: emailTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
								paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 1)
		
		view.addSubview(passwordLabel)
		passwordLabel.anchor(top: emailDividerView.bottomAnchor, left: view.leftAnchor,
						  right: view.rightAnchor, paddingTop: 26, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(passwordTextField)
		passwordTextField.anchor(top: passwordLabel.bottomAnchor, left: view.leftAnchor,
								 right: view.rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 16)
		
		view.addSubview(passwordDividerView)
		passwordDividerView.anchor(top: passwordTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
								   paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 1)
		
		view.addSubview(signUpButton)
		signUpButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
							paddingLeft: 25, paddingBottom: 50, paddingRight: 25)
	}
	
	// MARK: - Selectors
	
	@objc func dismissVC() {
		navigationController?.popViewController(animated: true)
	}
	
	@objc func handleSignup() {
		guard let email = emailTextField.text, !email.isEmpty,
			  let password = passwordTextField.text, !password.isEmpty,
			  let name = nameTextField.text, !name.isEmpty else {
				  
			let missingInputVC = MissingInputViewController()
			missingInputVC.modalTransitionStyle = .crossDissolve
			missingInputVC.modalPresentationStyle = .overCurrentContext
			present(missingInputVC, animated: true)
			return
		}
		
		Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
			guard let self = self else { return }
			if let error = error {
				print("Error signing in: \(error)")
			}
			
			guard let uid = authResult?.user.uid else { return }
			let user = User(name: name, userID: uid, email: email, introContentText: "", school: "", schoolMajor: "",
							ratings: [], courseBooked: 0, profileImageURL: "",
							backgroundImageURL: "", courses: [], articles: [], favoriteArticles: [], events: [], posts: [], blockedUsers: [],
							followers: [], followings: [], subject: "", isTutor: false)
			
			UserServie.shared.uploadUserData(user: user) { [weak self] in
				guard let self = self else { return }
				let initialEditVC = InitialEditProfileVC(user: user)
				self.navigationController?.pushViewController(initialEditVC, animated: true)
			}
		}
	}

	// MARK: - Helpers

}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let currentText = textField.text ?? ""
		guard let stringRange = Range(range, in: currentText) else { return false }

		let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

		return updatedText.count <= 20
	}
}
