import UIKit
import Kingfisher

protocol TabButtonsDelegate: class {
    func favouriteTapped(at index:IndexPath)
}

class GithubUserCell: UITableViewCell {
  
  @IBOutlet private weak var userNameLabel: UILabel!
  @IBOutlet private weak var avartarImageView: UIImageView!
  @IBOutlet private weak var githubUrlLabel: UILabel!
  @IBOutlet private weak var accountTypeLabel: UILabel!
  @IBOutlet private weak var siteAdminStatusLabel: UILabel!
  @IBOutlet private weak var favouriteButton: UIButton!
  var indexPath:IndexPath?
  weak var delegate: TabButtonsDelegate!
  
  func updateUI(githubUser: GithubUserViewModel) {
    userNameLabel.text = githubUser.loginName
    githubUrlLabel.text = githubUser.githubURL
    accountTypeLabel.text = githubUser.accountType
    siteAdminStatusLabel.text = "\(githubUser.siteAdmin)"
    let url = URL(string: githubUser.avatarURL)
    avartarImageView.kf.setImage(with: url, placeholder: UIImage(named: Image.placeholder.rawValue))
    favouriteButton.isSelected = githubUser.isFavourite
  }
  
  @IBAction private func tabFavourite() {
    guard let indexPath = indexPath else {
      return
    }
    delegate.favouriteTapped(at: indexPath)
  }
}
