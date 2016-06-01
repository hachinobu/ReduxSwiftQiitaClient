// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift

import Foundation
import Rswift
import UIKit

/// This `R` struct is code generated, and contains references to static resources.
struct R {
  /// This `R.color` struct is generated, and contains static references to 0 color palettes.
  struct color {
    private init() {}
  }
  
  /// This `R.file` struct is generated, and contains static references to 1 files.
  struct file {
    /// Resource file `Secrets.plist`.
    static let secretsPlist = FileResource(bundle: _R.hostingBundle, name: "Secrets", pathExtension: "plist")
    
    /// `bundle.URLForResource("Secrets", withExtension: "plist")`
    static func secretsPlist(_: Void) -> NSURL? {
      let fileResource = R.file.secretsPlist
      return fileResource.bundle.URLForResource(fileResource)
    }
    
    private init() {}
  }
  
  /// This `R.font` struct is generated, and contains static references to 0 fonts.
  struct font {
    private init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 0 images.
  struct image {
    private init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 0 nibs.
  struct nib {
    private init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 3 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `ArticleDetailBodyCell`.
    static let articleDetailBodyCell: ReuseIdentifier<ArticleDetailBodyCell> = ReuseIdentifier(identifier: "ArticleDetailBodyCell")
    /// Reuse identifier `ArticleDetailTopInfoCell`.
    static let articleDetailTopInfoCell: ReuseIdentifier<ArticleDetailTopInfoCell> = ReuseIdentifier(identifier: "ArticleDetailTopInfoCell")
    /// Reuse identifier `ArticleListCell`.
    static let articleListCell: ReuseIdentifier<ArticleListCell> = ReuseIdentifier(identifier: "ArticleListCell")
    
    private init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 0 view controllers.
  struct segue {
    private init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 3 storyboards.
  struct storyboard {
    /// Storyboard `ArticleDetail`.
    static let articleDetail = _R.storyboard.articleDetail()
    /// Storyboard `ArticleList`.
    static let articleList = _R.storyboard.articleList()
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    
    /// `UIStoryboard(name: "ArticleDetail", bundle: ...)`
    static func articleDetail(_: Void) -> UIStoryboard {
      return UIStoryboard(resource: R.storyboard.articleDetail)
    }
    
    /// `UIStoryboard(name: "ArticleList", bundle: ...)`
    static func articleList(_: Void) -> UIStoryboard {
      return UIStoryboard(resource: R.storyboard.articleList)
    }
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void) -> UIStoryboard {
      return UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    private init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 0 localization tables.
  struct string {
    private init() {}
  }
  
  private init() {}
}

struct _R {
  static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(NSLocale.init) ?? NSLocale.currentLocale()
  static let hostingBundle = NSBundle(identifier: "com.hachinobu.ReduxSwiftQiitaClient") ?? NSBundle.mainBundle()
  
  struct nib {
    private init() {}
  }
  
  struct storyboard {
    struct articleDetail: StoryboardResourceWithInitialControllerType {
      typealias InitialController = UITableViewController
      
      let bundle = _R.hostingBundle
      let name = "ArticleDetail"
      
      private init() {}
    }
    
    struct articleList: StoryboardResourceWithInitialControllerType {
      typealias InitialController = UINavigationController
      
      let bundle = _R.hostingBundle
      let name = "ArticleList"
      
      private init() {}
    }
    
    struct launchScreen: StoryboardResourceWithInitialControllerType {
      typealias InitialController = UIViewController
      
      let bundle = _R.hostingBundle
      let name = "LaunchScreen"
      
      private init() {}
    }
    
    private init() {}
  }
  
  private init() {}
}