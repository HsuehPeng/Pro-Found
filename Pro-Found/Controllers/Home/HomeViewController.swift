//
//  HomeViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/13.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {

	// MARK: - Properties
	
	var user: User? {
		didSet {
			configure()
		}
	}
	
	var tutors: [User]? {
		didSet {
			tableView.reloadData()
		}
	}
	
	private let topBarView: UIView = {
		let view = UIView()
		return view
	}()
	
	private let profilePhotoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .gray
		imageView.setDimensions(width: 36, height: 36)
		imageView.layer.cornerRadius = 36 / 2
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private let greetingLabel: UILabel = {
		
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.manropeRegular, size: 12),
											   textColor: UIColor.dark40, text: "Welcome back,")
		return label
	}()
	
	private let nameLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 14),
											   textColor: UIColor.dark, text: "")
		return label
	}()
	
	private lazy var messageButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.asset(.chat)?.withRenderingMode(.alwaysOriginal), for: .normal)
		return button
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(HomePageTutorListTableViewCell.self, forCellReuseIdentifier: HomePageTutorListTableViewCell.reuseidentifier)
		tableView.register(GeneralTableViewHeader.self, forHeaderFooterViewReuseIdentifier: GeneralTableViewHeader.reuseIdentifier)
		tableView.separatorStyle = .none
		
		return tableView
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		tableView.dataSource = self
		tableView.delegate = self
		
		setupUI()
		setupNavBar()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		fetchTutors()
	}
	
	// MARK: - UI
	
	func setupUI() {
		view.addSubview(topBarView)
		topBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 64)
		
		topBarView.addSubview(profilePhotoImageView)
		profilePhotoImageView.centerY(inView: topBarView, leftAnchor: topBarView.leftAnchor, paddingLeft: 16)
		
		let topBarLabelVStack = UIStackView(arrangedSubviews: [greetingLabel, nameLabel])
		topBarLabelVStack.spacing = 0
		topBarLabelVStack.axis = .vertical
		topBarView.addSubview(topBarLabelVStack)
		topBarLabelVStack.centerY(inView: topBarView, leftAnchor: profilePhotoImageView.rightAnchor, paddingLeft: 12)
		
		topBarView.addSubview(messageButton)
		messageButton.centerY(inView: topBarView)
		messageButton.anchor(right: topBarView.rightAnchor, paddingRight: 24)
		
		view.addSubview(tableView)
		tableView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
	}
	
	func setupNavBar() {
		navigationController?.navigationBar.isHidden = true
	}
	
	// MARK: - Actions
	
	// MARK: - Helpers
	
	func fetchTutors() {
		UserServie.shared.getTutors { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let tutors):
				self.tutors = tutors
			case .failure(let error):
				print("Error getting tutors: \(error)")
			}
		}
	}
	
	func configure() {
		guard let user = user else { return }
		let imageUrl = URL(string: user.profileImageURL)
		nameLabel.text = user.name
		profilePhotoImageView.kf.setImage(with: imageUrl)
	}
	
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: HomePageTutorListTableViewCell.reuseidentifier, for: indexPath)
				as? HomePageTutorListTableViewCell else { return UITableViewCell() }
		cell.delegate = self
		cell.tutors = tutors
		return cell
	}

}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 216
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: GeneralTableViewHeader.reuseIdentifier)
				as? GeneralTableViewHeader else { return  UITableViewHeaderFooterView() }
		if section == 0 {
			header.titleLabel.text = "Explore Tutors..."
			header.seeAllButton.setTitle("Subject", for: .normal)
			return header
		}
		return header
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		50
	}
}

// MARK: - HomePageTutorListTableViewCellDelegate

extension HomeViewController: HomePageTutorListTableViewCellDelegate {
	func goToTutorProfile(_ cell: HomePageTutorListTableViewCell, tutor: User) {
		guard let user = user else { return }
		let tutorProfileVC = TutorProfileViewController(user: user, tutor: tutor)
		navigationController?.pushViewController(tutorProfileVC, animated: true)
	}

}
