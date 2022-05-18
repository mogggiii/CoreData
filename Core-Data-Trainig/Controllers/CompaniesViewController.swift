//
//  ViewController.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 11.05.2022.
//

import UIKit

class CompaniesViewController: UIViewController {
	
	fileprivate let companies = [
		Company(name: "2333", founded: Date()),
		Company(name: "4599", founded: Date()),
		Company(name: "4344", founded: Date()),
	]
	
	fileprivate let reuseId = "cell"
	
	private lazy var tableView: UITableView = {
		let tableView = UITableView(frame: view.bounds)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(CompaniesCell.self, forCellReuseIdentifier: reuseId)
		tableView.backgroundColor = .tableViewBackground
		tableView.separatorColor = .white
		tableView.tableFooterView = UIView()
		return tableView
	}()
	
	// MARK: - VC lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(tableView)
		
		navigationItem.title = "Companies"
		
		configureNavBarButtons()
//		self.setupNavigationStyle()
	}
	
	// MARK: - Fileprivate
	/// Configure navigation buttons
	fileprivate func configureNavBarButtons() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
	}
	
	// MARK: - Objc fileprivate
	@objc fileprivate func handleAddCompany() {
		let createCompanyController = CreateCompanyController()
		let navVC = CustomNavigationController(rootViewController: createCompanyController)
		navVC.modalPresentationStyle = .fullScreen
		present(navVC, animated: true)
		print("ADD TAP")
	}
	
	@objc fileprivate func handleReset() {
		print("Reset")
	}
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CompaniesViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return companies.count
	}
	
//	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//		let header = UIView()
//		header.backgroundColor = .yellow
//		return header
//	}
//
//	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//		return 50
//	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? CompaniesCell else {
			return UITableViewCell()
		}
		
		let company = companies[indexPath.row]
		cell.company = company
		return cell
	}
	
}
