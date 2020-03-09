
import UIKit
import SnapKit

public enum LoadFailedViewStyle {
    case Failed
    case ResUnavailable
    case NoPermission
    case CoinsVideo
}


class NicooLoadedFailedView: UIView {
    
    static let notNetwork = "加载失败,请检查网络设置!"
    static let resUnavailable = "连接超时,需重新获取视频!"
    static let noPermission = "您今日次数已用完了, 赶快去充值会员或分享App，观看完整版视频吧 😊"
    var loadFailView: NetWorkFailOrErrorView = {
        let view = NetWorkFailOrErrorView.init(frame: CGRect.zero)
        return view
    }()
    var vipTipsView: NotCountPlayTipView = {
        let view = NotCountPlayTipView.init(frame: CGRect.zero)
        return view
    }()
    var coinsTipsView: CoinTipView = {
        let view = CoinTipView.init(frame: CGRect.zero)
        return view
    }()
    
    var retryButtonClickBlock: (() ->())?
    var reFetchButtonClickBlock: (() ->())?
    var goChrageButtonClickBlock: (() ->())?
    var goShareButtonClickBlock: (() ->())?
    var goUploadButtonClickBlock: (() ->())?
    var goPayButtonClickBlock: ((_ canPay: Bool) ->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius  = 5
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        self.loadUI()
        self.addHandler()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadUI() {
        addSubview(loadFailView)
        addSubview(vipTipsView)
        addSubview(coinsTipsView)
        layoutAllSubviews()
    }
    
    /// 设置展示样式 showType: 1.失败 2.链接失效 3.没有次数 4.金币解锁
    ///
    /// - Parameter
    func setType(_ showType: LoadFailedViewStyle) {
        if showType == .Failed {
            vipTipsView.isHidden = true
            coinsTipsView.isHidden = true
            loadFailView.isHidden = false
            loadFailView.setErrorType(1)
        } else if showType == .ResUnavailable {
            vipTipsView.isHidden = true
            coinsTipsView.isHidden = true
            loadFailView.isHidden = false
            loadFailView.setErrorType(2)
        } else if showType == .NoPermission {
            vipTipsView.isHidden = false
            coinsTipsView.isHidden = true
            loadFailView.isHidden = true
        } else if showType == .CoinsVideo {
            vipTipsView.isHidden = true
            coinsTipsView.isHidden = false
            loadFailView.isHidden = true
        }
    }
    
    private func addHandler() {
        loadFailView.reFetchButtonClickBlock = { [weak self] in
            self?.reFetchButtonClickBlock?()
            self?.removeFromSuperview()
        }
        loadFailView.retryButtonClickBlock = { [weak self] in
            self?.retryButtonClickBlock?()
            self?.removeFromSuperview()
        }
        vipTipsView.goChrageButtonClickBlock = { [weak self] in
            self?.goChrageButtonClickBlock?()
        }
        vipTipsView.goShareButtonClickBlock = { [weak self] in
            self?.goShareButtonClickBlock?()
        }
        coinsTipsView.goPayButtonClickBlock = { [weak self] canPay in
            self?.goPayButtonClickBlock?(canPay)
        }
        coinsTipsView.goUploadButtonClickBlock = { [weak self] in
            self?.goUploadButtonClickBlock?()
        }
    }
    
    private func layoutAllSubviews() {
        loadFailView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        vipTipsView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        coinsTipsView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

/// 提示金币买视频 和 充值金币
class CoinTipView: UIView {
    
    var titleLabel: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.font = UIFont.boldSystemFont(ofSize: 15)
        lable.textColor = UIColor.white
        lable.numberOfLines = 2
        return lable
    }()
    var coinLabel: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.font = UIFont.boldSystemFont(ofSize: 24)
        lable.textColor = UIColor.white
        lable.numberOfLines = 1
        return lable
    }()
    var coinLeaseLabel: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.font = UIFont.boldSystemFont(ofSize: 15)
        lable.textColor = UIColor(white: 157/255.0, alpha: 1)
        lable.numberOfLines = 1
        return lable
    }()
    var goUploadButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("我要上传", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 19
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red: 0/255.0, green: 123/255.0, blue:  255/255.0, alpha: 1.0).cgColor
        button.setTitleColor(UIColor(red: 0/255.0, green: 123/255.0, blue:  255/255.0, alpha: 1.0), for: .normal)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(goUploadButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    var goPayButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("立即解锁", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 19
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(red: 0/255.0, green: 123/255.0, blue:  255/255.0, alpha: 0.95)
        button.addTarget(self, action: #selector(goPayButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    var goUploadButtonClickBlock: (() ->())?
    var goPayButtonClickBlock: ((_ canPay: Bool) ->())?
    
    /// 余额是否足够支付当前视频
    var canPay: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.loadUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func loadUI() {
        addSubview(titleLabel)
        addSubview(coinLabel)
        addSubview(coinLeaseLabel)
        addSubview(goUploadButton)
        addSubview(goPayButton)
        layoutAllSubviews()
    }
    @objc func goUploadButtonClick(_ sender: UIButton) {
        goUploadButtonClickBlock?()
    }
    @objc func goPayButtonClick(_ sender: UIButton) {
        goPayButtonClickBlock?(canPay)
    }
    
    func setCoinsModel(_ coins: CoinsVideoModel) {
        let tipsStr = "视频由抖友 <\(coins.userName)> 上传, 并设置 完整版 解锁价格:"
        titleLabel.attributedText = TextManager.getAttributeStringWithString(tipsStr, lineSpace: 6)
        coinLabel.text = "\(coins.videoCoins)金币"
        coinLeaseLabel.text = "我的金币: \(coins.coinsUserPacket)"
        if coins.coinsUserPacket >= coins.videoCoins {  // 金币足够，可以支付
            goPayButton.setTitle("立即解锁", for: .normal)
            canPay = true
        } else {
            goPayButton.setTitle("获取金币", for: .normal)
            canPay = false
        }
    }
    
    private func layoutAllSubviews() {
        goUploadButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.snp.centerX).offset(-10)
            make.centerY.equalToSuperview().offset(35)
            make.height.equalTo(38)
            make.width.equalTo(110)
        }
        goPayButton.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.centerX).offset(10)
            make.centerY.equalToSuperview().offset(35)
            make.height.equalTo(38)
            make.width.equalTo(110)
        }
        coinLeaseLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(goUploadButton.snp.top).offset(-15)
            make.height.equalTo(20)
        }
        coinLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(coinLeaseLabel.snp.top).offset(-6)
            make.height.equalTo(35)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(coinLabel.snp.top).offset(-10)
            make.width.equalTo(260)
            make.height.equalTo(45)
        }
    }
}

