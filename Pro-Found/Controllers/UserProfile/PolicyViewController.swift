//
//  PolicyViewController.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/7/5.
//

import UIKit
import WebKit

class PolicyViewController: UIViewController {

	var webView: WKWebView!
	var url: String?
	
	override func loadView() {
		setupWebView()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		requestWebView()
	}
	
	func setupWebView() {
		let webConfiguration = WKWebViewConfiguration()
		webView = WKWebView(frame: .zero, configuration: webConfiguration)
		webView.uiDelegate = self
		view = webView
	}
	
	func requestWebView() {
		guard let url = url else { return }
		let myURL = URL(string: url)
		let myRequest = URLRequest(url: myURL!)
		webView.load(myRequest)
	}
}

extension PolicyViewController: WKUIDelegate {
	
}
