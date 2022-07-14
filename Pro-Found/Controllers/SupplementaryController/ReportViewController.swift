//
//  ReportViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/7/14.
//

import UIKit

class ReportViewController: UIViewController {
	
	enum ReportType: CaseIterable {
		case nudity
		case violence
		case harassment
		case suicide
		case falseInfo
		case spam
		case hateSpeech
		case terrorism
		case somethingElse
		
		var description: String {
			switch self {
			case .nudity:
				return "Nudity"
			case .violence:
				return "Violence"
			case .harassment:
				return "Harassment"
			case .suicide:
				return "Suicide or self-injury"
			case .falseInfo:
				return "False information"
			case .spam:
				return "Spam"
			case .hateSpeech:
				return "Hate speech"
			case .terrorism:
				return "Terrorism"
			case .somethingElse:
				return "Something else"
			}
		}
	}
	
	let contentID: String
	
	let contentType: ContentTyep
	
	var report: Report? {
		didSet {
			doneButton.isEnabled = true
			doneButton.backgroundColor = .orange
		}
	}
	
	// MARK: - Properties
	
	private let topBarView: UIView = {
		let view = UIView()
		view.backgroundColor = .light60
		return view
	}()
	
	private let titleLabel: UILabel = {
		let label = CustomUIElements().makeLabel(font: UIFont.customFont(.interBold, size: 16),
												 textColor: .dark, text: "Report")
		return label
	}()
	
	private lazy var cancelButton: UIButton = {
		let button = UIButton()
		let image = UIImage.asset(.close)?.withRenderingMode(.alwaysOriginal).withTintColor(.dark40)
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
		return button
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .light60
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		return tableView
	}()
	
	private lazy var doneButton: UIButton = {
		let button = CustomUIElements().makeLargeButton(buttonColor: .orange, buttonTextColor: .light60,
														borderColor: .clear, buttonText: "Done")
		button.addTarget(self, action: #selector(handleSendReport), for: .touchUpInside)
		button.isEnabled = false
		button.backgroundColor = .lightGray
		return button
	}()
	
	// MARK: - Lifecycle
	
	init(contentID: String, contentType: ContentTyep) {
		self.contentID = contentID
		self.contentType = contentType
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .light60
		
		tableView.delegate = self
		tableView.dataSource = self
		
		setupUI()
    }
	
	// MARK: - UI
	
	func setupUI() {
		
		view.addSubview(topBarView)
		topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 48)
		
		topBarView.addSubview(titleLabel)
		titleLabel.center(inView: topBarView)
		
		topBarView.addSubview(cancelButton)
		cancelButton.centerY(inView: topBarView, leftAnchor: topBarView.leftAnchor, paddingLeft: 16)
		
		view.addSubview(tableView)
		tableView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor,
						 right: view.rightAnchor, height: view.frame.size.height * 0.6)
		
		view.addSubview(doneButton)
		doneButton.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.4).isActive = true
		doneButton.centerX(inView: view, topAnchor: tableView.bottomAnchor, paddingTop: 24)
	}
	
	func setupNavigationBar() {

	}
	
	// MARK: - Actions
	
	@objc func dismissVC() {
		dismiss(animated: true)
	}
	
	@objc func handleSendReport() {
		guard let _ = report else { return }
//		ReportService.shared.uploadReport(contentID: contentID, report: report, contentTyep: contentType) { error in
//			print("\(error)")
//		}
		showAlertWithCompletion(alertText: "Thanks for reporting the content",
								alertMessage: "We take every report seriously and we will closely review this content as soon as possible.") {
			self.dismiss(animated: true)
		}
	}

}

// MARK: - UITableViewDataSource

extension ReportViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ReportType.allCases.count
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		
		var content = cell.defaultContentConfiguration()
		content.text = ReportType.allCases[indexPath.row].description
		content.textProperties.font = UIFont.customFont(.manropeRegular, size: 16)
		content.textProperties.color = .dark
		cell.contentConfiguration = content
		
		return cell
	}
}

// MARK: - UITableViewDelegate

extension ReportViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let reportType = ReportType.allCases[indexPath.row].description
		let report = Report(reportType: reportType)
		self.report = report
	}
}
