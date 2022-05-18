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
			guard let company = company else { return }
			companyNameLabel.text = "\(company.name)"
		}
	}
	
	private let companyNameLabel: UILabel = {
		let label = UILabel()
		label.text = "HUIHUIHUIHUI"
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
		iv.backgroundColor = .red
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
		let imageSize: CGFloat = 60
		
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
