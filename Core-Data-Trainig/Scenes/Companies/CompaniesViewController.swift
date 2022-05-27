//
//  ViewController.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 11.05.2022.
//

import UIKit
import CoreData

class CompaniesViewController: UIViewController {
	
	var companies = [Company]()
	let reuseId = "cell"
	
	lazy var tableView: UITableView = {
		let tableView = UITableView(frame: view.bounds)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(CompaniesCell.self, forCellReuseIdentifier: reuseId)
		tableView.backgroundColor = .darkBlue
		tableView.separatorColor = .white
		tableView.tableFooterView = UIView()
		return tableView
	}()
	
	// MARK: - VC lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Companies"
		view.addSubview(tableView)
		
		self.companies = CoreDataManager.shared.fetchCompanies()
		configureNavBarButtons()
	}
	
	// MARK: - Fileprivate
	/// Configure navigation buttons
	fileprivate func configureNavBarButtons() {
		setupPlusButtonInNavBar(#selector(handleAddCompany))
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
	}
	
	// MARK: - Objc fileprivate
	
	/// Add button:
	/// - Open CreateCompanyController
	/// - Use the delegate
	@objc fileprivate func handleAddCompany() {
		let createCompanyController = CreateCompanyController()
		let navVC = CustomNavigationController(rootViewController: createCompanyController)
		navVC.modalPresentationStyle = .fullScreen
		
		createCompanyController.delegate = self
		present(navVC, animated: true)
	}
	
	/// Reset button:
	/// Delete all object from Core Data
	@objc fileprivate func handleReset() {
		let indexPathToRemove = CoreDataManager.shared.deleteCompanies(companies: self.companies)
		companies.removeAll()
		self.tableView.deleteRows(at: indexPathToRemove, with: .left)
	}
}
