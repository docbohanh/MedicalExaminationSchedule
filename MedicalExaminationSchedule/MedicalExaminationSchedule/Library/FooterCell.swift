import UIKit

public class FooterCell: UITableViewCell {

    @IBOutlet private weak var activityIndecator: UIActivityIndicatorView!


    public override func awakeFromNib() {
        super.awakeFromNib()

    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        activityIndecator.startAnimating()
    }

}
