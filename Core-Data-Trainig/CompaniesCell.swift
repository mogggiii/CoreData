//
//  CompaniesCell.swift
//  Core-Data-Trainig
//
//  Created by mogggiii on 16.05.2022.
//

import UIKit

class CompaniesCell: UITableViewCell {
	
	private let companyNameLabel: UILabel = {
		let label = UILabel()
		label.text = "HUIHUIHUIHUI"
		label.textColor = .white
		label.font = .systemFont(ofSize: 16)
		return label
	}()
	
	private let companyLogo: UIImageView = {
		let iv = UIImageView()
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
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
//		contentView.addSubview(companyLogo)
//		contentView.addSubview(companyNameLabel)
//		
//		let stackView = UIStackView(arrangedSubviews: [companyLogo, companyNameLabel])
//		stackView.axis = .horizontal
//		stackView.spacing = 20
//		stackView.distribution = .fill
//		contentView.addSubview(stackView)
//		
//		stackView.frame = CGRect(x: 16, y: 16, width: contentView.bounds.width, height: 50)
	}
	
}
