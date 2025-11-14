import Foundation

extension String {
    /// 取得本地化字串，無 comment
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    /// 取得本地化字串，可加 comment
    func localized(_ comment: String) -> String {
        NSLocalizedString(self, comment: comment)
    }
} 