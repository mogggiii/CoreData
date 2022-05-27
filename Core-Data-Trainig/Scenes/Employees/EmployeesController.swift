//
//  EmployeesController.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 27.05.2022.
//

import UIKit

class EmployeesController: UITableViewController {
	
	var company: Company?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	  setupPlusButtonInNavBar(#selector(handleAddEmployee))
		
		configureTableView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationItem.title = company?.name
	}
	
	// MARK: - Fileprivate
	
	fileprivate func configureTableView() {
		tableView.backgroundColor = .darkBlue
	}
	
	// MARK: - Objc fileprivate
	
	@objc fileprivate func handleAddEmployee() {
		print("Trying to add employee")
		let createEmployeeController = CreateEmployeeController()
		let navVC = CustomNavigationController(rootViewController: createEmployeeController)
		navVC.modalPresentationStyle = .fullScreen
		
		present(navVC, animated: true)
	}
}
