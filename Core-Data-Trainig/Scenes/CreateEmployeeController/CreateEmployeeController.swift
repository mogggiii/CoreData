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
	
	weak var delegate: CreateEmployeeControllerDelegate?
	var company: Company?
	
	// MARK: - UI Components
	
	private let nameLabel: UILabel = {
		let label = UILabel()
		label.text = "Name"
		label.textColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let employeeTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Enter Name"
		textField.textColor = .black
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	private let birthdayLabel: UILabel = {
		let label = UILabel()
		label.text = "Birthday"
		label.textColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let birthdayTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "DD/MM/YYYY"
		textField.keyboardType = .numbersAndPunctuation
		textField.textColor = .black
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	private let employeeTypeSegmentedControll: UISegmentedControl = {
		let types = [
			EmployeeType.executive.rawValue,
			EmployeeType.seniorManagement.rawValue,
			EmployeeType.staff.rawValue
		]
		
		let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
		let segmentedControl = UISegmentedControl(items: types)
		segmentedControl.translatesAutoresizingMaskIntoConstraints = false
		segmentedControl.selectedSegmentTintColor = .darkBlue
		segmentedControl.selectedSegmentIndex = 0
		segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
		return segmentedControl
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Create Employee"
		
		view?.backgroundColor = .darkBlue
		
		setupNavigationButtons()
		setupLayout()
	}
	
	// MARK: - Fileprivate
	
	fileprivate func setupNavigationButtons() {
		setupCancelButtonInNavBar()
		setupSaveButtonInNavBar(#selector(handleSave))
	}
	
	fileprivate func setupLayout() {
		let containerView = setupContainerView(height: CreateEmployeeControllerConstants.Sizes.containerViewHeight.rawValue)
		let nameStackView = createStackView(subviews: [nameLabel, employeeTextField])
		let birthdayStackView = createStackView(subviews: [birthdayLabel, birthdayTextField])
		
		containerView.addSubview(nameStackView)
		containerView.addSubview(birthdayStackView)
		containerView.addSubview(employeeTypeSegmentedControll)
		
		NSLayoutConstraint.activate([
			// Name Stack View Autholayout
			nameStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
			nameStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CreateEmployeeControllerConstants.Spaces.defaultSpace.rawValue),
			nameStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -CreateEmployeeControllerConstants.Spaces.defaultSpace.rawValue),
			nameStackView.heightAnchor.constraint(equalToConstant: CreateEmployeeControllerConstants.Sizes.fieldsHeight.rawValue),
			
			// Name label autholayout
			nameLabel.widthAnchor.constraint(equalToConstant: 100),
			
			// Birthday label autholayout
			birthdayLabel.widthAnchor.constraint(equalToConstant: 100),
			
			// Birthday Stack View
			birthdayStackView.topAnchor.constraint(equalTo: nameStackView.bottomAnchor),
			birthdayStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CreateEmployeeControllerConstants.Spaces.defaultSpace.rawValue),
			birthdayStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -CreateEmployeeControllerConstants.Spaces.defaultSpace.rawValue),
			birthdayStackView.heightAnchor.constraint(equalToConstant: CreateEmployeeControllerConstants.Sizes.fieldsHeight.rawValue),
			
			employeeTypeSegmentedControll.topAnchor.constraint(equalTo: birthdayStackView.bottomAnchor),
			employeeTypeSegmentedControll.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CreateEmployeeControllerConstants.Spaces.defaultSpace.rawValue),
			employeeTypeSegmentedControll.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -CreateEmployeeControllerConstants.Spaces.defaultSpace.rawValue),
			employeeTypeSegmentedControll.heightAnchor.constraint(equalToConstant: CreateEmployeeControllerConstants.Sizes.segmentedControllerHeight.rawValue)
		])
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
		guard let employeeName = employeeTextField.text else { return }
		guard let company = company else { return }
		guard let birthdayText = birthdayTextField.text else { return }
		
		// form validation
		checkFormValidity(name: employeeName, birthday: birthdayText)
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"
		
		guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
			let message = "Birthday date entered not valid"
			presentErrorAlertWithMessage(message)
			return
		}
		
		guard let employeeType = employeeTypeSegmentedControll.titleForSegment(at: employeeTypeSegmentedControll.selectedSegmentIndex) else { return }
	
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
