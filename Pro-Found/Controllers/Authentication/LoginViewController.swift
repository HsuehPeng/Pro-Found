//
//  LoginViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/16.
//

import UIKit
import FirebaseAuth
import AuthenticationServices
import CryptoKit
import Lottie

class LoginViewController: UIViewController {

	// MARK: - Properties
	
	private let appImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage.asset(.myIcon)
		imageView.setDimensions(width: 60, height: 60)
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

	private lazy var loginButton: UIButton = {
		let button = CustomUIElements().makeLargeButton(buttonColor: .orange, buttonTextColor: .light60,
														borderColor: .clear, buttonText: "Log In")
		button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
		return button
	}()
	
	private lazy var eulaButton: UIButton = {
		let button = UIButton()
		
		let attributedTitle = NSMutableAttributedString(string: "EULA", attributes: [
			NSAttributedString.Key.font: UIFont.customFont(.interSemiBold, size: 16),
			NSAttributedString.Key.foregroundColor: UIColor.dark
		])
		
		button.setAttributedTitle(attributedTitle, for: .normal)
		button.addTarget(self, action: #selector(goEULA), for: .touchUpInside)
		return button
	}()
	
	private lazy var privacyPolicyButton: UIButton = {
		let button = UIButton()
		
		let attributedTitle = NSMutableAttributedString(string: "Privacy Policy", attributes: [
			NSAttributedString.Key.font: UIFont.customFont(.interSemiBold, size: 16),
			NSAttributedString.Key.foregroundColor: UIColor.dark
		])
		
		button.setAttributedTitle(attributedTitle, for: .normal)
		button.addTarget(self, action: #selector(goPrivacyPolicy), for: .touchUpInside)
		return button
	}()
	
	private lazy var appleSignInButton: ASAuthorizationAppleIDButton = {
		let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .whiteOutline)
		button.addTarget(self, action: #selector(handleSignInWithAppleTapped), for: .touchUpInside)
		return button
	}()
	
	private lazy var dontHaveAccountButton: UIButton = {
		let button = UIButton()
		
		let attributedTitle = NSMutableAttributedString(string: "Don't have an account?", attributes: [
			NSAttributedString.Key.font: UIFont.customFont(.manropeRegular, size: 16),
			NSAttributedString.Key.foregroundColor: UIColor.dark40
		])
		
		attributedTitle.append(NSAttributedString(string: " Sign Up", attributes: [
			NSAttributedString.Key.font: UIFont.customFont(.interSemiBold, size: 16),
			NSAttributedString.Key.foregroundColor: UIColor.dark
		]))
		
		button.setAttributedTitle(attributedTitle, for: .normal)
		button.addTarget(self, action: #selector(goSignUp), for: .touchUpInside)
		return button
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Login"
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.asset(.close_circle)?.withRenderingMode(.alwaysOriginal),
															style: .done, target: self, action: #selector(dismissVC))
		view.backgroundColor = .light60
		
		passwordTextField.delegate = self
		
		setupUI()
	}
	
	// MARK: - UI
	
	func setupUI() {
		
		view.addSubview(appImageView)
		
		view.addSubview(appLabel)
		
		view.addSubview(welcomeLabel)
		
		view.addSubview(askToLoginLabel)
		
		view.addSubview(emailLabel)
		
		view.addSubview(emailTextField)
		
		view.addSubview(emailDividerView)
		
		view.addSubview(passwordLabel)
		
		view.addSubview(passwordTextField)
		
		view.addSubview(passwordDividerView)
		
		view.addSubview(appleSignInButton)
		
		view.addSubview(loginButton)
		
		view.addSubview(dontHaveAccountButton)
		
		appImageView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 375 * (120/375), paddingLeft: 16)
		
		appLabel.centerY(inView: appImageView, leftAnchor: appImageView.rightAnchor, paddingLeft: 16)
		
		welcomeLabel.anchor(top: appImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							paddingTop: 40, paddingLeft: 16, paddingRight: 16)
		
		askToLoginLabel.anchor(top: welcomeLabel.bottomAnchor, left: view.leftAnchor,
							   right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
		
		emailLabel.anchor(top: askToLoginLabel.bottomAnchor, left: view.leftAnchor,
						  right: view.rightAnchor, paddingTop: 44, paddingLeft: 16, paddingRight: 16)
		
		emailTextField.anchor(top: emailLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
							  paddingTop: 4, paddingLeft: 16, paddingRight: 16)
		
		emailDividerView.anchor(top: emailTextField.bottomAnchor, left: view.leftAnchor,
								right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 1)
		
		passwordLabel.anchor(top: emailDividerView.bottomAnchor, left: view.leftAnchor,
						  right: view.rightAnchor, paddingTop: 26, paddingLeft: 16, paddingRight: 16)
		
		passwordTextField.anchor(top: passwordLabel.bottomAnchor, left: view.leftAnchor,
								 right: view.rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 16)
		
		passwordDividerView.anchor(top: passwordTextField.bottomAnchor, left: view.leftAnchor,
								right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 1)
		
		appleSignInButton.anchor(top: passwordDividerView.bottomAnchor, left: view.leftAnchor, paddingTop: 32, paddingLeft: 16)
		
		loginButton.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 25, paddingRight: 25)
		
		let policyHStack = UIStackView(arrangedSubviews: [eulaButton, privacyPolicyButton])
		view.addSubview(policyHStack)
		policyHStack.spacing = 12
		policyHStack.centerX(inView: view, topAnchor: loginButton.bottomAnchor, paddingTop: 12)
		
		dontHaveAccountButton.anchor(top: policyHStack.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
									   right: view.rightAnchor, paddingTop: 375 * (1/25), paddingLeft: 40, paddingRight: 40)
	}
	
	// MARK: - Actions
	
	@objc func dismissVC() {
		guard let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene
			
		}).flatMap({ $0.windows }).first(where: { $0.isKeyWindow }) else { return }
		
		guard let tab = window.rootViewController as? MainTabController else { return }
		
		tab.configureViewControllers()
		
		self.dismiss(animated: true, completion: nil)
	}
	
