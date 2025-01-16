//
//  Persistence.swift
//  CoreDataDemo
//
//  Created by SG on 1/16/25.
// 이 코드는 CoreData를 사용하기 위한 기본적인 설정을 담고 있으며, 데이터의 영구 저장과 메모리 내 임시 저장을 모두 지원합니다. 실제 앱에서는 shared 인스턴스를 통해 데이터를 관리하고, 프리뷰에서는 preview 인스턴스를 사용하여 테스트 데이터를 표시할 수 있습니다.

import CoreData

/// CoreData 관리를 위한 구조체. 데이터 저장소를 관리하는 컨트롤러 역할을 함.
struct PersistenceController {
    
    /// 싱글톤 패턴을 구현한 것으로, 앱 전체에서 하나의 인스턴스만 사용하도록 하는 공유 인스턴스.
    static let shared = PersistenceController()

    /// @MainActor는 이 코드가 메인 스레드에서 실행되도록 보장함.
    @MainActor
    /// preview는 SwiftUI 프리뷰에서 사용할 테스트 데이터를 생성하는 정적 속성
    static let preview: PersistenceController = {
        /// 메모리에만 존재하는 임시 저장소 생성.
        let result = PersistenceController(inMemory: true)

        /// 데이터를 읽고 쓸 수 있는 메인 컨텍스트
        let viewContext = result.container.viewContext
        
        // 테스트용으로 10개의 Product 엔티티를 생성하고 이름을 i로 설정
        for i in 0..<10 {
            let newItem = Product(context: viewContext)
            newItem.name = "Product \(i)"
        }
        
        /// 변경사항을 저장하고, 실패할 경우 에러를 발생
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    /// CoreData 스택의 핵심 컨테이너를 선언
    let container: NSPersistentContainer

    
    /// 초기화 메서드로, CoreDataDemo 라는 이름의 데이터 모델을 사용하는 컨테이너를 생성함.
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CoreDataDemo")
        
        /// 메모리 전용 모드일 경우, 저장소 위치를 /dev/null로 설정하여 디스크에 저장하지 않게 함.
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        /// 영구 저장소를 로드하는 과정
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        /// 부모 컨텍스트의 변경사항을 자동으로 병합하도록 설정.
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
