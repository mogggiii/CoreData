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
				companyNameFoundedDateLabel.text = company?.name
				return
			}
			
			// setup label
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MMM dd, yyyy"
			
			let foundedDateString = dateFormatter.string(from: foundedDate)
			companyNameFoundedDateLabel.text = "\(companyName) - Founded: \(foundedDateString)"
			
			// setup imageView
			guard let imageData = company?.imageData, let image = UIImage(data: imageData) else { return }
			companyLogoImageView.image = image
		}
	}
	
	private let companyNameFoundedDateLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.font = .systemFont(ofSize: 16)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let companyLogoImageView: UIImageView = {
		let iv = UIImageView()
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		iv.translatesAutoresizingMaskIntoConstraints = false
		iv.backgroundColor = .clear
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
		
		contentView.addSubview(companyLogoImageView)
		contentView.addSubview(companyNameFoundedDateLabel)
		companyLogoImageView.layer.cornerRadius = imageSize / 2
		
		NSLayoutConstraint.activate([
			companyLogoImageView.heightAnchor.constraint(equalToConstant: imageSize),
			companyLogoImageView.widthAnchor.constraint(equalToConstant: imageSize),
			companyLogoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			companyLogoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			
			companyNameFoundedDateLabel.centerYAnchor.constraint(equalTo: companyLogoImageView.centerYAnchor),
			companyNameFoundedDateLabel.leadingAnchor.constraint(equalTo: companyLogoImageView.trailingAnchor, constant: 16),
			companyNameFoundedDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
		])
	}
	
}