	@objc func handleLogin() {
		guard let email = emailTextField.text, !email.isEmpty,
			  let password = passwordTextField.text, !password.isEmpty else {
				  let missingInputVC = MissingInputViewController()
				  missingInputVC.modalTransitionStyle = .crossDissolve
				  missingInputVC.modalPresentationStyle = .overCurrentContext
				  present(missingInputVC, animated: true)
				  return
			  }
		let loadingLottie = Lottie(superView: view, animationView: AnimationView.init(name: "loadingAnimation"))
		loadingLottie.loadingAnimation()
		
		Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
			guard let self = self else { return }
			if let error = error {
				print("Error signing in: \(error)")
				loadingLottie.stopAnimation()
				self.showAlert(alertText: "Error", alertMessage: "Error signing in")
			}
			
			guard let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene
				
			}).flatMap({ $0.windows }).first(where: { $0.isKeyWindow }) else { return }
			
			loadingLottie.stopAnimation()
			
			guard let tab = window.rootViewController as? MainTabController else { return }
			
			tab.authenticateUserAndConfigureUI()
			
			self.dismiss(animated: true, completion: nil)
		}
	}
	
	@objc func goEULA() {
		let policyViewController = PolicyViewController()
		policyViewController.url = PolicyType.eula.url
		present(policyViewController, animated: true, completion: nil)
	}
	
	@objc func goPrivacyPolicy() {
		let policyViewController = PolicyViewController()
		policyViewController.url = PolicyType.privacyPolicy.url
		present(policyViewController, animated: true, completion: nil)
	}
	
	@objc func goSignUp() {
		let loginVC = SignUpViewController()
		navigationController?.pushViewController(loginVC, animated: true)
	}

	// MARK: - AppleAuth
	
	fileprivate var currentNonce: String?
	
	@objc func handleSignInWithAppleTapped() {
		performSignIn()
	}
	
	func performSignIn() {
		let request = createAppleIDRequest()
		let authorizationController = ASAuthorizationController(authorizationRequests: [request])
		authorizationController.delegate = self
		authorizationController.presentationContextProvider = self
		
		authorizationController.performRequests()
	}
	
	func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
		let appleIDProvider = ASAuthorizationAppleIDProvider()
		let request = appleIDProvider.createRequest()
		request.requestedScopes = [.email, .fullName]
		let nonce = randomNonceString()
		request.nonce = sha256(nonce)
		currentNonce = nonce
		return request
	}
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let currentText = textField.text ?? ""
		guard let stringRange = Range(range, in: currentText) else { return false }

		let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

		return updatedText.count <= 20
	}
}

