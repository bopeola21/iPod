import UIKit



private let inWheelRadius: CGFloat = 0.32
private let outWheelRadius: CGFloat = 0.35
//private let inWheelRadius: CGFloat = 0.25
//private let outWheelRadius: CGFloat = 0.50
private let clickThreshold: CGFloat = 0.1
private let padding: CGFloat = 14
private let buttonSize = CGSize(width: 20, height: 12.5)

protocol ClickWheelViewDelegate: class {
    func clickWheelBegan(value: Int)
    func clickWheelValue(value: Int)
    func clickWheelEnded(value: Int)
    func clickWheelDidScroll(scrolled: Bool)
    func playPauseSelected()
    func inButtonSelected()
    func fastForwardSelected()
    func rewindSelected()
    func menuSelected()
}

extension ClickWheelViewDelegate {
    func clickWheelDidScroll(scrolled: Bool){}
}

//
//
//@IBDesignable
//class iPodNavigationBar: UIView {
//

    

//@IBDesignable
class ClickWheelView: UIView {
    
//    @IBInspectable var wheelColor: UIColor = .black
//    @IBInspectable var textColor: UIColor?
    var wheelColor: UIColor = .black
    var textColor: UIColor?
    var playPauseImageView: UIImageView!
    var fastForwardImageView: UIImageView!
    var rewindImageView: UIImageView!
    var menuLabel: UILabel!
    var scrollMaxValue = Int.max

    
    var ppRect: CGRect!
    var rRect: CGRect!
    var fButtonRect: CGRect!
    var textrect: CGRect!
    var inrect: CGRect!
    var clickViewSingleton = ClickViewSingleton.shared
    var viewDidScroll = false

