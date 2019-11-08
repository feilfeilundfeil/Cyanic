import Cyanic
import LayoutKit
import UIKit

// sourcery: AutoEquatableComponent,AutoHashableComponent
// sourcery: Component = ___VARIABLE_productName:identifier___Component
public protocol ___VARIABLE_productName:identifier___ComponentType: StaticHeightComponent {

    // define here your component properties and annotations and run sourcery
    // sourcery: defaultValue = "UIColor.clear"
    var backgroundColor: UIColor { get set }

}

// sourcery: AutoGenerateComponent,AutoGenerateComponentExtension
// sourcery: ComponentLayout = ___VARIABLE_productName:identifier___ComponentLayout
public struct ___VARIABLE_productName:identifier___Component: ___VARIABLE_productName:identifier___ComponentType {
    // left initially empty
}

public final class ___VARIABLE_productName:identifier___ComponentLayout: SizeLayout<UIView>, ComponentLayout {

    public init(component: ___VARIABLE_productName:identifier___Component) {
        let size: CGSize = CGSize(width: component.width, height: component.height)

        #warning("Please consider that sublayout parameter must not be nil")
        super.init(
            minWidth: size.width,
            maxWidth: size.width,
            minHeight: size.height,
            maxHeight: size.height,
            alignment: Alignment.fill,
            flexibility: Flexibility.flexible,
            viewReuseId: ___VARIABLE_productName:identifier___ComponentLayout.identifier,
            sublayout: nil,
            config: { (view: UIView) -> Void in
                view.backgroundColor = component.backgroundColor
            }
        )
    }
}
