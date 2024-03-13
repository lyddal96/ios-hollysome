//
//  AccountBookViewController.swift
//  hollysome
//
//  Created by 이승아 on 2023/08/09.
//
//

import UIKit
import ExpyTableView
import Defaults
import GoogleMobileAds

class AccountBookViewController: BaseViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var enrollBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var accountBookTableView: ExpyTableView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var currentList: AccountBookModel?
  var bookRequest = AccountBookModel()
  var lastList = [AccountBookModel]()
  
  let refresh = UIRefreshControl()
  let normalTitles = ["가스", "수도세", "전기세"]
  
  private var rewardedAd: GADRewardedAd?
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    self.notificationCenter.addObserver(self, selector: #selector(self.bookUpdate), name: Notification.Name("BookUpdate"), object: nil)
    self.accountBookTableView.registerCell(type: AccountBookCell.self)
    self.accountBookTableView.registerCell(type: AccountBookEmptyCell.self)
    self.accountBookTableView.registerCell(type: AccountBookTitleCell.self)
    self.accountBookTableView.registerCell(type: LastAccountBookCell.self)
    self.accountBookTableView.registerCell(type: LastAccountBookDetailCell.self)
    self.accountBookTableView.delegate = self
    self.accountBookTableView.dataSource = self

    self.accountBookTableView.indicatorStyle = .white
    self.accountBookTableView.showsVerticalScrollIndicator = false
    self.refresh.addTarget(self, action: #selector(self.bookUpdate), for: .valueChanged)
    self.accountBookTableView.refreshControl = self.refresh
    
    self.callbackAd()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
  }
  
  override func initRequest() {
    super.initRequest()
    
  }
  
  override func initLocalize() {
    super.initLocalize()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.bookViewAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 당월 가계부 API
  func bookViewAPI() {
    let bookRequest = AccountBookModel()
    bookRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: .book_view, method: .post, parameters: bookRequest.toJSON()) { response in
      if let bookResponse = AccountBookModel(JSON: response), Tools.shared.isSuccessResponse(response: bookResponse) {
        if bookResponse.code == "1000" {
          self.currentList = bookResponse
          self.enrollBarButtonItem.image = UIImage(named: "modify_btn")
        } else {
          self.currentList = nil
          self.enrollBarButtonItem.image = UIImage(named: "write_btn")
        }
        
        self.accountBookTableView.reloadData()
        
        self.refresh.endRefreshing()
        
        self.lastList.removeAll()
        self.bookRequest.resetPage()
        self.bookListAPI()
      }
    }
  }
  /// 전체 가계부 리스트 API
  func bookListAPI() {
    self.bookRequest.house_code = Defaults[.house_code]
//    self.bookRequest.house_code = "no22491610re"
    self.bookRequest.setNextPage()
    
    APIRouter.shared.api(path: .book_list, method: .post, parameters: bookRequest.toJSON()) { response in
      if let bookResponse = AccountBookModel(JSON: response), Tools.shared.isSuccessResponse(response: bookResponse) {
        self.isLoadingList = true
        self.bookRequest.total_page = bookResponse.total_page
        if let data_array = bookResponse.data_array, data_array.count > 0 {
          self.lastList += data_array
        }
        
        self.accountBookTableView.reloadData()
      }
    }
  }
  
  /// 새로고침
  @objc func bookUpdate() {
    self.bookRequest.resetPage()
    self.lastList.removeAll()
    self.currentList = nil
    self.bookViewAPI()
  }
  
  
  func callbackAd() {
    let request = GADRequest()
    GADRewardedAd.load(withAdUnitID:"ca-app-pub-3940256099942544/1712485313",
                       request: request,
                       completionHandler: { [self] ad, error in
      if let error = error {
        print("Failed to load rewarded ad with error: \(error.localizedDescription)")
        return
      }
      rewardedAd = ad
      print("Rewarded ad loaded.")
      rewardedAd?.fullScreenContentDelegate = self
      
    }
    )
  }

  func loadRewardedAd(divideRequest: AccountBookModel) {
    
    if let ad = rewardedAd {
      ad.present(fromRootViewController: self) {
        let reward = ad.adReward
        print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
        // TODO: Reward the user.
        
        
        self.callbackAd()
        APIRouter.shared.api(path: .book_alarm, method: .post, parameters: divideRequest.toJSON()) { request in
          if let bookRequest = AccountBookModel(JSON: request), Tools.shared.isSuccessResponse(response: bookRequest) {
            
          }
        }
        GADMobileAds().initializationStatus
      }
    } else {
      print("Ad wasn't ready")
    }
    
   }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 작성
  /// - Parameter sender: 버튼
  @IBAction func enrollBarButtonItemTouched(sender: UIButton) {
    let destination = RegAccountBookViewController.instantiate(storyboard: "AccountBook")
    if let currentList = self.currentList, self.currentList?.book_idx != nil {
      destination.bookData = currentList
      destination.enrollType = .modify
    }
    destination.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(destination, animated: true)
  }
}


