import UIKit

protocol GithubuserListRouterInput {
  func navigateToDetail(githubUser: GithubUserViewModel)
}

class GithubuserListRouter: GithubuserListRouterInput {
  weak var viewController: GithubuserListViewController!

  // MARK: - Navigation

  func navigateToDetail(githubUser: GithubUserViewModel) {
    let detailViewController = DetailViewController()
    detailViewController.githubUser = githubUser
    viewController
      .navigationController?
      .pushViewController(detailViewController, animated: true)
  }
}
