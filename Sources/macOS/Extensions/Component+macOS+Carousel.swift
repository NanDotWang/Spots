import Cocoa
import Tailor

extension Component {
  func setupHorizontalCollectionView(_ collectionView: CollectionView, with size: CGSize) {
    var newCollectionViewHeight: CGFloat = 0.0

    newCollectionViewHeight <- model.items.sorted(by: {
      $0.size.height > $1.size.height
    }).first?.size.height

    scrollView.scrollingEnabled = (model.items.count > 1)
    scrollView.hasHorizontalScroller = (model.items.count > 1)

    if let layout = model.layout {
      newCollectionViewHeight += CGFloat(layout.inset.top + layout.inset.bottom)
    }

    collectionView.frame.size.height = newCollectionViewHeight
  }

  func layoutHorizontalCollectionView(_ collectionView: CollectionView, with size: CGSize) {
    guard let collectionViewLayout = collectionView.collectionViewLayout as? FlowLayout else {
      return
    }

    collectionViewLayout.prepare()
    collectionViewLayout.invalidateLayout()

    guard let collectionViewContentSize = collectionView.collectionViewLayout?.collectionViewContentSize else {
      return
    }

    var newCollectionViewHeight: CGFloat = 0.0

    newCollectionViewHeight <- model.items.sorted(by: {
      $0.size.height > $1.size.height
    }).first?.size.height

    collectionView.frame.size.width = collectionViewContentSize.width
    collectionView.frame.size.height = newCollectionViewHeight

    documentView.frame.size = collectionView.frame.size
    documentView.frame.size.height = collectionView.frame.size.height + headerHeight + footerHeight

    if let layout = model.layout {
      collectionView.frame.size.height += CGFloat(layout.inset.top + layout.inset.bottom)
      documentView.frame.size.height += CGFloat(layout.inset.top + layout.inset.bottom)
      documentView.frame.size.width += CGFloat(layout.inset.right)
    }

    collectionView.frame.size.height += headerHeight

    scrollView.frame.size.width = size.width
    scrollView.frame.size.height = documentView.frame.size.height
    scrollView.scrollerInsets.bottom = footerHeight
  }

  func resizeHorizontalCollectionView(_ collectionView: CollectionView, with size: CGSize, type: ComponentResize) {
    switch type {
    case .live:
      layout(with: size)
      prepareItems(recreateComposites: false)
    case .end:
      layout(with: size)
      prepareItems(recreateComposites: false)
    }
  }
}
