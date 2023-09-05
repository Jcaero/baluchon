//
//  WeatherCell.swift
//  baluchon
//
//  Created by pierrick viret on 04/09/2023.
//

import UIKit

// MARK: - WeatherCell
struct CellData {
    var hour: String
    var iconName: String
}

class WeatherCell: UICollectionViewCell {
    var data: CellData? {
        didSet {
            guard let data = data else { return }
            icon.image = UIImage(named: data.iconName)
            hour.text = data.hour
        }
    }

    var hour: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()

    var icon: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        hour.translatesAutoresizingMaskIntoConstraints = false
        icon.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(hour)
        NSLayoutConstraint.activate([
            hour.topAnchor.constraint(equalTo: contentView.topAnchor),
            hour.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            hour.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            hour.heightAnchor.constraint(equalToConstant: 15)
        ])

        contentView.addSubview(icon)
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: hour.bottomAnchor),
            icon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            icon.heightAnchor.constraint(equalTo: icon.widthAnchor),
            icon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
