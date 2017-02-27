//
//  GuideView.swift
//  MedicalExaminationSchedule
//
//  Created by MILIKET on 2/26/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

class GuideView: UIView {
    
    fileprivate enum Size: CGFloat {
        case labelHeight = 30, padding5 = 5, icon = 36, arrow = 44, padding10 = 10
    }
    
    var guideLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.contentMode = .center
        label.textColor = UIColor.gray
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        label.layer.cornerRadius = Size.labelHeight.. / 2
        label.text = "Hiển thị theo bản đồ"
        return label
    }()
    
    var guideImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white.alpha(0.3)
//        imageView.image = Icon.Guide.map
//        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = Size.icon.. / 2
        return imageView
    }()
    
    var guideArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.image = Icon.Guide.arrow
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        backgroundColor = UIColor.black.alpha(0.7)
        layer.masksToBounds = false
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        
        addSubview(guideLabel)
        addSubview(guideImage)
        addSubview(guideArrow)
    }
    
    /**
     Hàm ẩn hiện view
     */
    func setVisibilityOf(_ view: UIView, to visible: Bool, duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        
        if visible && view.isHidden { view.isHidden = false }
        
        UIView.animate(
            withDuration: duration,
            animations: {
                view.alpha = visible ? 1.0 : 0.0
        },
            completion: { finished in
                if !visible { view.isHidden = true }
                if let completion = completion { completion() }
        })
        
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guideImage.frame = CGRect(x: bounds.width - Size.icon.. - Size.padding10..,
                                  y: 62,
                                  width: Size.icon..,
                                  height: Size.icon..)
        
        guideArrow.frame = CGRect(x: guideImage.frame.minX + Size.padding10.. - Size.arrow..,
                                  y: guideImage.frame.maxY,
                                  width: Size.arrow..,
                                  height: Size.arrow..)
        
        let left = (bounds.width - guideArrow.frame.minX) + Size.padding5..
        guideLabel.frame = CGRect(x: left,
                                  y: guideArrow.frame.maxY - Size.labelHeight.. / 2,
                                  width: bounds.width - left * 2,
                                  height: Size.labelHeight..)
        
    }
    
    
}


postfix operator ..
postfix func ..<T: RawRepresentable> (lhs: T) -> T.RawValue {
    return lhs.rawValue
}
