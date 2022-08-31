import UIKit


public final class FloatingActionButtonView: UIView{
    public enum FabDirection {
        case left
        case right
    }
    struct ViewModel{
        var fabDirection: FabDirection = .left
        var fabCollapseImage: UIImage = UIImage()
        var fabExpandImage: UIImage = UIImage()
        var fabCollapseColor: UIColor = UIColor.yellow
        var fabExpandColor: UIColor = UIColor.black
        var btnLeftOrRightSpace: CGFloat = 30
        var btnBottom: CGFloat = -40
        var btnPadding: CGFloat = 5
        var btnSize: CGFloat = 50
        var lblTextSize: Double = 20
    }
    private var vm = ViewModel()
    private var isExpand: Bool = false
    private var views: [UIView] = []
    private var btns: [UIButton] = []
    private var lbls: [UILabel] = []
    private var bottomAnchors: [NSLayoutConstraint] = []
    private let customMaskView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public convenience init(fabDirection: FabDirection = .left, fabCollapseImage: UIImage, fabExpandImage: UIImage, fabCollapseColor: UIColor, fabExpandColor: UIColor, btnLeftOrRightSpace: CGFloat = 30, btnBottom: CGFloat = -40, btnPadding: CGFloat = 5, btnSize: CGFloat = 50, lblTextSize: Double = 20){
        self.init()
        initialMask()
        vm.fabDirection = fabDirection
        vm.fabCollapseImage = fabCollapseImage
        vm.fabExpandImage = fabExpandImage
        vm.fabCollapseColor = fabCollapseColor
        vm.fabExpandColor = fabExpandColor
        vm.btnLeftOrRightSpace = btnLeftOrRightSpace
        vm.btnBottom = btnBottom
        vm.btnPadding = btnPadding
        vm.btnSize = btnSize
        vm.lblTextSize = lblTextSize
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        guard !btns[0].frame.contains(location) && isExpand == true else { return } //位置不在FAB且FAB為展開時
        clickFAB(btns[0])
    }
    
    public func createFAB(image: UIImage, title: String? = nil, btnColor: UIColor, lblColor: UIColor = .black, target: Selector? = nil, atVC: Any? = nil){
        let index = views.count
        createView(index: index)
        createLabel(index: index, color: lblColor, title: title ?? "")
        createButton(image: image, index: index, color: btnColor,target: target, atVC: atVC)
    }
        
    public func collapseFAB(){
        guard isExpand == true else { return }
        clickFAB(btns[0])
    }
    
    private func createView(index: Int){
        let myView: UIView = UIView()
        views.insert(myView, at: index)
        let vi = views[index]
        
        if index != 0 {
            insertSubview(vi, belowSubview: views[index-1])
        }else{
            insertSubview(vi, at: 1)
        }
        vi.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
        bottomAnchors.insert(bottomConstraint, at: index)
        bottomAnchors[index] = vi.bottomAnchor.constraint(equalTo: bottomAnchor, constant: vm.btnBottom)
        NSLayoutConstraint.activate([vi.widthAnchor.constraint(equalTo: widthAnchor, constant: 0),
                                     vi.heightAnchor.constraint(equalToConstant: vm.btnSize),
                                     vi.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
                                     bottomAnchors[index]])
    }
    
