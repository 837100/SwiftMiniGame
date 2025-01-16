//
//  CoreDataDemoApp.swift
//  CoreDataDemo
//
//  Created by SG on 1/16/25.
//

/// 이 코드는 앱의 기본 구조를 설정하고, CoreData를 앱 전체에서 사용할 수 있도록 환경을 구성하는 역할을 합니다.

import SwiftUI

///@main은 앱의 진입점을 나타내는 속성입니다.
@main
/// App 프로토콜을 따르는 CoreDataDemoApp 구조체가 앱의 기본 구조를 정의합니다.
struct CoreDataDemoApp: App {
    
    /// 앞서 정의한 PersistenceController의 공유 인스턴스를 생성합니다.
    /// 앱 전체에서 하나의 CoreData 스택을 공유하기 위해 싱글톤을 사용합니다.
    let persistenceController = PersistenceController.shared

    
    /// 앱의 기본 화면 구조를 정의합니다.
    /// WindowGroup은 앱의 기본 창을 나타냅니다.
    /// ContentView가 앱의 메인 뷰가 됩니다.
    var body: some Scene {
        WindowGroup {
            ContentView()
            
            /// SwiftUI의 환경 값으로 CoreData의 viewContext를 설정합니다.
            /// 이렇게 설정하면 앱의 모든 하위 뷰에서 @Environment 속성 래퍼를 통해 managedObjectContext에 접근할 수 있습니다.
            /// 이는 앱 전체에서 CoreData를 사용할 수 있게 해주는 중요한 설정입니다.
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
