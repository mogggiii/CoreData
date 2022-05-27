////
////  ContainerView.swift
////  Core-Data-Trainig
////
////  Created by mogggiii on 27.05.2022.
////
//
//import UIKit
//
//class ContainerView: UIView {
//	
//	private enum Constants {
//		enum Sizes: CGFloat {
//			case logoSize = 100
//			case containerViewHeight = 350
//			case fieldsHeight = 50
//		}
//		enum Spaces: CGFloat {
//			case defaultSpace = 16
//			case logoTopSpace = 8
//		}
//	}
//	
//	var company: Company? {
//		didSet {
//			guard let company = company else { return }
//			nameTextField.text = company.name
//			foundedDatePicker.date = company.founded ?? Date()
//			
//			guard let imageData = company.imageData, let logo = UIImage(data: imageData) else { return }
//			companyLogo.image = logo
//		}
//	}
//	
//	// MARK: - UI Components
//	private let nameLabel: UILabel = {
//		let label = UILabel()
//		label.text = "Name"
//		label.textColor = .black
//		label.translatesAutoresizingMaskIntoConstraints = false
//		return label
//	}()
//	
//	private let nameTextField: UITextField = {
//		let textField = UITextField()
//		textField.placeholder = "Enter Name"
//		textField.textColor = .black
//		textField.translatesAutoresizingMaskIntoConstraints = false
//		return textField
//	}()
//	
//	private let foundedDatePicker: UIDatePicker = {
//		let datePicker = UIDatePicker()
//		datePicker.translatesAutoresizingMaskIntoConstraints = false
//		datePicker.preferredDatePickerStyle = .wheels
//		datePicker.datePickerMode = .date
//		return datePicker
//	}()
//	
//	lazy var companyLogo: UIImageView = {
//		let imageView = UIImageView(image: UIImage(named: "select_photo_placeholder"))
//		imageView.translatesAutoresizingMaskIntoConstraints = false
//		imageView.isUserInteractionEnabled = true
//		imageView.layer.cornerRadius = Constants.Sizes.logoSize.rawValue / 2
//		imageView.layer.borderColor = UIColor.darkBlue.cgColor
//		imageView.layer.borderWidth = 1
//		imageView.clipsToBounds = true
//		imageView.contentMode = .scaleAspectFill
//		return imageView
//	}()
//	
//	override init(frame: CGRect) {
//		super.init(frame: frame)
//		
//		setupUI()
//	}
//	
//	required init?(coder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
//	
//	fileprivate func setupUI() {
//		let containerView = setupContainerView()
//		let nameStackView = createStackView(subviews: [nameLabel, nameTextField])
//		
//		containerView.addSubview(companyLogo)
//		containerView.addSubview(nameStackView)
//		containerView.addSubview(foundedDatePicker)
//		
//		NSLayoutConstraint.activate([
//			// Company Logo Autholayout
//			companyLogo.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.Spaces.logoTopSpace.rawValue),
//			companyLogo.centerXAnchor.constraint(equalTo: centerXAnchor),
//			companyLogo.heightAnchor.constraint(equalToConstant: Constants.Sizes.logoSize.rawValue),
//			companyLogo.widthAnchor.constraint(equalToConstant: Constants.Sizes.logoSize.rawValue),
//			
//			// Name Stack View Autholayout
//			nameStackView.topAnchor.constraint(equalTo: companyLogo.bottomAnchor, constant: Constants.Spaces.defaultSpace.rawValue),
//			nameStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Spaces.defaultSpace.rawValue),
//			nameStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Spaces.defaultSpace.rawValue),
//			nameStackView.heightAnchor.constraint(equalToConstant: Constants.Sizes.fieldsHeight.rawValue),
//			
//			// Name label autholayout
//			nameLabel.widthAnchor.constraint(equalToConstant: 100),
//			
//			// Date Picker Autholayot
//			foundedDatePicker.topAnchor.constraint(equalTo: nameStackView.bottomAnchor),
//			foundedDatePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
//			foundedDatePicker.trailingAnchor.constraint(equalTo: trailingAnchor),
//			foundedDatePicker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
//		])
//	}
//	
//	/// Container view
//	fileprivate func setupContainerView() -> UIView {
//		let container = UIView()
//		container.backgroundColor = .lightBlue
//		container.translatesAutoresizingMaskIntoConstraints = false
//		addSubview(container)
//		
//		NSLayoutConstraint.activate([
//			container.topAnchor.constraint(equalTo: topAnchor),
//			container.leadingAnchor.constraint(equalTo: leadingAnchor),
//			container.trailingAnchor.constraint(equalTo: trailingAnchor),
//			container.heightAnchor.constraint(equalToConstant: Constants.Sizes.containerViewHeight.rawValue),
//		])
//		
//		return container
//	}
//	
//	/// Generate stack view
//	fileprivate func createStackView(subviews: [UIView]) -> UIStackView {
//		let stackView = UIStackView(arrangedSubviews: subviews)
//		stackView.translatesAutoresizingMaskIntoConstraints = false
//		return stackView
//	}
//}
