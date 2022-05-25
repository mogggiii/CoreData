//
//  CompaniesCell.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 16.05.2022.
//

import UIKit

class CompaniesCell: UITableViewCell {
	
	var company: Company? {
		didSet {
		
			guard let companyName = company?.name, let foundedDate = company?.founded else {
				companyNameLabel.text = company?.name
				return
			}
			
			// setup label
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MMM dd, yyyy"
			
			let foundedDateString = dateFormatter.string(from: foundedDate)
			companyNameLabel.text = "\(companyName) - Founded: \(foundedDateString)"
			
			// setup imageView
			guard let imageData = company?.imageData, let image = UIImage(data: imageData) else { return }
			companyLogo.image = image
		}
	}
	
	private let companyNameLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.font = .systemFont(ofSize: 16)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let companyLogo: UIImageView = {
		let iv = UIImageView()
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		iv.translatesAutoresizingMaskIntoConstraints = false
		return iv
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		backgroundColor = .tealColor
		configureUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	fileprivate func configureUI() {
		let imageSize: CGFloat = 40
		
		contentView.addSubview(companyLogo)
		contentView.addSubview(companyNameLabel)
		companyLogo.layer.cornerRadius = imageSize / 2
		
		NSLayoutConstraint.activate([
			companyLogo.heightAnchor.constraint(equalToConstant: imageSize),
			companyLogo.widthAnchor.constraint(equalToConstant: imageSize),
			companyLogo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
			companyLogo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
			companyLogo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			
			companyNameLabel.centerYAnchor.constraint(equalTo: companyLogo.centerYAnchor),
			companyNameLabel.leadingAnchor.constraint(equalTo: companyLogo.trailingAnchor, constant: 16),
		])
	}
	
}
