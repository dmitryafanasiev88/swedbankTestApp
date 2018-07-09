import Foundation
import CoreGraphics
import UIKit

class LocationDetailsViewModel: ControllerViewModel, FooterHeaderProtocol {
    var headerHeight: CGFloat = 44
    var footerHeight: CGFloat = 1
    let sectionsCount = 2
    var terminal: Terminal?
    fileprivate let context: NSStringDrawingContext = NSStringDrawingContext()
    fileprivate let defaultCellHeight: CGFloat = 40
    
    override init(_ cellReuseIdentifier: String) {
        super.init(cellReuseIdentifier)
    }
    
    func getSectionRowCount(_ section: Int) -> Int {
        guard let terminal = terminal else {
            return 0
        }
        if section == 0 {
            return 4
        } else {
            if let type = terminal.getTerminalType() {
                return type == .Branch ? 2 : 1
            }
            return 1
        }
    }
    
    func getCellInfo(_ indexPath: IndexPath) -> (type: String, value: String?) {
        switch (indexPath.section, indexPath.row) {
            case (0, 0): return (type: "TYPE", value: terminal?.getTerminalType()?.name)
            case (0, 1): return (type: "NAME", value: terminal?.name)
            case (0, 2): return (type: "ADDRESS", value: terminal?.address)
            case (0, 3): return (type: "REGION", value: terminal?.region)
            case (1, 0): return (type: "AVAILABILITY", value: terminal?.availability)
            case (1, 1): return (type: "INFO", value: terminal?.info)
            default: return (type: "", value: "")
        }
    }
    
    func getRowHeight(_ indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat {
        let width = tableViewWidth - LocationDetailsCell.nameLabelWidth - LocationDetailsCell.horizontalPadding
        if let data = getCellInfo(indexPath).value {
            let size: CGSize = data.boundingRect(with: CGSize(width: width, height: 10000),
                                                 options:NSStringDrawingOptions.usesLineFragmentOrigin,
                                                 attributes: [NSAttributedStringKey.font: LocationDetailsCell.valueLabelFont],
                                                 context: context).size as CGSize
            return max(defaultCellHeight, size.height + LocationDetailsCell.verticalPadding)
        }
        
        return defaultCellHeight
    }
    
}