//-------------------------------------------------------------------------------------------
// MARK: - ExpyTableViewDataSource
//-------------------------------------------------------------------------------------------
extension AccountBookViewController: ExpyTableViewDataSource {
  func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
    if section == 0 && !self.currentList.isNil {
      return false
    }
    return true
  }
  
  func canExpand(section: Int, inTableView tableView: ExpyTableView) -> Bool {
    return false
  }
  
  // 상위데이터
  func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
    let emptyCell = tableView.dequeueReusableCell(withIdentifier: "AccountBookEmptyCell") as! AccountBookEmptyCell
    let titleCell = tableView.dequeueReusableCell(withIdentifier: "AccountBookTitleCell") as! AccountBookTitleCell
    if section == 0 {
      if self.currentList.isNil {
        emptyCell.emptyLabel.text = "이번 달 가계부 내역이 없습니다.\n지금 바로 작성해보세요!"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월"
        emptyCell.titleLabel.text = dateFormatter.string(from: Date())
        return emptyCell
      } else {
        titleCell.backgroundColor = UIColor(named: "FFFFFF")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월"
        titleCell.titleLabel.text = dateFormatter.string(from: Date())
        return titleCell
      }
    } else if section == 1 {
      titleCell.backgroundColor = UIColor(named: "FAFAFC")
      titleCell.titleLabel.text = "전체 가계부"
      return titleCell
    } else {
      if self.lastList.count == 0 {
        emptyCell.emptyLabel.text = "작성 된 가계부가\n없습니다."
        return emptyCell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LastAccountBookCell") as! LastAccountBookCell
        let book = self.lastList[section - 2]
        cell.monthLabel.text = book.month ?? ""
        var total = (book.book_item_1?.toInt() ?? 0) + (book.book_item_2?.toInt() ?? 0) + (book.book_item_3?.toInt() ?? 0)
        if let detail_list = book.item_list, detail_list.count > 0 {
          for value in detail_list {
            total += value.item_bill?.toInt() ?? 0
          }
        }
        cell.priceLabe.text = "\(Tools.shared.numberPlaceValue("\(total)")) 원"
        cell.isLast = section - 1 == self.lastList.count
        cell.section = section
        let data = self.lastList[section - 2]
        cell.dataCnt = (data.item_list?.count ?? 0)
        
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
      }
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
//    var sectionCnt = 1
//    if self.currentList == 0 {
//      sectionCnt += 1
//    } else {
//      sectionCnt += self.currentList + 1
//    }
//    if self.lastList == 0 {
//      sectionCnt += 1
//    } else {
//      sectionCnt += self.lastList
//    }
    if self.lastList.count == 0 {
      return 3
    } else {
      return 2 + self.lastList.count
    }
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      if self.currentList.isNil {
        return 1
      } else {
        return (self.currentList?.detail_list?.count ?? 0) + 4
      }
      
    } else if section == 1 {
      return 1
    } else {
      if self.lastList.count == 0 {
        return 1
      } else {
        let data = self.lastList[section - 2]
        return (data.item_list?.count ?? 0) + 4
      }
    }
    //    }
  }
  
  
  
  // 하위 데이터
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      if indexPath.row == 0 {
        let titleCell = tableView.dequeueReusableCell(withIdentifier: "AccountBookTitleCell") as! AccountBookTitleCell
        titleCell.backgroundColor = UIColor(named: "FFFFFF")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월"
        titleCell.titleLabel.text = dateFormatter.string(from: Date())
        return titleCell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountBookCell", for: indexPath) as! AccountBookCell
    //    cell.parentsViewController = self
        cell.totalView.isHidden = indexPath.row != (self.currentList?.detail_list?.count ?? 0) + 3
        cell.titleLabel.text = indexPath.row < 4 ? self.normalTitles[indexPath.row - 1] : self.currentList?.detail_list?[indexPath.row - 4].item_name ?? ""
        var data = AccountBookModel()
        data.item_name = indexPath.row < 4 ? self.normalTitles[indexPath.row - 1] : self.currentList?.detail_list?[indexPath.row - 4].item_name ?? ""
        if indexPath.row < 4 {
          cell.priceLabel.text = "\(Tools.shared.numberPlaceValue(indexPath.row == 1 ? self.currentList?.book_item_1 ?? "0" : indexPath.row == 2 ? self.currentList?.book_item_2 ?? "0" : self.currentList?.book_item_3 ?? "0" )) 원"
          data.item_price = indexPath.row == 1 ? self.currentList?.book_item_1 ?? "0" : indexPath.row == 2 ? self.currentList?.book_item_2 ?? "0" : self.currentList?.book_item_3 ?? "0"
        } else {
          cell.priceLabel.text = "\(Tools.shared.numberPlaceValue(self.currentList?.detail_list?[indexPath.row - 4].item_bill ?? "0")) 원"
          data.item_price = self.currentList?.detail_list?[indexPath.row - 4].item_bill ?? "0"
        }
        if indexPath.row == (self.currentList?.detail_list?.count ?? 0) + 3 {
          var total = (self.currentList?.book_item_1?.toInt() ?? 0) + (self.currentList?.book_item_2?.toInt() ?? 0) + (self.currentList?.book_item_3?.toInt() ?? 0)
          if let detail_list = self.currentList?.detail_list, detail_list.count > 0 {
            for value in detail_list {
              total += value.item_bill?.toInt() ?? 0
            }
          }
          cell.totalPriceLabel.text = "\(Tools.shared.numberPlaceValue("\(total)")) 원"
        }
        /// 나누기
        cell.divideButton.addTapGesture { recognizer in
          let destination = DividePopupViewController.instantiate(storyboard: "AccountBook")
          destination.delegate = self
          destination.bookData = data
          destination.modalTransitionStyle = .crossDissolve
          destination.modalPresentationStyle = .overCurrentContext
//          self.present(destination, animated: false, completion: nil)
          self.tabBarController?.present(destination, animated: true)
        }
        
        return cell
      }
      
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "LastAccountBookDetailCell", for: indexPath) as! LastAccountBookDetailCell
  //    cell.parentsViewController = self
      let book = self.lastList[indexPath.section - 2]
      if indexPath.row < 4 {
        cell.titleLabel.text = indexPath.row < 4 ? self.normalTitles[indexPath.row - 1] : self.currentList?.detail_list?[indexPath.row - 4].item_name ?? ""
        cell.priceLabel.text = "\(Tools.shared.numberPlaceValue(indexPath.row == 1 ? book.book_item_1 : indexPath.row == 2 ? book.book_item_2 : book.book_item_3)) 원"
      } else {
        cell.titleLabel.text = book.item_list?[indexPath.row - 4].item_name ?? ""
        cell.priceLabel.text = "\(Tools.shared.numberPlaceValue(book.item_list?[indexPath.row - 4].item_bill ?? "")) 원"
      }
      
      return cell
    }
    
  }
  
  
}