/// 网络问题，播放失败提示
class NetWorkFailOrErrorView: UIView {
    
    var titleLabel: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.text = NicooLoadedFailedView.notNetwork
        lable.font = UIFont.boldSystemFont(ofSize: 15)
        lable.textColor = UIColor.white
        lable.numberOfLines = 3
        return lable
    }()
    var retryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("点击重试", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 19
        button.backgroundColor = UIColor(red:0/255.0, green: 123/255.0, blue:  255/255.0, alpha: 0.95)
        button.addTarget(self, action: #selector(retryButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    var reFetchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("重新获取", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 19
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(red:0/255.0, green: 123/255.0, blue:  255/255.0, alpha: 0.95)
        button.addTarget(self, action: #selector(reFetchButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    var retryButtonClickBlock: (() ->())?
    var reFetchButtonClickBlock: (() ->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.loadUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadUI() {
        addSubview(titleLabel)
        addSubview(retryButton)
        addSubview(reFetchButton)
        layoutAllSubviews()
    }
    
    /// 1> 网络失败，重试 2> 重新拉取数据
    func setErrorType(_ type: Int) {
        if type == 1 {
            titleLabel.text = NicooLoadedFailedView.notNetwork
            retryButton.isHidden = false
            reFetchButton.isHidden = true
        } else if type == 2 {
            titleLabel.text = NicooLoadedFailedView.resUnavailable
            retryButton.isHidden = true
            reFetchButton.isHidden = false
        }
    }
    
    @objc func retryButtonClick(_ sender: UIButton) {
        if retryButtonClickBlock != nil {
            retryButtonClickBlock!()
        }
    }
    @objc func reFetchButtonClick(_ sender: UIButton) {
        if reFetchButtonClickBlock != nil {
            reFetchButtonClickBlock!()
        }
    }
    
    private func layoutAllSubviews() {
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-35)
            make.width.equalTo(260)
            make.height.equalTo(80)
        }
        retryButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(25)
            make.height.equalTo(38)
            make.width.equalTo(130)
        }
        reFetchButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(25)
            make.height.equalTo(38)
            make.width.equalTo(130)
        }
    }
}

/// 次数用完提醒
class NotCountPlayTipView: UIView {
    
    var titleLabel: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.attributedText = TextManager.getAttributeStringWithString(NicooLoadedFailedView.noPermission, lineSpace: 7)
        lable.font = UIFont.boldSystemFont(ofSize: 15)
        lable.textColor = UIColor.white
        lable.numberOfLines = 3
        return lable
    }()
    var goChrageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("充值会员", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 19
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red: 0/255.0, green: 123/255.0, blue:  255/255.0, alpha: 1.0).cgColor
        button.setTitleColor(UIColor(red: 0/255.0, green: 123/255.0, blue:  255/255.0, alpha: 1.0), for: .normal)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(goChrageButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    var goShareButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("去分享", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 19
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(red: 0/255.0, green: 123/255.0, blue:  255/255.0, alpha: 0.95)
        button.addTarget(self, action: #selector(goShareButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    var goChrageButtonClickBlock: (() ->())?
    var goShareButtonClickBlock: (() ->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.loadUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadUI() {
        addSubview(titleLabel)
        addSubview(goChrageButton)
        addSubview(goShareButton)
        layoutAllSubviews()
    }
    @objc func goChrageButtonClick(_ sender: UIButton) {
        goChrageButtonClickBlock?()
    }
    @objc func goShareButtonClick(_ sender: UIButton) {
        goShareButtonClickBlock?()
    }
    
    private func layoutAllSubviews() {
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-35)
            make.width.equalTo(260)
            make.height.equalTo(80)
        }
        goChrageButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.snp.centerX).offset(-10)
            make.centerY.equalToSuperview().offset(25)
            make.height.equalTo(38)
            make.width.equalTo(110)
        }
        goShareButton.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.centerX).offset(10)
            make.centerY.equalToSuperview().offset(25)
            make.height.equalTo(38)
            make.width.equalTo(110)
        }
    }
}
