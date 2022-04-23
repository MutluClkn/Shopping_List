//
//  TableViewCell.swift
//  ShoppingList
//
//  Created by Mutlu Çalkan on 21.04.2022.
//

import UIKit
import SnapKit

class TableViewCell: UITableViewCell {

    static let identifier = "TableViewCell"
    
    let label : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    func constraints() {
        label.snp.makeConstraints { make in
            make.centerYWithinMargins.equalTo(contentView.snp_centerYWithinMargins)
            make.left.equalTo(contentView.snp_leftMargin)
            make.right.equalTo(contentView.snp_rightMargin)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
