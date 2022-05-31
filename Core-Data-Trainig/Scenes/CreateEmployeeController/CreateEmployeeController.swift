//
//  CreateEmployeeController.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 27.05.2022.
//

import UIKit

protocol CreateEmployeeControllerDelegate: AnyObject {
	func didAddEmployee(_ employee: Employee)
}

class CreateEmployeeController: UIViewController {
	
	private let createEmployeeView = CreateEmployeeView()
	
	weak var delegate: CreateEmployeeControllerDelegate?
	
	var company: Company?
	
	// MARK: - ViewController Lifecycle
	
	override func loadView() {
		view = createEmployeeView
	}
	
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
	
	fileprivate func presentErrorAlertWithMessage(_ message: String) {
		let alertAction = UIAlertAction(title: "OK", style: .cancel)
		let alertController = UIAlertController(title: "Ooops", message: message, preferredStyle: .alert)
		alertController.addAction(alertAction)
		
		present(alertController, animated: true)
	}
	
	fileprivate func checkFormValidity(name: String, birthday: String) {
		if name.isEmpty {
			let message = "You did not enter an employee's name"
			presentErrorAlertWithMessage(message)
			return
		}
		
		if birthday.isEmpty {
			let message = "You have not entered birthday"
			presentErrorAlertWithMessage(message)
			return
		}
	}
	
	// MARK: - Objc Fileprivate
	
	@objc fileprivate func handleSave() {
		guard let employeeName = createEmployeeView.employeeTextField.text else { return }
		guard let birthdayText = createEmployeeView.birthdayTextField.text else { return }
		guard let employeeType = createEmployeeView.employeeTypeSegmentedControll.titleForSegment(at: createEmployeeView.employeeTypeSegmentedControll.selectedSegmentIndex) else { return }
		guard let company = company else { return }
	
//		 form validation
		checkFormValidity(name: employeeName, birthday: birthdayText)

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"

		guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
			let message = "Birthday date entered not valid"
			presentErrorAlertWithMessage(message)
			return
		}

		CoreDataManager.shared.createEmployee(employeeName: employeeName, company: company, birthday: birthdayDate, employeeType: employeeType) { [weak self] result in
			switch result {
			case .success(let employee):
				self?.dismiss(animated: true) {
					self?.delegate?.didAddEmployee(employee)
				}
			case .failure(let error):
				// use UIAlertController to present error alert
				print("Error", error)
			}
		}
	}
}
