import UIKit

protocol GithubuserListInteractorInterface {
  func getGithubUsers(request: GithubuserList.GetUser.Request)
  func favouriteUsers(request: GithubuserList.FavouriteUser.Request)
  var githubUsers: [GithubUser] { get }
}

class GithubuserListInteractor: GithubuserListInteractorInterface {
  var presenter: GithubuserListPresenterInterface!
  var worker: GithubuserListWorker?
  var githubUsers = [GithubUser]()
  var page: Int = 1

  // MARK: - Business logic

  func getGithubUsers(request: GithubuserList.GetUser.Request) {
    presenter.presentGithubUsersLoading()
    page = calculatePage(type: request.type, page: page)
    worker?.getGithubUsers(page: page) { [weak self] result in
      guard let strongSelf = self else {
        let response = GithubuserList.GetUser.Response(result: Result.failure)
        self?.presenter.presentGithubUsers(response: response)
        return
      }
      switch result {
        case .success(let data):
          let users = strongSelf.combineData(
            type: request.type,
            oldData: strongSelf.githubUsers,
            data: data
          )
          
          strongSelf.githubUsers = users
          let response = GithubuserList.GetUser.Response(result: Result.success(users))
          self?.presenter.presentGithubUsers(response: response)
        case .failure:
          let response = GithubuserList.GetUser.Response(result: Result.failure)
          self?.presenter.presentGithubUsers(response: response)
      }
    }
  }
  
  func favouriteUsers(request: GithubuserList.FavouriteUser.Request) {
    githubUsers[request.index].isFavourite = !githubUsers[request.index].isFavourite
    presenter.presentFavouriteUsers(response: GithubuserList.FavouriteUser.Response(result: githubUsers))
  }
  
  private func calculatePage(type: FetchType, page: Int) -> Int {
    switch type {
      case .refresh:
        return page
      case .loadmore:
        return page + 1
    }
  }
  
  private func combineData(
    type: FetchType,
    oldData: [GithubUser],
    data: [GithubUser]
  ) -> [GithubUser] {
    
    switch type {
      case .refresh:
        return data
      case .loadmore:
        return oldData + data
    }
  }
}
