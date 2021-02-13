import Foundation

protocol ViewConfiguration {
    func buildLayout()
    func buildViewHierarchy()
    func setupConstraints()
    func configureViews()
}

extension ViewConfiguration {
    func buildLayout() {
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }
}
