//
//  CreateEmployeeController.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 27.05.2022.
//

import UIKit

protocol CreateEmployeeControllerDelegate: AnyObject {
	func didAddEmployee(_ employee: Employee)
	//	func didChangeCompany(_ employee: Employee)
}

class CreateEmployeeController: UIViewController {
	
	private enum CreateEmployeeConstants {
		enum Sizes: CGFloat {
			case containerViewHeight = 55
			case fieldsHeight = 50
		}
		enum Spaces: CGFloat {
			case defaultSpace = 16
			case nameStackViewTopSpace = 8
		}
	}
	
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
		let containerView = setupContainerView(height: CreateEmployeeConstants.Sizes.containerViewHeight.rawValue)
		let stackView = createStackView(subviews: [nameLabel, employeeTextField])
		containerView.addSubview(stackView)
		
		NSLayoutConstraint.activate([
			// Name Stack View Autholayout
			stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: CreateEmployeeConstants.Spaces.nameStackViewTopSpace.rawValue),
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CreateEmployeeConstants.Spaces.defaultSpace.rawValue),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -CreateEmployeeConstants.Spaces.defaultSpace.rawValue),
			stackView.heightAnchor.constraint(equalToConstant: CreateEmployeeConstants.Sizes.fieldsHeight.rawValue),
			
			// Name label autholayout
			nameLabel.widthAnchor.constraint(equalToConstant: 100),
		])
		
	}
	
	// MARK: - Objc Fileprivate
	
	@objc fileprivate func handleSave() {
		guard let employeeName = employeeTextField.text else { return }
		guard let company = company else { return }
		
		CoreDataManager.shared.createEmployee(employeeName: employeeName, company: company) { [weak self] result in
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
