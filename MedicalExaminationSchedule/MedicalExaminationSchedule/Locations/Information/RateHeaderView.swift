//
//  RateHeaderView.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 12/6/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class RateHeaderView: UIView {

    @IBOutlet weak var imageNumberStar: UIImageView!
    @IBOutlet weak var numberRateLabel: UILabel!
    @IBOutlet weak var vote5BackgroundView: UIView!
    @IBOutlet weak var vote5TopView: UIView!
    @IBOutlet weak var vote4BackgroundView: UIView!
    @IBOutlet weak var vote4TopView: UIView!
    @IBOutlet weak var vote3BackgroundView: UIView!
    @IBOutlet weak var vote3TopView: UIView!
    @IBOutlet weak var vote2BackgroundView: UIView!
    @IBOutlet weak var vote2TopView: UIView!
    @IBOutlet weak var vote1BackgroundView: UIView!
    @IBOutlet weak var vote1TopView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func setupViewWithArray(array:[Int]) -> Void {
        numberRateLabel.text = String.init(format: "%d Xếp hạng", 0)
        imageNumberStar.image = UIImage.init(named: String.init(format: "ic_star_%d", 0))
        if array.count == 0 {
            return
        }
        let totalRate = Float(array.last!)
        numberRateLabel.text = String.init(format: "%d Xếp hạng", array.last!)
        let rate1 = Float(array[0])
        let rate2 = Float(array[1])
        let rate3 = Float(array[2])
        let rate4 = Float(array[3])
        let rate5 = Float(array[4])
        // avg
        let avg = Int((rate1*1 + rate2*2 + rate3*3 + rate4*4 + rate5*5)/totalRate)
        imageNumberStar.image = UIImage.init(named: String.init(format: "ic_star_%d", avg))
        // update UI
        let totalWidth = Float(vote1BackgroundView.frame.width)
        let height = vote1TopView.frame.height
        let x = vote1TopView.frame.origin.x
        let y = vote1TopView.frame.origin.y
        vote1TopView.frame = CGRect.init(x: x, y: y, width: CGFloat(rate1/totalRate*totalWidth), height: height)
        vote2TopView.frame = CGRect.init(x: x, y: y, width: CGFloat(rate2/totalRate*totalWidth), height: height)
        vote3TopView.frame = CGRect.init(x: x, y: y, width: CGFloat(rate3/totalRate*totalWidth), height: height)
        vote4TopView.frame = CGRect.init(x: x, y: y, width: CGFloat(rate4/totalRate*totalWidth), height: height)
        vote5TopView.frame = CGRect.init(x: x, y: y, width: CGFloat(rate5/totalRate*totalWidth), height: height)
    }
}
