import UIKit

class LabelCollectionViewCell: UICollectionViewCell
{
    @IBOutlet var label: UILabel!
    let TextLabelSidePadding: CGFloat = 8.0

    @IBOutlet var tick: UIImageView!
    /**
        Allows you to generate a cell without dequeueing one from a table view.
        - Returns: The cell loaded from its nib file.
    */
    class func fromNib() -> LabelCollectionViewCell?
    {
        var cell: LabelCollectionViewCell?
        let nibViews = Bundle.main.loadNibNamed("LabelCollectionViewCell", owner: nil, options: nil)
        for nibView in nibViews! {
            if let cellView = nibView as? LabelCollectionViewCell {
                cell = cellView
            }
        }
        return cell
    }
    
    /**
        Sets the cell styles and content.
    */
    func configureWithIndexPath(_ indexPath: IndexPath, LabelData : String, showTick: Int)
    {
       
        label.layer.cornerRadius = 6
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.text = LabelData
        //label.sizeToFit()
        if showTick == 0
        {
            tick.isHidden = true
        }
        else
        {
            tick.isHidden = false
        }
        
       
        
        
    }
    
    
       
}
