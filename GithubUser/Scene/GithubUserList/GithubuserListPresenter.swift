import UIKit

protocol GithubuserListPresenterInterface {
  func presentGithubUsersLoading()
  func presentGithubUsers(response: GithubuserList.GetUser.Response)
  func presentFavouriteUsers(response: GithubuserList.FavouriteUser.Response)
}

class GithubuserListPresenter: GithubuserListPresenterInterface {
  weak var viewController: GithubuserListViewControllerInterface!

  // MARK: - Presentation logic

  func presentGithubUsers(response: GithubuserList.GetUser.Response) {
    
    switch response.result {
    case .success(let data):
      
      let viewModel = GithubuserList.GetUser.ViewModel(content: Content.success(mapUserViewModel(data: data)))
      viewController.displayGithubUsers(viewModel: viewModel)
    case .failure:
      let viewModel = GithubuserList.GetUser.ViewModel(content: Content.failure)
      viewController.displayGithubUsers(viewModel: viewModel)
    }
  }
  
  func presentFavouriteUsers(response: GithubuserList.FavouriteUser.Response) {
    let viewModel = GithubuserList.FavouriteUser.ViewModel(content: mapUserViewModel(data: response.result))
    viewController.displayFavouriteUsers(viewModel: viewModel)
  }
  
  private func mapUserViewModel(data: [GithubUser]) -> [GithubUserViewModel] {
   
    return data.map({ (user) -> GithubUserViewModel in
      GithubUserViewModel(
        loginName: user.login,
        avatarURL: user.avatarURL,
        githubURL: user.htmlURL,
        accountType: user.type,
        siteAdmin: user.siteAdmin,
        isFavourite: user.isFavourite
      )
    })
  }
  
  func presentGithubUsersLoading() {
    let viewModel = GithubuserList.GetUser.ViewModel(content: Content.loading)
    viewController.displayGithubUsers(viewModel: viewModel)
  }
}
