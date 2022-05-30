//
//  EmployeesController.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 27.05.2022.
//

import UIKit
import CoreData

class CustomLabel: UILabel {
	override func drawText(in rect: CGRect) {
		let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
		super.drawText(in: rect.inset(by: insets))
	}
}

class EmployeesController: UITableViewController {
	
	var company: Company?
	var employees = [Employee]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	  setupPlusButtonInNavBar(#selector(handleAddEmployee))
		
		configureTableView()
		fetchEmployees()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationItem.title = company?.name
	}
	
	// MARK: - Fileprivate
	
	fileprivate func configureTableView() {
		tableView.backgroundColor = .darkBlue
		tableView.register(EmployeeCell.self, forCellReuseIdentifier: "cell")
		tableView.sectionHeaderTopPadding = 0
	}
	
	fileprivate func fetchEmployees() {
		guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
//		self.employees = companyEmployees
		
		shorNameEmployees = companyEmployees.filter({ employee in
			if let count = employee.name?.count {
				return count < 6
			}
			return false
		})
		
		longNameEmployees = companyEmployees.filter({ employee in
			if let count = employee.name?.count {
				return count > 6
			}
			
			return false
		})
	}
	
	// MARK: - Objc fileprivate
	
	@objc fileprivate func handleAddEmployee() {
		print("Trying to add employee")
		let createEmployeeController = CreateEmployeeController()
		createEmployeeController.delegate = self
		createEmployeeController.company = company
		
		let navVC = CustomNavigationController(rootViewController: createEmployeeController)
		navVC.modalPresentationStyle = .fullScreen
		
		present(navVC, animated: true)
	}
	
	// MARK: - UITableViewDataSource
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
	var shorNameEmployees = [Employee]()
	var longNameEmployees = [Employee]()
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label = CustomLabel()
		label.text = "HEADER"
		label.textColor = .darkBlue
		label.font = .systemFont(ofSize: 16, weight: .bold)
		label.backgroundColor = .lightBlue
		return label
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return employees.count
		switch section {
		case 0:
			return shorNameEmployees.count
		default:
			return longNameEmployees.count
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EmployeeCell else {
			return UITableViewCell()
		}
		
//		switch indexPath.section {
//		case 0:
//			let employee = shorNameEmployees[indexPath.row]
//			cell.employee = employee
//		}
		
//		let employee = employees[indexPath.row]
		let employee = indexPath.section == 0 ? shorNameEmployees[indexPath.row] : longNameEmployees[indexPath.row]
		cell.employee = employee
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 55
	}
}


extension EmployeesController: CreateEmployeeControllerDelegate {
	func didAddEmployee(_ employee: Employee) {
		employees.append(employee)
		
		let newIndexPath = IndexPath(row: employees.count - 1, section: 0)
		tableView.insertRows(at: [newIndexPath], with: .automatic)
	}
}