// MARK: - ASAuthorizationControllerDelegate

extension LoginViewController: ASAuthorizationControllerDelegate {
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
			UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
			guard let nonce = currentNonce else {
				fatalError("Invalide state: A login callback is received, but no login request was sent")
			}
			guard let appleIDToken = appleIDCredential.identityToken else {
				print("Unable to fetch identity token")
				return
			}
			guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
				print("Unable to serialize token string from date: \(appleIDToken.debugDescription)")
				return
			}
			let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
			
			Auth.auth().signIn(with: credential) { (authResult, error) in
				if let error = error {
					print(error.localizedDescription)
					return
				}
				
				guard let uid = authResult?.user.uid else { return }
				
				UserServie.shared.checkIfUserExistOnFirebase(uid: uid) { result in
					switch result {
					case .success(let isExist):
						if isExist {
							guard let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene
								
							}).flatMap({ $0.windows }).first(where: { $0.isKeyWindow }) else { return }
							
							guard let tab = window.rootViewController as? MainTabController else { return }
							
							tab.authenticateUserAndConfigureUI()
							self.dismiss(animated: true, completion: nil)
						} else {
							guard let givenName = appleIDCredential.fullName?.givenName, let familyName = appleIDCredential.fullName?.familyName, let userEmail = appleIDCredential.email else { return }
							let user = User(name: "\(givenName) \(familyName)", userID: uid, email: userEmail, introContentText: "", school: "", schoolMajor: "",
											ratings: [], courseBooked: 0, profileImageURL: "",
											backgroundImageURL: "", courses: [], articles: [], favoriteArticles: [], events: [], posts: [], blockedUsers: [],
											followers: [], followings: [], subject: "Student", isTutor: false)
							
							UserServie.shared.uploadUserData(user: user) { [weak self] in
								guard let self = self else { return }
								let initialEditVC = InitialEditProfileVC(user: user)
								self.navigationController?.pushViewController(initialEditVC, animated: true)
							}
						}
					case .failure(let error):
						print(error)
					}
				}
				
				// Mak a request to set user's display name on Firebase
//				let changeRequest = authResult?.user.createProfileChangeRequest()
//				changeRequest?.displayName = appleIDCredential.fullName?.givenName
//				changeRequest?.commitChanges(completion: { (error) in
//
//					if let error = error {
//						print(error.localizedDescription)
//					} else {
//						print("Updated display name: \(Auth.auth().currentUser!.displayName!)")
//					}
//				})
			}
		}
	}
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		return self.view.window!
	}
}

// MARK: - FirebaseAppleAuthFunction

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: [Character] =
	Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remainingLength = length

  while remainingLength > 0 {
	let randoms: [UInt8] = (0 ..< 16).map { _ in
	  var random: UInt8 = 0
	  let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
	  if errorCode != errSecSuccess {
		fatalError(
		  "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
		)
	  }
	  return random
	}

	randoms.forEach { random in
	  if remainingLength == 0 {
		return
	  }

	  if random < charset.count {
		result.append(charset[Int(random)])
		remainingLength -= 1
	  }
	}
  }

  return result
}

@available(iOS 13, *)
private func sha256(_ input: String) -> String {
  let inputData = Data(input.utf8)
  let hashedData = SHA256.hash(data: inputData)
  let hashString = hashedData.compactMap {
	String(format: "%02x", $0)
  }.joined()

  return hashString
}
