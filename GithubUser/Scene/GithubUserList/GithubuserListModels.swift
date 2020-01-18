import UIKit

struct GithubuserList {
  
  struct GetUser {
    
    struct Request {
      let type: FetchType
    }
    
    struct Response {
      let result: Result<[GithubUser]>
    }
    
    struct ViewModel {
      let content: Content<[GithubUserViewModel]>
    }
  }
  
  struct FavouriteUser {
    
    struct Request {
      let index: Int
    }
    
    struct Response {
      let result: [GithubUser]
    }
    
    struct ViewModel {
      let content: [GithubUserViewModel]
    }
  }
}
