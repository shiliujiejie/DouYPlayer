
import UIKit
import SnapKit

class NicooLoadedFailedView: UIView {
    
    static let notNetwork = "加载失败,请检查网络设置!"
    static let resUnavailable = "连接超时,需重新获取视频!"
    static let noPermission = "您今日观看次数已用完了, 赶快去充值/分享App吧!"
    
    var loadFailedTitle: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.text = NicooLoadedFailedView.notNetwork
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = UIColor.white
        lable.numberOfLines = 3
        return lable
    }()
    var retryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("点击重试", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.cornerRadius = 19
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(red:0/255.0, green: 123/255.0, blue:  255/255.0, alpha: 0.95)
        button.addTarget(self, action: #selector(retryButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    var reFetchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("重新获取", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.cornerRadius = 19
        button.layer.masksToBounds = true
        button.isHidden = true
        button.backgroundColor = UIColor(red:0/255.0, green: 123/255.0, blue:  255/255.0, alpha: 0.95)
        button.addTarget(self, action: #selector(reFetchButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    var goChrageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("去充值VIP", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.cornerRadius = 19
        button.layer.masksToBounds = true
        button.isHidden = true
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.cornerRadius = 19
        button.layer.masksToBounds = true
        button.isHidden = true
        button.backgroundColor = UIColor(red: 0/255.0, green: 123/255.0, blue:  255/255.0, alpha: 0.95)
        button.addTarget(self, action: #selector(goShareButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    var retryButtonClickBlock: ((_ sender: UIButton) ->())?
    var reFetchButtonClickBlock: ((_ sender: UIButton) ->())?
    var goChrageButtonClickBlock: ((_ sender: UIButton) ->())?
    var goShareButtonClickBlock: ((_ sender: UIButton) ->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius  = 5
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
        self.loadUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadUI() {
        addSubview(loadFailedTitle)
        addSubview(retryButton)
        addSubview(reFetchButton)
        addSubview(goChrageButton)
        addSubview(goShareButton)
        layoutAllSubviews()
    }
    
    @objc func retryButtonClick(_ sender: UIButton) {
        if retryButtonClickBlock != nil {
            retryButtonClickBlock!(sender)
        }
        self.removeFromSuperview()
    }
    @objc func reFetchButtonClick(_ sender: UIButton) {
        if reFetchButtonClickBlock != nil {
            reFetchButtonClickBlock!(sender)
        }
        self.removeFromSuperview()
    }
    
    @objc func goChrageButtonClick(_ sender: UIButton) {
        if goChrageButtonClickBlock != nil {
            goChrageButtonClickBlock!(sender)
        }
        self.removeFromSuperview()
    }
    @objc func goShareButtonClick(_ sender: UIButton) {
        if goShareButtonClickBlock != nil {
            goShareButtonClickBlock!(sender)
        }
        self.removeFromSuperview()
    }
    fileprivate func layoutAllSubviews() {
        loadFailedTitle.snp.makeConstraints { (make) in
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
        goChrageButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.snp.centerX).offset(-10)
            make.centerY.equalToSuperview().offset(25)
            make.height.equalTo(38)
            make.width.equalTo(120)
        }
        goShareButton.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.centerX).offset(10)
            make.centerY.equalToSuperview().offset(25)
            make.height.equalTo(38)
            make.width.equalTo(120)
        }
    }
    
}