    override func draw(_ rect: CGRect) {
        let t = min(rect.height, rect.width)
        let outrect = CGRect(x: 0, y: 0, width: t, height: t)
        inrect = CGRect(x: (t * inWheelRadius), y: (t * inWheelRadius), width: (t * outWheelRadius), height: (t * outWheelRadius))
        let outpath = UIBezierPath(ovalIn: outrect)
        let inpath = UIBezierPath(ovalIn: inrect)
        
        let newColor = UIColor(red:0.14, green:0.14, blue:0.14, alpha:1.0)
        newColor.setFill()
        outpath.fill()
        UIColor.black.setFill()
        inpath.fill()

//        let s = NSString.init(string: "\(value)%")
//        let attr1: [NSAttributedString.Key  : Any] = [
//            .font : UIFont(name: "Helvetica", size: 20)!,
//            .foregroundColor : textColor ?? wheelColor
//        ]
//        let textSize1 = s.size(withAttributes: attr1)
//        let textH1 = textSize1.height
//        let textW1 = textSize1.width
//        let textrect1 = CGRect(x: (t-textW1)/2, y: (t-textH1)/2, width: textW1, height: textH1)
//        s.draw(in: textrect1, withAttributes: attr1)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture(tap:)))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)

        ppRect = CGRect(x: bounds.midX - buttonSize.width / 2, y: bounds.maxY - buttonSize.height - padding, width: buttonSize.width, height: buttonSize.height)
        playPauseImageView = UIImageView(frame: ppRect)
        playPauseImageView.image = #imageLiteral(resourceName: "play_pause.pdf")
        addSubview(playPauseImageView)

        rRect = CGRect(x: padding, y: bounds.midY - (buttonSize.height / 2), width: buttonSize.width, height: buttonSize.height)
        rewindImageView = UIImageView(frame: rRect)
        rewindImageView.image = #imageLiteral(resourceName: "rewind.pdf")
        addSubview(rewindImageView)

        fButtonRect = CGRect(x: bounds.maxX - buttonSize.width - padding, y: bounds.midY - (buttonSize.height / 2), width: buttonSize.width, height: buttonSize.height)
        fastForwardImageView = UIImageView(frame: fButtonRect)
        fastForwardImageView.image = #imageLiteral(resourceName: "fastforward.pdf")
        addSubview(fastForwardImageView)


        let attr: [NSAttributedString.Key  : Any] = [
            .font : UIFont(name: "Helvetica", size: 15)!,
            NSAttributedString.Key.kern : 2,
            .foregroundColor : UIColor.white
        ]

        let attrString = NSAttributedString(string: "MENU", attributes: attr)
        let textSize = attrString.size()
        let textH = textSize.height
        let textW = textSize.width
        textrect = CGRect(x: bounds.midX - (textW / 2), y: padding, width: textW, height: textH)
        menuLabel = UILabel(frame: textrect)
        menuLabel.attributedText = attrString
        addSubview(menuLabel)
    }
    
    
    var feedbackGenerator: UISelectionFeedbackGenerator? = nil
    var curAngle: CGFloat = .nan
    var value: Int = 0
    func getAngle(touch: UITouch) -> CGFloat? {
        let t = min(frame.height, frame.width)
        let point = touch.location(in: self)
        let x = point.x - t/2
        let y = point.y - t/2
        let dist = sqrt(x*x + y*y)
        let ans = t*0.25 < dist && dist < t*0.50 ? atan2(x, y) : nil
        return ans
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO: Multitouch
        guard let touch = touches.first else {
            return
        }
        feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator?.prepare()
        if let a = getAngle(touch: touch) {
            curAngle = a
        }
        clickViewSingleton.delegate?.clickWheelBegan(value: value)
        saveStartTap = touch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        if let a = getAngle(touch: touch) {
            if abs(a - curAngle) > clickThreshold {
                if a - curAngle > .pi {
                    curAngle += 4 * .pi
                }
                else if curAngle - a > .pi {
                    curAngle -= 4 * .pi
                }
                let newValue = max(-scrollMaxValue, min(scrollMaxValue, value + Int((curAngle-a) / clickThreshold)))
                curAngle = a
                if newValue != value {
                    value = newValue
                    feedbackGenerator?.selectionChanged()
                    feedbackGenerator?.prepare()
                    //setNeedsDisplay()
                }
                
                clickViewSingleton.delegate?.clickWheelValue(value: value)
                viewDidScroll = true
            }
        }
        
        if !containsKeyPoint(touch.location(in: self)) {
            saveStartTap = nil
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        feedbackGenerator = nil
        curAngle = .nan
        clickViewSingleton.delegate?.clickWheelDidScroll(scrolled: viewDidScroll)
        clickViewSingleton.delegate?.clickWheelEnded(value: value)
        viewDidScroll = false
    }
    
    func containsKeyPoint(_ point: CGPoint) -> Bool {
        if extendRect(ppRect).contains(point) ||
            extendRect(rRect).contains(point) ||
            extendRect(fButtonRect).contains(point) ||
            extendRect(textrect).contains(point) ||
            inrect.contains(point) {
            return true
        }

        return false
    }
    
    var saveStartTap: CGPoint?
    
    @objc func handleGesture(tap: UITapGestureRecognizer) {
        let point = tap.location(in: self)

        guard let startTap = saveStartTap,
            tap.state == .ended else { return }
        
        saveStartTap = nil
        
        var fireFeedBack = false
        
        if extendRect(ppRect).contains(point) && extendRect(ppRect).contains(startTap) {
            clickViewSingleton.delegate?.playPauseSelected()
            fireFeedBack = true
        }
        
        if extendRect(rRect).contains(point) && extendRect(rRect).contains(startTap) {
            clickViewSingleton.delegate?.rewindSelected()
            fireFeedBack = true
        }
        
        if extendRect(fButtonRect).contains(point) && extendRect(fButtonRect).contains(startTap) {
            clickViewSingleton.delegate?.fastForwardSelected()
            fireFeedBack = true
        }
        
        if extendRect(textrect).contains(point) && extendRect(textrect).contains(startTap) && clickViewSingleton.buttonIsEnabled {
            clickViewSingleton.delegate?.menuSelected()
            fireFeedBack = true
        }
        
        if inrect.contains(point) && inrect.contains(startTap) && clickViewSingleton.buttonIsEnabled {
            clickViewSingleton.delegate?.inButtonSelected()
            fireFeedBack = true
        }
        
        if fireFeedBack {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred()
        }
        
    }
    
    func extendRect(_ rect: CGRect) -> CGRect {
        var newRect = rect
        
        // more room for tap
        newRect.origin.y = rect.origin.y - 10
        newRect.origin.x = rect.origin.x - 10

        newRect.size.width *= 2.5
        newRect.size.height *= 4
        return newRect
    }
}


private let _shared: ClickViewSingleton = ClickViewSingleton()

class ClickViewSingleton {
    public class var shared: ClickViewSingleton {
      return _shared
    }
    
    weak var delegate: ClickWheelViewDelegate?
    var buttonIsEnabled = true
}
