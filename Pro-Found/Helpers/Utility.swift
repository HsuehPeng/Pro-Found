//
//  Utility.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/7/14.
//

import UIKit

struct Utility {
	
	func createUserContentAlertSheet(viewController: UIViewController) {
		let actionSheet = UIAlertController(title: "", message: "",
											preferredStyle: .actionSheet)
		
		let reportAction = UIAlertAction(title: "Report", style: .default)
		let deleteAction = UIAlertAction(title: "Delete", style: .default)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		actionSheet.addAction(reportAction)
		actionSheet.addAction(deleteAction)
		actionSheet.addAction(cancelAction)
		
		viewController.present(actionSheet, animated: true, completion: nil)
	}
}