    private func createButton(image: UIImage, index: Int, color: UIColor, target: Selector?, atVC: Any?){
        let button: UIButton = UIButton()
        btns.insert(button, at: index)
        let bi = btns[index]
        let vi = views[index]
        bi.setImage(image, for: .normal)
        bi.layer.cornerRadius = 25
        bi.backgroundColor = color
        
        vi.addSubview(bi)
        bi.translatesAutoresizingMaskIntoConstraints = false
        var lead: CGFloat = 0
        if vm.fabDirection == .left{
            lead = vm.btnLeftOrRightSpace
        }else{
            lead = UIScreen.main.bounds.size.width-vm.btnLeftOrRightSpace-vm.btnSize
        }
        NSLayoutConstraint.activate([bi.widthAnchor.constraint(equalToConstant: vm.btnSize),
                                     bi.heightAnchor.constraint(equalToConstant: vm.btnSize),
                                     bi.leadingAnchor.constraint(equalTo: vi.leadingAnchor, constant: lead),
                                     bi.bottomAnchor.constraint(equalTo: vi.bottomAnchor, constant: 0)])
        if index == 0{
            btns[0].addTarget(self, action: #selector(clickFAB(_:)), for: UIControl.Event.touchUpInside)
        }
        guard target != nil else { return }
        btns[index].addTarget(atVC, action: target ?? Selector(String()), for: UIControl.Event.touchUpInside)
    }
    
    private func createLabel(index: Int, color: UIColor, title: String){
        let label: UILabel = UILabel()
        lbls.insert(label, at: index)
        let li = lbls[index]
        let vi = views[index]
        li.text = title
        li.textColor = color
        li.font = UIFont.systemFont(ofSize: vm.lblTextSize)
        li.isHidden = true
        
        vi.addSubview(li)
        li.translatesAutoresizingMaskIntoConstraints = false
        var lblLeading: CGFloat = 55
        if vm.fabDirection == .left{
            lblLeading = vm.btnSize+vm.btnLeftOrRightSpace+5
            li.textAlignment = .left
        }else{
            lblLeading = -5-vm.btnLeftOrRightSpace
            li.textAlignment = .right
        }
        NSLayoutConstraint.activate([li.centerYAnchor.constraint(equalTo: vi.centerYAnchor, constant: 0),
                                     li.widthAnchor.constraint(equalTo: vi.widthAnchor, constant: -vm.btnSize),
                                     li.leadingAnchor.constraint(equalTo: vi.leadingAnchor, constant: lblLeading)])
    }
    
    @IBAction private func clickFAB (_ sender: UIButton){
        if sender.isSelected == false && sender == btns[0] { //即將展開
            customMaskView.isHidden=false //顯示customMaskView
            animationRotate(duration: 0.3, toValue: Double.pi, repeatCount: 1, btn:btns[0]) //順時針轉
            btns[0].setImage(vm.fabExpandImage, for: .normal) //按鈕樣式改展開時
            btns[0].backgroundColor = vm.fabExpandColor

            for i in 1 ..< views.count{ //顯示字、把button展開
                lbls[i].isHidden = false
                bottomAnchors[i].constant = bottomAnchors[i].constant-CGFloat(i)*(btns[0].frame.width+vm.btnPadding)
                let from = [views[0].frame.midX,views[0].frame.midY]
                let to = [views[0].frame.midX,views[0].frame.midY-CGFloat(i)*(btns[0].frame.width+vm.btnPadding)]
                animationPosition(duration: 0.3, fromValue: from, toValue: to, index: i)
            }
        }else{ //即將收回
            btns[0].setImage(vm.fabCollapseImage, for: .normal) //按鈕樣式改收回時
            btns[0].backgroundColor = vm.fabCollapseColor
            animationRotate(duration: 0.3, toValue: 0, repeatCount: -1, btn:btns[0]) //逆時針轉
            customMaskView.isHidden=true //隱藏customMaskView

            for i in 1 ..< views.count{ //把button收回、隱藏字
                bottomAnchors[i].constant = vm.btnBottom
                let from = [views[0].frame.midX,views[0].frame.midY-CGFloat(i)*(btns[0].frame.width+vm.btnPadding)]
                let to = [views[0].frame.midX,views[0].frame.midY]
                animationPosition(duration: 0.3, fromValue: from, toValue: to, index: i)
                lbls[i].isHidden = true
            }
        }
        btns[0].isSelected = !btns[0].isSelected //切換FAB的選中狀態
        isExpand = !isExpand
    }
    
    private func initialMask(){
        customMaskView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        customMaskView.isHidden = true
        insertSubview(customMaskView, at: 0)
        customMaskView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([customMaskView.widthAnchor.constraint(equalTo: widthAnchor),
                                     customMaskView.heightAnchor.constraint(equalTo: heightAnchor),
                                     customMaskView.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     customMaskView.centerYAnchor.constraint(equalTo: centerYAnchor)])
    }
    
    private func animationRotate(duration: Double, toValue: Double, repeatCount: Float, btn: UIButton){ //旋轉動畫
        let animRotate = CABasicAnimation(keyPath: "transform.rotation")
        animRotate.duration = duration //動畫速度
        animRotate.isRemovedOnCompletion = false //結束時不回復原樣
        animRotate.fillMode = CAMediaTimingFillMode.forwards //讓layer停在toValue
        animRotate.toValue = toValue //設定動畫結束值
        animRotate.repeatCount = repeatCount //旋轉次數（正1為順時針一圈，負為逆時針）
        btn.imageView?.layer.add(animRotate, forKey: nil)
    }
    
    private func animationPosition(duration: Double, fromValue: [CGFloat], toValue: [CGFloat], index: Int){ //位移動畫
        let animPosition = CABasicAnimation(keyPath: "position")
        animPosition.duration = duration
        animPosition.isRemovedOnCompletion = false
        animPosition.fillMode = CAMediaTimingFillMode.forwards
        animPosition.fromValue = fromValue
        animPosition.toValue = toValue
        views[index].layer.add(animPosition, forKey: nil)
    }
}
