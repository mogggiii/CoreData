//
//  EmployeeCell.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 27.05.2022.
//

import UIKit
import CoreData

class EmployeeCell: UITableViewCell {
	
	var employee: Employee? {
		didSet {
			guard let employeeName = employee?.name, let birthday = employee?.employeeInformation?.birthday else {
				employeeLabel.text = employee?.name
				return
			}
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "dd MMM, yyyy"
			
			let birthdayDateString = dateFormatter.string(from: birthday)
			employeeLabel.text = "\(employeeName)    \(birthdayDateString)"
		}
	}
	
	let employeeLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.font = .systemFont(ofSize: 16)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		setupCell()
		backgroundColor = .tealColor
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	fileprivate func setupCell() {
		contentView.addSubview(employeeLabel)
		
		NSLayoutConstraint.activate([
			employeeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			employeeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			employeeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
		])
		
	}
}
