//
//  Cyanic
//  Created by Julio Miguel Alorro on 27.09.19.
//  Licensed under the MIT license. See LICENSE file
//

import LayoutKit
import RxDataSources
import RxRelay
import RxSwift
import UIKit

//// sourcery: AutoEquatableComponent,AutoHashableComponent
//// sourcery: Component = NestedCollectionComponent
//public protocol NestedCollectionComponentType: Component {
//
//    // sourcery: defaultValue = "UIEdgeInsets.zero", skipEquality, skipHashing
//    /// UIEdgeInsets of the content. Default value is UIEdgeInsets.zero.
//    var insets: UIEdgeInsets { get set }
//
//    // sourcery: skipEquality, skipHashing, isWeak
//    /// RxCollectionDelegate instance that binds the UICollectionView to an RxDataSource.
////    var delegate: RxCollectionDelegate? { get set }
//
//    // sourcery: defaultValue = "10.0"
//    /// The minimumInteritemSpacing for the UICollectionView. Default value is 10.0.
//    var minimumInteritemSpacing: CGFloat { get set }
//
//    // sourcery: defaultValue = "10.0"
//    /// The minimumLineSpacing for the UICollectionView. Default value is 10.0.
//    var minimumLineSpacing: CGFloat { get set }
//
//    // sourcery: defaultValue = "UIColor.clear"
//    /// The backgroundColor of the UICollectionView. Default value is UIColor.clear.
//    var backgroundColor: UIColor { get set }
//
//    // sourcery: skipEquality, skipHashing, defaultValue  = "{ _ in fatalError() }"
//    /// The business logic execcuted when the contentSize of the UICollectionView changes.
//    /// Default value throws a fatalError.
//    var onContentHeightChange: (CGFloat) -> Void { get set }
//
//     // sourcery: skipEquality, skipHashing, defaultValue  = "{ _ in }"
//    /// Additional configuration of the UICollectionView. Default value does nothing.
//    var configuration: (UICollectionView) -> Void { get set }
//
//}

//// sourcery: AutoGenerateComponent,AutoGenerateComponentExtension
//// sourcery: ComponentLayout = NestedCollectionComponentLayout
//public struct NestedCollectionComponent: NestedCollectionComponentType {
//
//// sourcery:inline:auto:NestedCollectionComponent.AutoGenerateComponent
//    /**
//     Work around Initializer because memberwise initializers are all or nothing
//     - Parameters:
//         - id: The unique identifier of the NestedCollectionComponent.
//    */
//    public init(id: String) {
//        self.id = id
//    }
//
//    public var id: String
//
//    public var width: CGFloat = 0.0
//
//    // sourcery: skipHashing, skipEquality
//    public var insets: UIEdgeInsets = UIEdgeInsets.zero
//
//    public var minimumInteritemSpacing: CGFloat = 10.0
//
//    public var minimumLineSpacing: CGFloat = 10.0
//
//    public var backgroundColor: UIColor = UIColor.clear
//
//    // sourcery: skipHashing, skipEquality
//    public var onContentHeightChange: (CGFloat) -> Void = { _ in fatalError() }
//
//    // sourcery: skipHashing, skipEquality
//    public var configuration: (UICollectionView) -> Void = { _ in }
//
//    // sourcery: skipHashing, skipEquality
//    public var layout: ComponentLayout { return NestedCollectionComponentLayout(component: self) }
//
//    public var identity: NestedCollectionComponent { return self }
//// sourcery:end
//}
//
//public final class NestedCollectionComponentLayout: SizeLayout<UIView>, ComponentLayout {
//
//    public init(component: NestedCollectionComponent) {
//        fatalError("Must implement this")
//    }
//}

public protocol NestedCollectionDelegate: class, UICollectionViewDelegateFlowLayout {

    /**
     Instantiates the RxCollectionViewSectionedAnimatedDataSource for the UICollectionView.
     - Returns:
        A RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, AnyComponent>> instance.
    */
    func setUpDataSource() -> RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, AnyComponent>>

}

open class AbstractNestedCollectionDelegate<ConcreteState: State, ConcreteViewModel: ViewModel<ConcreteState>>: NSObject, NestedCollectionDelegate {

    // MARK: Initializers
//    public init(models: BehaviorRelay<[Model]> = .init(value: [])) {
//        self.models = models
//    }

    // MARK: Stored Properties
//    public let mininumHeight: CGFloat
//    public let maximumHeight: CGFloat
//    public let minimumWidth: CGFloat
//    public let maximumWidth: CGFloat
//    public let models: BehaviorRelay<[Model]>
    // swiftlint:disable:next implicitly_unwrapped_optional
    public private(set) var dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, AnyComponent>>!

    /**
     Creates the UICollectionViewLayout to be used by the UICollectionView managed by this CollectionComponentViewController.
     The default implementation creates a UICollectionViewFlowLayout with a minimumLineSpacing and minimumInteritemSpacing of
     0.0.
     - Returns:
        A UICollectionViewLayout instance.
    */
    open func createUICollectionViewLayout() -> UICollectionViewLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        return layout
    }

    open func setUpDataSource() -> RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, AnyComponent>> {
        return CyanicRxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, AnyComponent>>(
            configureCell: { (_, cv: UICollectionView, indexPath: IndexPath, component: AnyComponent) -> UICollectionViewCell in
                guard let cell = cv.dequeueReusableCell(
                    withReuseIdentifier: CollectionComponentCell.identifier,
                    for: indexPath
                ) as? CollectionComponentCell
                    else { fatalError("Cell not registered to UICollectionView")}

                cell.configure(with: component)
                return cell
            }
        )
    }

    public final func bind(to cv: UICollectionView) {
        cv.register(CollectionComponentCell.self, forCellWithReuseIdentifier: CollectionComponentCell.identifier)
        cv.collectionViewLayout = self.createUICollectionViewLayout()
    }

}

public struct NestedCollectionController {

    public let minimumWidth: CGFloat
    public let maximumWith: CGFloat

    public let height: CGFloat

}
