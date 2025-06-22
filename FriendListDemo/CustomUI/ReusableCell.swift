import UIKit

protocol ReusableCell: AnyObject {
    static var identifier: String { get }
}
extension ReusableCell {
    static var identifier: String { String(describing: self) }
} 