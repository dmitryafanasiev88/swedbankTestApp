import Foundation
import UIKit

extension UIView {
    
    @nonobjc static var defaultReuseIdentifier : String {
        return String(describing: self)
    }
    
}
