//
//  CollectionViewCell.swift
//  GoCar
//
//  Created by Thien Nguyen on 19/3/21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var data: InputCarData?{
        didSet{
            guard let data = data else {return}
            img.image = data.image
            info.text = data.info
            title.text = data.title
            
        }
    }
    
    private var img: UIImageView = {
        let img = UIImageView()
        
        return img
    }()
    
    private var info: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()
    
    private var title: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 10)
        label.textAlignment = .center
        return label
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .darkGray
        label.text = "Press to view"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(img)
        contentView.addSubview(title)
        contentView.addSubview(info)
        contentView.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        title.frame = CGRect(x: 5, y: 0, width: contentView.frame.size.width-10, height: 20)
        label.frame = CGRect(x: 5, y: contentView.frame.size.height-20, width: contentView.frame.size.width-10, height: 20)
        info.frame = CGRect(x: 5, y: contentView.frame.size.height-40, width: contentView.frame.size.width-10, height: 20)
        img.frame = CGRect(x: 5, y: 20, width: contentView.frame.size.width-10, height: contentView.frame.size.height-60)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
