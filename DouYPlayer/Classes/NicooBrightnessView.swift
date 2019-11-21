

import UIKit
import SnapKit

extension UINavigationController { // 用于状态栏的显示，样式
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        guard let vc = self.viewControllers.last else { return UIStatusBarStyle.default }
        return vc.preferredStatusBarStyle
    }
}

class NicooBrightnessView: UIView {
    
    lazy var brightnessImage: UIImageView = {
        let imageV = UIImageView(image: NicooImgManager.foundImage(imageName: "player_brightness"))
        return imageV
    }()
    lazy var titleLab: UILabel = {
        let lable = UILabel(frame: CGRect(x: 0, y: 5, width: self.bounds.size.width, height: 25))
        lable.font = UIFont.boldSystemFont(ofSize: 17)
        lable.tintColor = UIColor.white
        lable.textAlignment = .center
        lable.text = "亮度"
        return lable
    }()
    lazy var fakeSliderBackView: UIView = {
        let view = UIView(frame: CGRect(x: 12, y: 132, width: self.bounds.size.width - 24, height: 7))
        view.backgroundColor = UIColor.darkText
        return view
    }()
    lazy var tipsViewArray: [UIView] = {
        let tips = [UIView]()
        return tips
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius  = 10
        self.layer.masksToBounds = true
        self.loadUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func loadUI() {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 155, height: 155))
        toolBar.alpha = 0.95
        self.addSubview(toolBar)
        self.addSubview(titleLab)
        self.addSubview(brightnessImage)
        self.addSubview(fakeSliderBackView)
        self.layoutAllSubviews()
        self.createTipsViews()
        
    }
    fileprivate func createTipsViews() {
        let tipWidth = (fakeSliderBackView.bounds.size.width - 17.0)/16.0 // 每个TIPS间隔1
        let tipHight = 5
        // let tipY = 1
        for index in 0..<17 {
            let tipsX = CGFloat(index) * (tipWidth + 1) + 1
            let tipsView = UIView()
            tipsView.backgroundColor = UIColor.white
            self.fakeSliderBackView.addSubview(tipsView)
            self.tipsViewArray.append(tipsView)
            tipsView.snp.makeConstraints { (make) in
                make.leading.equalTo(tipsX)
                make.centerY.equalToSuperview()
                make.width.equalTo(tipWidth)
                make.height.equalTo(tipHight)
            }
        }
        self.updateBrightness(UIScreen.main.brightness)
        
    }
    
    
    func updateBrightness(_ value: CGFloat) {
        let stage = 1.0/15.0
        let level = value / CGFloat(stage)
        for index in 0..<self.tipsViewArray.count {
            let tipsView = self.tipsViewArray[index]
            if index <= Int(level) {
                tipsView.isHidden = false
            }else {
                tipsView.isHidden = true
            }
        }
    }
    fileprivate func layoutAllSubviews() {
        titleLab.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(5)
            make.height.equalTo(26)
        }
        brightnessImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(79)
            make.height.equalTo(76)
        }
        fakeSliderBackView.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.trailing.equalTo(-12)
            make.bottom.equalTo(-15)
            make.height.equalTo(7)
        }
    }
}

class CustomSlider: UISlider {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.minimumValue = 0
        self.maximumValue = 1
        self.value = 0
        self.minimumTrackTintColor = .clear
        self.maximumTrackTintColor = .clear
        self.thumbTintColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //修改slider的位置和大小
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 6, width: self.frame.size.width, height: 6)
    }
    //修改圆点图标的位置和触摸区域的大小
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        var trect = rect
        //NLog("thumbRect == \(trect)")
        trect.origin.x -= 2
        trect.size.width += 4
        var srect = super.thumbRect(forBounds: bounds, trackRect: trect, value: value)
        srect.origin.y = 5
        srect.size.height = 9
        //NLog("srectRect == \(srect)")
        return srect
    }
    //    //处理手势冲突
    //    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    //        return false
    //    }
    
}

class ZanAnimation: NSObject {
    
    static let angleArr: [CGFloat] = [CGFloat.pi / 4.0, -CGFloat.pi / 4.0, 0.0]
    
    static func showAnimation(point: CGPoint, baseView: UIView, size: CGFloat) {
        
        let imgV = UIImageView.init(frame: CGRect.init(x: point.x - size / 2.0, y: point.y - size / 2.0, width: size, height: size))
        imgV.image = NicooImgManager.foundImage(imageName: "zanImage")
        imgV.contentMode = .scaleAspectFill
        imgV.alpha = 0.5
        baseView.addSubview(imgV)
        
        // 偏移角度
        let num = Int(arc4random_uniform(3))
        imgV.transform = CGAffineTransform.init(rotationAngle: ZanAnimation.angleArr[num])
        // 放大动画
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.duration = 0.15
        animation.calculationMode = CAAnimationCalculationMode.cubic
        animation.values = [1.3, 0.8, 1.0]
        imgV.layer.add(animation, forKey: "transform.scale")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            
            UIView.animate(withDuration: 0.5, animations: {
                imgV.alpha = 0.0
                var newFrame = imgV.frame
                newFrame.origin.x -= 5.0
                newFrame.origin.y -= 45.0
                newFrame.size.height += 10.0
                newFrame.size.width += 10.0
                imgV.frame = newFrame
            }, completion: { (isOK) in
                imgV.removeFromSuperview()
            })
        }
    }
}
