//
//  FeedItemCell.swift
//  NYCSchools
//
//  Created by Augustus Wilson on 2/21/23.
//  Copyright © 2021 Augustus Wilson. All rights reserved.
//

import UIKit

class FeedItemTableViewCell: UITableViewCell  {
    
    let schoolName : UILabel  = {
        let label  =  UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.accessibilityIdentifier = "School Name"
        label.font = UIFont.init(name: "AvenirNext-Regular", size: 16.0)
        label.numberOfLines = 0
        return label;
    }()
    
    let location : UILabel  = {
        let label  =  UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.accessibilityIdentifier = "Location"
        label.font = UIFont.init(name: "AvenirNext-Regular", size: 14.0)
        label.textColor = .gray
        label.numberOfLines = 0
        return label;
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupContraints();
        accessoryType = .disclosureIndicator
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupContraints();
        accessoryType = .disclosureIndicator
    }

    internal func setupContraints() {

        contentView.addSubview(schoolName)
        contentView.addSubview(location)

        NSLayoutConstraint.activate([
            schoolName.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8),
            schoolName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            schoolName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            location.topAnchor.constraint(equalTo:schoolName.bottomAnchor,constant: 8),
            location.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            location.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            location.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -8),
        ])
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    internal func refreshWith(feedItem: FeedItem) {
        schoolName.text = feedItem.schoolName
        location.text = feedItem.location
    }
}
