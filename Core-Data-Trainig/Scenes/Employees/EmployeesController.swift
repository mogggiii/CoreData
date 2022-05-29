//
//  EmployeesController.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 27.05.2022.
//

import UIKit
import CoreData

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
	}
	
	fileprivate func fetchEmployees() {
		let context = CoreDataManager.shared.persistentContainer.viewContext
		let request = NSFetchRequest<Employee>(entityName: "Employee")
		
		do {
			let employees = try context.fetch(request)
			self.employees = employees
		} catch let fetchError {
			print("Failed to fetch employees", fetchError)
		}
		
	}
	
	// MARK: - Objc fileprivate
	
	@objc fileprivate func handleAddEmployee() {
		print("Trying to add employee")
		let createEmployeeController = CreateEmployeeController()
		createEmployeeController.delegate = self
		
		let navVC = CustomNavigationController(rootViewController: createEmployeeController)
		navVC.modalPresentationStyle = .fullScreen
		
		present(navVC, animated: true)
	}
	
	// MARK: - UITableViewDataSource
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return employees.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EmployeeCell else {
			return UITableViewCell()
		}
		
		let employee = employees[indexPath.row]
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
