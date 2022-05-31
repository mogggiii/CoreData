//
//  CreateEmployeeView.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 31.05.2022.
//

import UIKit

class CreateEmployeeView: UIView {
	
	// MARK: - Constant
	
	private enum Constants {
		enum Sizes: CGFloat {
			case containerViewHeight = 150
			case fieldsHeight = 50
			case segmentedControllerHeight = 34
		}
		enum Spaces: CGFloat {
			case defaultSpace = 16
			case nameStackViewTopSpace = 8
		}
	}
	
	// MARK: - Public Properties
	
	
	
	//	var birthday: String? {
	//		didSet {
	//			birthday = birthdayTextField.text
	//		}
	//	}
	
	//	var employeeType: String? {
	//		didSet {
	//			employeeType = employeeTypeSegmentedControll.titleForSegment(at: employeeTypeSegmentedControll.selectedSegmentIndex)
	//		}
	//	}
	
	// MARK: - UI Components
	
	private let nameLabel: UILabel = {
		let label = UILabel()
		label.text = "Name"
		label.textColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let employeeTextField: UITextField = {
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
	
	let birthdayTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "DD/MM/YYYY"
		textField.keyboardType = .numbersAndPunctuation
		textField.textColor = .black
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	let employeeTypeSegmentedControll: UISegmentedControl = {
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
	
	// TODO: - Make this shit
	
//	var employeeName: String? {
//		didSet {
//			guard let text = employeeTextField.text else { return }
//			employeeName = text
//		}
//	}
	
	// MARK: - Init
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Fileprivate
	
	fileprivate func setupLayout() {
		let containerView = setupContainerView(height: Constants.Sizes.containerViewHeight.rawValue)
		let nameStackView = createStackView(subviews: [nameLabel, employeeTextField])
		let birthdayStackView = createStackView(subviews: [birthdayLabel, birthdayTextField])
		
		containerView.addSubview(nameStackView)
		containerView.addSubview(birthdayStackView)
		containerView.addSubview(employeeTypeSegmentedControll)
		
		NSLayoutConstraint.activate([
			// Name Stack View Autholayout
			nameStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
			nameStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Spaces.defaultSpace.rawValue),
			nameStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Spaces.defaultSpace.rawValue),
			nameStackView.heightAnchor.constraint(equalToConstant: Constants.Sizes.fieldsHeight.rawValue),
			
			// Name label autholayout
			nameLabel.widthAnchor.constraint(equalToConstant: 100),
			
			// Birthday label autholayout
			birthdayLabel.widthAnchor.constraint(equalToConstant: 100),
			
			// Birthday Stack View
			birthdayStackView.topAnchor.constraint(equalTo: nameStackView.bottomAnchor),
			birthdayStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Spaces.defaultSpace.rawValue),
			birthdayStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Spaces.defaultSpace.rawValue),
			birthdayStackView.heightAnchor.constraint(equalToConstant: Constants.Sizes.fieldsHeight.rawValue),
			
			employeeTypeSegmentedControll.topAnchor.constraint(equalTo: birthdayStackView.bottomAnchor),
			employeeTypeSegmentedControll.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Spaces.defaultSpace.rawValue),
			employeeTypeSegmentedControll.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Spaces.defaultSpace.rawValue),
			employeeTypeSegmentedControll.heightAnchor.constraint(equalToConstant: Constants.Sizes.segmentedControllerHeight.rawValue)
		])
	}
}
