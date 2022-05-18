//
//  CreateCompanyController.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 18.05.2022.
//

import UIKit

class CreateCompanyController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Create Company"
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
		
		view.backgroundColor = .tableViewBackground
	}
	
	@objc fileprivate func handleCancel() {
		dismiss(animated: true)
	}
}
