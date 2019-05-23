//
//  PickerTVCell.swift
//  EMPlacePicker
//
//  Created by Lahiru Chathuranga on 5/21/19.
//  Copyright © 2019 ElegantMedia. All rights reserved.
//

import Foundation

open class PickerTVCell: UITableViewCell {
    
    let placeNameLabel: UILabel = {
        let placeName = UILabel()
        placeName.text = "Place name"
        placeName.numberOfLines = 0
        placeName.font = UIFont(name: "SF Pro Display", size: 16)
        placeName.textColor = UIColor.white  //UIColor(red:0.03, green:0.15, blue:0.26, alpha:1)
        return placeName
    }()
    
    let upperView: UIView = {
        let view = UIView()
        return view
    }()
    
    func InitialSetup () {
        addSubViews()
        setConstraints()
        setupUI()
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupUI() {
        contentView.backgroundColor = UIColor.clear
        upperView.backgroundColor = UIColor(red:0.03, green:0.15, blue:0.26, alpha:1)
        upperView.layer.cornerRadius = 4
    }
    
    func addSubViews() {
        contentView.addSubview(upperView)
        contentView.addSubview(placeNameLabel)
        //        contentView.addSubview(coordinateLabel)
    }
    
    func setConstraints() {
        upperView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(5)
            make.right.equalTo(self.contentView).offset(-5)
            make.top.equalTo(self.contentView).offset(5)
            make.bottom.equalTo(self.contentView).offset(-5)
        }
        placeNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.upperView).offset(10)
            make.right.equalTo(self.upperView).offset(-10)
            make.top.equalTo(self.upperView).offset(10)
            make.bottom.equalTo(self.upperView).offset(-10)
            make.centerX.equalTo(self.upperView.snp.centerX)
            
        }
    }
    
}
