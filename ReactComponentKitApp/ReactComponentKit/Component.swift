//
//  Component.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 31..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import UIKit
import BKEventBus
import BKRedux

public enum ComponentEvent: EventType {
    case on(state: [String:State]?)
    case dispatch(action: Action)
}

//public protocol UpdatableComponentModel {
//    func update(with model: ComponentModel)
//}

public protocol Component {
    var contentSize: CGSize { get }
}

// 이벤트를 들을 수 있는 컴포넌트
public protocol ReactComponent: Component {
    var token: Token { get set }
    var eventBus: EventBus<ComponentEvent> { get }
    init(token: Token)
}

public class ReactComponentView: UIView, ReactComponent {
    
    public var token: Token
    public var eventBus: EventBus<ComponentEvent>
    public var contentSize: CGSize {
        return .zero
    }
    public required init(token: Token) {
        self.token = token
        self.eventBus = EventBus(token: token)
        super.init(frame: .zero)
        
        self.eventBus.on { [weak self] (event) in
            guard let strongSelf = self else { return }
            switch event {
            case let .on(state):
                strongSelf.on(state: state)
            default:
                break
            }
        }
        
        self.setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
    }
    
    func on(state: [String:State]?) {
        
    }
}

// 업데이트할 모델 전파
//extension UpdatableComponentModel where Self: UIViewController {
//    public func update(with model: ComponentModel) {
//        // 차일드 뷰 중에 컴포넌트인 것에 상태를 전달해 줘야한다.
//        self.childViewControllers.compactMap { (viewController) -> Component? in
//            return viewController as? Component
//        }.forEach { (component) in
//            component.update(with: model)
//        }
//        
//        self.view.subviews.compactMap { (view) -> Component? in
//            return view as? Component
//        }.forEach { (component) in
//            component.update(with: model)
//        }
//    }
//}
//
//// 컬렉션뷰나 테이블뷰는 대부분 UIView에 랩핑되어 사용될 것이므로
//// 해당 뷰의 update(with model:) 에서 어댑터 처리해 주면 된다.
//extension UpdatableComponentModel where Self: UIView {
//    public func update(with model: ComponentModel) {
//        self.subviews.compactMap { (view) -> Component? in
//            return view as? Component
//        }.forEach { (component) in
//            component.update(with: model)
//        }
//    }
//}
