//
//  ViewController.swift
//  instuctions_tutorial
//
//  Created by wooyeong kam on 2021/06/09.
//

import UIKit
import Instructions

class ViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var subcribeButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var alertButton: UIButton!
    
    let coachMarksController = CoachMarksController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.coachMarksController.dataSource = self
        self.coachMarksController.delegate = self
        
        // 에니메이션 딜리게이트
        self.coachMarksController.animationDelegate = self
        
        // 오버레이를 클릭해도 다음으로 넘어가도록 설정
        self.coachMarksController.overlay.isUserInteractionEnabled = true
        
        // 스킵뷰를 지정
        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("튜토리얼 스킵하기", for: .normal)
        
        self.coachMarksController.skipView = skipView
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.coachMarksController.start(in: .window(over: self))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.coachMarksController.stop(immediately: true)
    }
    
//    func coachMarksController(_ coachMarksController: CoachMarksController, didEndShowingBySkipping skipped: Bool) {
//
//    }


}

extension ViewController : CoachMarksControllerDelegate {
    
    // overlay configure
    func coachMarksController(_ coachMarksController: CoachMarksController, configureOrnamentsOfOverlay overlay: UIView) {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(label)
        
        label.text = "오버레이"
        label.alpha = 0.5
        label.font = label.font.withSize(60)
        label.centerXAnchor.constraint(equalTo: overlay.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: overlay.topAnchor, constant: 100).isActive = true
    }
}

extension ViewController : CoachMarksControllerDataSource {
    
    // 마커뷰에 대한 설정
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews( withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        
        switch index {
        case 0:
            coachViews.bodyView.hintLabel.text = "당신의 프사를 설정해주세요"
            coachViews.bodyView.nextLabel.text = "다음"
            coachViews.bodyView.background.innerColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
            coachViews.arrowView?.background.innerColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
            coachViews.bodyView.background.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            coachViews.bodyView.hintLabel.textColor = .white
            coachViews.bodyView.nextLabel.textColor = .yellow
        case 1:
            coachViews.bodyView.hintLabel.text = "당신의 이름를 설정해주세요"
            coachViews.bodyView.nextLabel.text = "다음"
        case 2:
            coachViews.bodyView.hintLabel.text = "당신의 구독를 설정해주세요"
            coachViews.bodyView.nextLabel.text = "다음"
        case 3:
            coachViews.bodyView.hintLabel.text = "당신의 좋아유를 설정해주세요"
            coachViews.bodyView.nextLabel.text = "다음"
        case 4:
            coachViews.bodyView.hintLabel.text = "당신의 알림를 설정해주세요"
            coachViews.bodyView.nextLabel.text = "다음"
        default:
            coachViews.bodyView.hintLabel.text = "당신의 프사를 설정해주세요"
            coachViews.bodyView.nextLabel.text = "다음"
        }
        
        return (bodyView : coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    
    // 가르키고자하는 뷰를 지정
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        
        switch index {
        case 0:
            return coachMarksController.helper.makeCoachMark(for : profileImage)
        case 1:
            return coachMarksController.helper.makeCoachMark(for : profileLabel)
        case 2:
            return coachMarksController.helper.makeCoachMark(for : subcribeButton)
        case 3:
            return coachMarksController.helper.makeCoachMark(for : goodButton)
        case 4:
            return coachMarksController.helper.makeCoachMark(for : alertButton)
        default:
            return coachMarksController.helper.makeCoachMark(for : profileImage)
        }
    }
    
    
    // 몇개에 뷰에대해 가이드를 제공할 것인가
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 5
    }
    
    
}

extension ViewController : CoachMarksControllerAnimationDelegate {
    // 마커가 나타날떼
    func coachMarksController(_ coachMarksController: CoachMarksController, fetchAppearanceTransitionOfCoachMark coachMarkView: UIView, at index: Int, using manager: CoachMarkTransitionManager) {
        
        manager.parameters.options = [.beginFromCurrentState]
        manager.animate(.regular){ (CoachMarkAnimationManagementContext) in
            coachMarkView.transform = .identity
            coachMarkView.alpha = 1
        } fromInitialState: {
            coachMarkView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            coachMarkView.alpha = 0
        } completion: { (Bool) in
            
        }
    }
    // 마커가 사라질떼
    
    func coachMarksController(_ coachMarksController: CoachMarksController, fetchDisappearanceTransitionOfCoachMark coachMarkView: UIView, at index: Int, using manager: CoachMarkTransitionManager) {
        
        manager.animate(.keyframe) { (CoachMarkAnimationManagementContext) in
            // 크기를 줄인다.
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
                coachMarkView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
            // 투명하게 설정
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5){
                coachMarkView.alpha = 0
            }
        }
    }
    
    // 마커가 떠있을때
    func coachMarksController(_ coachMarksController: CoachMarksController, fetchIdleAnimationOfCoachMark coachMarkView: UIView, at index: Int, using manager: CoachMarkAnimationManager) {
        manager.parameters.options = [.repeat, .autoreverse, .allowUserInteraction]
        manager.parameters.duration = 0.7
        manager.animate(.regular) { (context : CoachMarkAnimationManagementContext) in
            let offset : CGFloat = context.coachMark.arrowOrientation == .top ? 10 : -10
            coachMarkView.transform = CGAffineTransform(scaleX: 0, y: offset)
        }
    }
    
}

