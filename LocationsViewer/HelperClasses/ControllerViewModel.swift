import Foundation
import CoreGraphics
import CoreData

class ControllerViewModel {
    var segueId: SequeIdentifier?
    var cellReuseIdentifier: String
    var fetchRequest: NSFetchRequest<NSFetchRequestResult>?
    var sectionNameKeyPath: String?
    
    init(_ cellReuseIdentifier: String) {
        self.cellReuseIdentifier = cellReuseIdentifier
    }
    
    func prepareToDestroy() {
        // Override
    }
}

// Protocol for representing Footer/Header/Cell heights in a table view.
// Provided designes have the same heights for all cells (in each table view)
// thats why protocol do not uses indexPath or section number to determine height

protocol FooterHeaderProtocol {
    var footerHeight: CGFloat { get }
    var headerHeight: CGFloat { get }
}

protocol CellHeightProtocol {
    var cellHeight: CGFloat { get }
}
