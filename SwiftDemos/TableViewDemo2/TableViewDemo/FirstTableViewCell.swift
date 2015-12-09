//
//  FirstTableViewCell.swift
//  TableViewDemo
//
//  Created by coderyi on 15/12/9.
//  Copyright © 2015年 coderyi. All rights reserved.
//

import UIKit
protocol FirstTableViewCellDelegate:NSObjectProtocol {
    func addButtonAction()
    func reduceButtonAction()

}
class FirstTableViewCell: UITableViewCell {

//    var titleLabel: UILabel = UILabel ()
//    var detailLabel: UILabel = UILabel ()
//    var countLabel: UILabel = UILabel ()
//    var addCountButton: UIButton = UIButton.init(type: .Custom)
//    var reduceCountButton: UIButton = UIButton.init(type: .Custom)
    var delegate:FirstTableViewCellDelegate! = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let viewHeight:CGFloat=60
        let orginX:CGFloat=18+7
        titleLabel.frame=CGRectMake(orginX, (viewHeight-30)/2, 60, 30)
        self.contentView.addSubview(titleLabel)
        
        detailLabel.frame=CGRectMake(titleLabel.frame.size.width+titleLabel.frame.origin.x+40, (viewHeight-30)/2, 80, 30)
        self.contentView.addSubview(detailLabel)
        
        
        let calculateBackgroundView:UIView = UIView.init(frame: CGRectMake(detailLabel.frame.size.width+detailLabel.frame.origin.x+40, (viewHeight-20)/2, 120, 30))
        self.contentView.addSubview(calculateBackgroundView)
        

        addCountButton.frame=CGRectMake(0, (30-20)/2, 20, 20)
        calculateBackgroundView.addSubview(addCountButton)
        addCountButton.addTarget(self, action:"cellAddButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
        reduceCountButton.frame=CGRectMake(calculateBackgroundView.frame.size.width-20, (30-20)/2, 20, 20)
        calculateBackgroundView.addSubview(reduceCountButton)
        reduceCountButton.addTarget(self, action:"cellReduceButtonAction", forControlEvents: UIControlEvents.TouchUpInside)

        countLabel.frame=CGRectMake(20, 0, 80, 30)
        calculateBackgroundView.addSubview(countLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cellAddButtonAction(){
            delegate.addButtonAction()
    }
    
    func cellReduceButtonAction(){
            delegate.reduceButtonAction()
    }
    
    lazy var titleLabel: UILabel = {
        
        var label: UILabel = UILabel ()
        label.font = UIFont.systemFontOfSize(14)
        label.textAlignment=NSTextAlignment.Left
        
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        
        var label: UILabel = UILabel ()
        label.font = UIFont.systemFontOfSize(14)
        label.textAlignment=NSTextAlignment.Left
        
        return label
    }()
    
    lazy var countLabel: UILabel = {
        var label: UILabel = UILabel ()
        label.font = UIFont.systemFontOfSize(14)
        label.textAlignment=NSTextAlignment.Center
        label.textColor=UIColor.init(colorLiteralRed: 0.97, green: 0.54, blue: 0.18, alpha: 1)
        return label
    }()
    
    lazy var addCountButton: UIButton = {
        var button: UIButton = UIButton.init(type: .Custom)
        button.backgroundColor=UIColor.greenColor()
        return button
    }()
    
    lazy var reduceCountButton: UIButton = {
        var button: UIButton = UIButton.init(type: .Custom)
        button.backgroundColor=UIColor.greenColor()
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func drawRect(rect: CGRect) {
        
    }
}
