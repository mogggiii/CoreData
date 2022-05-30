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
	
	private var allEmployees = [[Employee]]()
	
	private var employeeTypes = [
		EmployeeType.executive.rawValue,
		EmployeeType.seniorManagement.rawValue,
		EmployeeType.staff.rawValue
	]
	
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
		
		allEmployees = []
		
		employeeTypes.forEach { employeeType in
			allEmployees.append(
				companyEmployees.filter { $0.type == employeeType }
			)
		}
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
		return allEmployees.count
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label = CustomLabel()
		label.textColor = .darkBlue
		label.font = .systemFont(ofSize: 16, weight: .bold)
		label.backgroundColor = .lightBlue
		label.text = employeeTypes[section]
		return label
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return allEmployees[section].count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EmployeeCell else {
			return UITableViewCell()
		}

		let employee = allEmployees[indexPath.section][indexPath.row]
		cell.employee = employee
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 55
	}
}

// MARK: - CreateEmployeeControllerDelegate

extension EmployeesController: CreateEmployeeControllerDelegate {
	func didAddEmployee(_ employee: Employee) {
		guard let section = employeeTypes.firstIndex(of: employee.type!) else { return }
		
		let row = allEmployees[section].count
		let newIndexPath = IndexPath(row: row, section: section)
		
		allEmployees[section].append(employee)
		
		tableView.insertRows(at: [newIndexPath], with: .automatic)
	}
}
