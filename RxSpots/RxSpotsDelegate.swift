#if !COCOAPODS
import Spots
#endif
import RxSwift
import RxCocoa

// MARK: - Delegate proxy

/**
 Delegate proxy for ComponentDelegate
 */
public final class RxComponentDelegate: DelegateProxy, DelegateProxyType, ComponentDelegate {

  // Delegate methods subjects
  private let componentDidSelectItem = PublishSubject<(Spotable, Item)>()
  private let componentsDidChange = PublishSubject<[Spotable]>()
  private let componentWillDisplayView = PublishSubject<(Spotable, SpotView, Item)>()
  private let componentDidEndDisplayingView = PublishSubject<(Spotable, SpotView, Item)>()

  // Delegate method observables
  public let didSelectItem: Observable<(Spotable, Item)>
  public let didChange: Observable<[Spotable]>
  public let willDisplayView: Observable<(Spotable, SpotView, Item)>
  public let didEndDisplayingView: Observable<(Spotable, SpotView, Item)>

  public class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
    return (object as? Spotable)?.delegate ?? (object as? Controller)?.delegate
  }

  public class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
    if let spot = object as? Spotable {
      spot.delegate = delegate as? ComponentDelegate
    } else if let controller = object as? Controller {
      controller.delegate = delegate as? ComponentDelegate
    }
  }

  public required init(parentObject: AnyObject) {
    didSelectItem = componentDidSelectItem.observeOn(MainScheduler.instance)
    didChange = componentsDidChange.observeOn(MainScheduler.instance)
    willDisplayView = componentWillDisplayView.observeOn(MainScheduler.instance)
    didEndDisplayingView = componentDidEndDisplayingView.observeOn(MainScheduler.instance)

    super.init(parentObject: parentObject)
  }

  public func component(_ component: Spotable, itemSelected item: Item) {
    componentDidSelectItem.onNext(component, item)
  }

  public func componentsDidChange(_ components: [Spotable]) {
    componentsDidChange.onNext(components)
  }

  public func component(_ component: Spotable, willDisplay view: SpotView, item: Item) {
    componentWillDisplayView.onNext(component, view, item)
  }

  public func spotable(_ component: Spotable, didEndDisplaying view: SpotView, item: Item) {
    componentDidEndDisplayingView.onNext(component, view, item)
  }
}

// MARK: - Reactive extensions

extension Reactive where Base: Spotable {

  public var delegate: RxComponentDelegate {
    return RxComponentDelegate.proxyForObject(base)
  }
}

extension Reactive where Base: SpotsProtocol {

  public var delegate: RxComponentDelegate {
    return RxComponentDelegate.proxyForObject(base)
  }
}
