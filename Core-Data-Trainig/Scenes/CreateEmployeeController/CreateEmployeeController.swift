//
//  CreateEmployeeController.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 27.05.2022.
//

import UIKit

class CreateEmployeeController: UIViewController {
	
	// MARK: - UI Components
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Create Employee"
		
		view?.backgroundColor = .darkBlue
		
		setupNavigationButtons()
	}
	
	// MARK: - Fileprivate
	
	fileprivate func setupNavigationButtons() {
		setupCancelButtonInNavBar()
		setupSaveButtonInNavBar(#selector(handleSave))
	}
	
	// MARK: - Objc Fileprivate

	@objc fileprivate func handleSave() {
		print("Save")
	}
}