//-------------------------------------------------------------------------------------------
// MARK: - ExpyTableViewDelegate
//-------------------------------------------------------------------------------------------
extension AccountBookViewController: ExpyTableViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == self.accountBookTableView {
      let currentOffset = scrollView.contentOffset.y
      let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
      
      if maximumOffset - currentOffset <= 10.0 {
        if self.bookRequest.isMore() {
          self.isLoadingList = false
          self.bookListAPI()
        }
      }
    }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
    
    switch state {
    case .willExpand:
      break
    case .willCollapse:
      break
    case .didExpand:
      break
    case .didCollapse:
      break
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - DivideDelegate
//-------------------------------------------------------------------------------------------
extension AccountBookViewController: DivideDelegate {
  func divideDelegate(divideData: AccountBookModel) {
    self.loadRewardedAd(divideRequest: divideData)
  }
}


//-------------------------------------------------------------------------------------------
// MARK: - GADFullScreenContentDelegate
//-------------------------------------------------------------------------------------------
extension AccountBookViewController: GADFullScreenContentDelegate {

  /// Tells the delegate that the ad failed to present full screen content.
  func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
    print("Ad did fail to present full screen content.")
  }

  /// Tells the delegate that the ad will present full screen content.
  func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("Ad will present full screen content.")
  }

  /// Tells the delegate that the ad dismissed full screen content.
  func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("Ad did dismiss full screen content.")

  }
  
  
}
