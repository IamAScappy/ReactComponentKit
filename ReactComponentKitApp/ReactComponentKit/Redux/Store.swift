//
//  Store.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 23..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import RxSwift
import BKEventBus

final class Store {
    
    enum Event: EventType {
        case dispatch(action: Action, token: Token)
        case on(newState: [String:State], token: Token)
    }
    
    private static let concurrentQ = ConcurrentDispatchQueueScheduler(qos: .background)
    
    var state: [String:State]
    let reducers:[String:Reducer]
    let middlewares:[Middleware]?
    let disposeBag = DisposeBag()
    let token = Token() // 이벤트를 통해서 Store에 액션을 보낼 컴포넌트들은 Store의 토큰을 알아야 한다.
    private let eventBus = EventBus<Store.Event>()
    
    init(state: [String:State], reducers:[String:Reducer], middlewares:[Middleware]? = nil) {
        self.state = state
        self.reducers = reducers
        self.middlewares = middlewares
        setupEventBus()
    }
    
    func dispatch(action: Action) {
        /*
         - 이렇게 할 경우, API를 호출했을 때, 응답을 받은 후 응답의 각 level-0 필드를 분해한 다음,
         - 다시 리듀서를 탈 수 있는가?
         - store(API response) -> store(각 필드를 쪼갠것)?
         - 아니면 상태를
         - {
         -      response: {}, --> responseReducer
         -      converted: {} --> convertReducer
         - }
         - 이렇게 정의해야 하는가?
         - 예제를 작성해서 방법을 찾아보자
         - 아!
         - 스토어는 모든 상태를 가져야 하므로 모든 API에 대한 응답을 가지고 있어야 한다. 즉, 아래처럼
         - {
         -      A_API_response: {} --> A_API_Reducer
         -      B_API_response: {} --> B_API_Reducer
         -      C_API_response: {} --> C_API_Reducer
         - }
         - 하면서 A_API_Reducer에서 하위 상태를 위한 리듀서를 직접 호출해야 한다. 
        */
        
        
        reduce(state: state, action: action)
            .subscribeOn(Store.concurrentQ)
            .observeOn(Store.concurrentQ)
            //middleware
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (newState) in
                guard let strongSelf = self else { return }
                strongSelf.state = newState
                strongSelf.eventBus.post(event: .on(newState: newState, token: strongSelf.token))
            })
            .disposed(by: disposeBag)
    }
    
    private func reduce(state: [String:State], action: Action) -> Observable<[String:State]> {
        
        var mutableState = state
        return Single.create(subscribe: { [weak self] (single) -> Disposable in
            guard let strongSelf = self else {
                single(.success(mutableState))
                return Disposables.create()
            }
            
            let statedReducers = strongSelf.reducers.map({ (reducerInfo) -> (Action) -> Observable<ReducerResult> in
                let (key, reducer) = reducerInfo
                return reducer(mutableState[key])
            })
            
            return Observable.combineLatest(statedReducers.map({ $0(action) }))
                .subscribe(onNext: { (reducerResultList: [ReducerResult]) in
                    reducerResultList.forEach({ (reducerResult: ReducerResult) in
                        mutableState[reducerResult.name] = reducerResult.result
                    })
                    single(.success(mutableState))
                }, onError: { (error) in
                    single(.success(mutableState))
                })

        }).asObservable()
        
    }
    
    private func setupEventBus() {
        eventBus.on { [weak self] (event: Store.Event) in
            guard let strongSelf = self else { return }
            switch event {
            case let .dispatch(action, token):
                guard strongSelf.token == token else { return }
                strongSelf.dispatch(action: action)
            default:
                break
            }
        }
    }
    
}
