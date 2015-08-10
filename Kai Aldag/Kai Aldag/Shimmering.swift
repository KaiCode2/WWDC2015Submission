// THIS IS NOT MY CODE - KA
//
// Original from Facebook https://github.com/facebook/Shimmer

import UIKit

public enum ShimmerDirection {
    case Right, Left, Up, Down
}

public protocol ShimmeringType {
    var shimmering: Bool { get set }
    var shimmeringPauseDuration: CFTimeInterval { get set }
    var shimmeringAnimationOpacity: CGFloat { get set }
    var shimmeringOpacity: CGFloat { get set }
    var shimmeringSpeed: CGFloat { get set }
    var shimmeringHighlightLength: CGFloat { get set }
    var shimmeringDirection: ShimmerDirection { get set }
    var shimmeringBeginFadeDuration: CFTimeInterval { get set }
    var shimmeringEndFadeDuration: CFTimeInterval { get set }
    var shimmeringFadeTime: CFTimeInterval { get }
}

// MARK: - ShimmeringView

public final class ShimmeringView: UIView {
    private var shimmeringLayer: ShimmeringLayer! {
        return layer as? ShimmeringLayer
    }
    
    /// Set this to `true` to start shimming and `false` to stop. Defaults to `false`
    public var shimmering: Bool {
        get {
            return shimmeringLayer.shimmering == true
        }
        set {
            shimmeringLayer.shimmering = newValue
        }
    }
    
    /// The time interval between shimmerings in seconds. Defaults to 0.4
    public var shimmeringPauseDuration: CFTimeInterval {
        get {
            return shimmeringLayer.shimmeringPauseDuration
        }
        set {
            shimmeringLayer.shimmeringPauseDuration = newValue
        }
    }
    
    /// The opacity of the content while it is shimmering. Defaults to 0.5
    public var shimmeringAnimationOpacity: CGFloat {
        get {
            return shimmeringLayer.shimmeringAnimationOpacity
        }
        set {
            shimmeringLayer.shimmeringAnimationOpacity = newValue
        }
    }
    
    /// The opacity of the content before it is shimmering. Defaults to 1.0
    public var shimmeringOpacity: CGFloat {
        get {
            return shimmeringLayer.shimmeringOpacity
        }
        set {
            shimmeringLayer.shimmeringOpacity = newValue
        }
    }
    
    /// The speed of shimmering, in points per second. Defaults to 230
    public var shimmeringSpeed: CGFloat {
        get {
            return shimmeringLayer.shimmeringSpeed
        }
        set {
            shimmeringLayer.shimmeringSpeed = newValue
        }
    }
    
    /// The highlight length of shimmering. Range of [0,1], defaults to 1.0
    public var shimmeringHighlightLength: CGFloat {
        get {
            return shimmeringLayer.shimmeringHighlightLength
        }
        set {
            shimmeringLayer.shimmeringHighlightLength = newValue
        }
    }
    
    /// The direction of shimmering animation. Defaults to .Right
    public var shimmeringDirection: ShimmerDirection {
        get {
            return shimmeringLayer.shimmeringDirection
        }
        set {
            shimmeringLayer.shimmeringDirection = newValue
        }
    }
    
    /// The duration of the fade used when shimmer begins. Defaults to 0.1
    public var shimmeringBeginFadeDuration: CFTimeInterval {
        get {
            return shimmeringLayer.shimmeringBeginFadeDuration
        }
        set {
            shimmeringLayer.shimmeringBeginFadeDuration = newValue
        }
    }
    
    /// The duration of the fade used when shimmer ends. Defaults to 0.3
    public var shimmeringEndFadeDuration: CFTimeInterval {
        get {
            return shimmeringLayer.shimmeringEndFadeDuration
        }
        set {
            shimmeringLayer.shimmeringEndFadeDuration = newValue
        }
    }
    
    /// The absolute CoreAnimation media time when the shimmer will fade in
    /// Only valid after setting `shimmering` to NO
    public var shimmeringFadeTime: CFTimeInterval {
        get {
            return shimmeringLayer.shimmeringFadeTime
        }
        set {
            shimmeringLayer.shimmeringFadeTime = newValue
        }
    }
    
    // MARK: -
    
    public var contentView: UIView! = nil {
        didSet {
            if contentView != oldValue {
                oldValue?.removeFromSuperview()
                addSubview(contentView)
                shimmeringLayer?.contentLayer = contentView.layer
            }
        }
    }
    
    public override static func layerClass() -> AnyClass {
        return ShimmeringLayer.self
    }
}

// MARK: - Convenience

private func shimmeringLayerDragCoefficient() -> Float {
    return 1.0
}

private func shimmeringLayerAnimationApplyDragCoefficient(animation: CAAnimation) {
    let k = shimmeringLayerDragCoefficient()
    if k != 0 && k != 1 {
        animation.speed = 1 / k
    }
}

private struct AnimationKey {
    static let ShimmerSlideAnimationKey = "slide"
    static let FadeAnimationKey = "fade"
    static let EndFadeAnimationKey = "fade-end"
}

private func fadeAnimation(delegate: AnyObject!, layer: CALayer, opacity: Float, duration: CFTimeInterval) -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.delegate = delegate
    animation.fromValue = layer.presentationLayer() != nil ? (layer.presentationLayer() as! CALayer).opacity : layer.opacity
    animation.toValue = opacity
    animation.fillMode = kCAFillModeBoth
    animation.removedOnCompletion = false
    animation.duration = duration
    shimmeringLayerAnimationApplyDragCoefficient(animation)
    return animation
}

private func shimmerBeginFadeAnimation(delegate: AnyObject!, layer: CALayer, opacity: Float, duration: CFTimeInterval) -> CABasicAnimation {
    return fadeAnimation(delegate, layer, opacity, duration)
}

private func shimmerEndFadeAnimation(delegate: AnyObject!, layer: CALayer, opacity: Float, duration: CFTimeInterval) -> CABasicAnimation {
    let animation = fadeAnimation(delegate, layer, opacity, duration)
    animation.setValue(true, forKey: AnimationKey.EndFadeAnimationKey)
    return animation
}

private func shimmerSlideAnimation(delegate: AnyObject!, duration: CFTimeInterval, direction: ShimmerDirection) -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: "position")
    animation.delegate = delegate
    animation.toValue = NSValue(CGPoint: CGPointZero)
    animation.duration = duration
    animation.repeatCount = Float.infinity
    shimmeringLayerAnimationApplyDragCoefficient(animation)
    if direction == .Left || direction == .Up {
        animation.speed = -fabs(animation.speed)
    }
    return animation
}

private func shimmerSlideRepeat(animation: CAAnimation, duration: CFTimeInterval, direction: ShimmerDirection) -> CAAnimation {
    let a = animation.copy() as! CAAnimation
    a.repeatCount = Float.infinity
    a.duration = duration
    a.speed = direction == .Right || direction == .Down ? fabs(animation.speed) : -fabs(animation.speed)
    return a
}

private func shimmerSlideFinish(animation: CAAnimation) -> CAAnimation {
    let a = animation.copy() as! CAAnimation
    a.repeatCount = 0
    return a
}

// MARK: - ShimmeringMaskLayer

private final class ShimmeringMaskLayer: CAGradientLayer {
    private lazy var fadeLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.whiteColor().CGColor
        self.addSublayer(layer)
        return layer
        }()
    
    private override func layoutSublayers() {
        super.layoutSublayers()
        fadeLayer.bounds = bounds
        fadeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}

// MARK: - ShimmeringLayer

public final class ShimmeringLayer: CALayer, ShimmeringType {
    private var maskLayer: ShimmeringMaskLayer! = nil
    
    public var contentLayer: CALayer! = nil {
        didSet {
            maskLayer = nil
            sublayers = contentLayer != nil ? [contentLayer] : nil
            updateShimmering()
        }
    }
    
    /// Set this to `true` to start shimming and `false` to stop. Defaults to `false`
    public var shimmering = false {
        didSet {
            if shimmering != oldValue {
                updateShimmering()
            }
        }
    }
    
    /// The time interval between shimmerings in seconds. Defaults to 0.4
    public var shimmeringPauseDuration: CFTimeInterval = 0.4 {
        didSet {
            if shimmeringPauseDuration != oldValue {
                updateShimmering()
            }
        }
    }
    
    /// The opacity of the content while it is shimmering. Defaults to 0.5
    public var shimmeringAnimationOpacity: CGFloat = 0.5 {
        didSet {
            if shimmeringAnimationOpacity != oldValue {
                updateShimmering()
            }
        }
    }
    
    /// The opacity of the content before it is shimmering. Defaults to 1.0
    public var shimmeringOpacity: CGFloat = 1.0 {
        didSet {
            if shimmeringOpacity != oldValue {
                updateShimmering()
            }
        }
    }
    
    /// The speed of shimmering, in points per second. Defaults to 230
    public var shimmeringSpeed: CGFloat = 230.0 {
        didSet {
            if shimmeringSpeed != oldValue {
                updateShimmering()
            }
        }
    }
    
    /// The highlight length of shimmering. Range of [0,1], defaults to 1.0
    public var shimmeringHighlightLength: CGFloat = 1.0 {
        didSet {
            if shimmeringHighlightLength != oldValue {
                updateShimmering()
            }
        }
    }
    
    /// The direction of shimmering animation. Defaults to .Right
    public var shimmeringDirection = ShimmerDirection.Right {
        didSet {
            if shimmeringDirection != oldValue {
                updateShimmering()
            }
        }
    }
    
    /// The duration of the fade used when shimmer begins. Defaults to 0.1
    public var shimmeringBeginFadeDuration: CFTimeInterval = 0.1
    
    /// The duration of the fade used when shimmer ends. Defaults to 0.3
    public var shimmeringEndFadeDuration: CFTimeInterval = 0.3
    
    /// The absolute CoreAnimation media time when the shimmer will fade in
    /// Only valid after setting `shimmering` to NO
    public var shimmeringFadeTime: CFTimeInterval = 0
    
    // MARK: Overrides
    
    public override func layoutSublayers() {
        super.layoutSublayers()
        contentLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        contentLayer.bounds = bounds
        contentLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        if let _ = maskLayer {
            updateMaskLayout()
        }
    }
    
    public override var bounds: CGRect {
        didSet {
            super.bounds = bounds
            if !CGRectEqualToRect(bounds, oldValue) {
                updateShimmering()
            }
        }
    }
    
    // MARK: Private
    
    private func clearMask() {
        if let _ = maskLayer {
            let disableActions = CATransaction.disableActions()
            CATransaction.setDisableActions(true)
            
            maskLayer = nil
            contentLayer.mask = nil
            CATransaction.setDisableActions(disableActions)
        }
    }
    
    private func createMaskIfNeeded() {
        if shimmering && maskLayer == nil {
            maskLayer = ShimmeringMaskLayer()
            maskLayer.delegate = self
            contentLayer?.mask = maskLayer
            updateMaskColors()
            updateMaskLayout()
        }
    }
    
    private func updateMaskColors() {
        if let maskLayer = maskLayer {
            // In a mask, the colors do not matter, it's the alpha that decides the degree of masking.
            let maskedColor = UIColor(white: 1, alpha: shimmeringOpacity)
            let unmaskedColor = UIColor(white: 1, alpha: shimmeringAnimationOpacity)
            maskLayer.colors = [maskedColor.CGColor, unmaskedColor.CGColor, maskedColor.CGColor]
        }
    }
    
    private func updateMaskLayout() {
        let length: CGFloat
        if shimmeringDirection == .Down || shimmeringDirection == .Up {
            length = contentLayer.bounds.height
        } else {
            length = contentLayer.bounds.width
        }
        
        if length == 0 { return }
        
        // extra distance for the gradient to travel during the pause.
        let extraDistance = length + shimmeringSpeed * CGFloat(shimmeringPauseDuration)
        
        // compute how far the shimmering goes
        let fullShimmerLength = length * 3 + extraDistance
        let travelDistance = length * 2 + extraDistance
        
        // position the gradient for the desired width
        let highlightOutsideLength = (1 - shimmeringHighlightLength) / 2
        maskLayer.locations = [highlightOutsideLength, 0.5, 1 - highlightOutsideLength]
        
        let startPoint = (length + extraDistance) / fullShimmerLength
        let endPoint = travelDistance / fullShimmerLength
        
        // position for the start of the animation
        maskLayer.anchorPoint = CGPointZero
        if shimmeringDirection == .Down || shimmeringDirection == .Up {
            maskLayer.startPoint = CGPoint(x: 0, y: startPoint)
            maskLayer.endPoint = CGPoint(x: 0, y: endPoint)
            maskLayer.position = CGPoint(x: 0, y: -travelDistance)
            maskLayer.bounds = CGRect(origin: CGPointZero, size: CGSize(width: contentLayer.bounds.width, height: fullShimmerLength))
        } else {
            maskLayer.startPoint = CGPoint(x: startPoint, y: 0)
            maskLayer.endPoint = CGPoint(x: endPoint, y: 0)
            maskLayer.position = CGPoint(x: -travelDistance, y: 0)
            maskLayer.bounds = CGRect(origin: CGPointZero, size: CGSize(width: fullShimmerLength, height: contentLayer.bounds.height))
        }
    }
    
    private func updateShimmering() {
        createMaskIfNeeded()
        if !shimmering && maskLayer == nil { return }
        
        layoutIfNeeded()
        let disableActions = CATransaction.disableActions()
        
        if (!shimmering) {
            if (disableActions) {
                clearMask()
            } else {
                var slideEndTime: CFTimeInterval = 0
                if let slideAnimation = maskLayer.animationForKey(AnimationKey.ShimmerSlideAnimationKey) {
                    let now = CACurrentMediaTime()
                    let slideTotalDuration = now - slideAnimation.beginTime
                    let slideTimeOffset = fmod(slideTotalDuration, slideAnimation.duration)
                    let finishAnimation = shimmerSlideFinish(slideAnimation)
                    finishAnimation.beginTime = now - slideTimeOffset
                    slideEndTime = finishAnimation.beginTime + slideAnimation.duration
                    maskLayer.addAnimation(finishAnimation, forKey: AnimationKey.ShimmerSlideAnimationKey)
                }
                
                let fadeInAnimation = shimmerEndFadeAnimation(self, maskLayer.fadeLayer, 1, shimmeringEndFadeDuration)
                fadeInAnimation.beginTime = slideEndTime
                maskLayer.fadeLayer.addAnimation(fadeInAnimation, forKey: AnimationKey.FadeAnimationKey)
                shimmeringFadeTime = slideEndTime
            }
        } else {
            var fadeOutAnimation: CABasicAnimation! = nil
            if shimmeringBeginFadeDuration > 0 && !disableActions {
                fadeOutAnimation = shimmerBeginFadeAnimation(self, maskLayer.fadeLayer, 0, shimmeringBeginFadeDuration)
                maskLayer.fadeLayer.addAnimation(fadeOutAnimation, forKey: AnimationKey.FadeAnimationKey)
            } else {
                let innerDisableActions = CATransaction.disableActions()
                CATransaction.setDisableActions(true)
                
                maskLayer.fadeLayer.opacity = 0
                maskLayer.fadeLayer.removeAllAnimations()
                
                CATransaction.setDisableActions(innerDisableActions)
            }
            
            var slideAnimation = maskLayer.animationForKey(AnimationKey.ShimmerSlideAnimationKey)
            
            let length = shimmeringDirection == .Down || shimmeringDirection == .Up ? contentLayer.bounds.height : contentLayer.bounds.width
            let animationDuration = length / shimmeringSpeed + CGFloat(shimmeringPauseDuration)
            
            if let animation = slideAnimation {
                maskLayer.addAnimation(shimmerSlideRepeat(slideAnimation, CFTimeInterval(animationDuration), shimmeringDirection), forKey: AnimationKey.ShimmerSlideAnimationKey)
            } else {
                slideAnimation = shimmerSlideAnimation(self, CFTimeInterval(animationDuration), shimmeringDirection)
                slideAnimation.fillMode = kCAFillModeForwards
                slideAnimation.removedOnCompletion = false
                slideAnimation.beginTime = CACurrentMediaTime() + CFTimeInterval(fadeOutAnimation?.duration ?? 0)
                maskLayer.addAnimation(slideAnimation, forKey: AnimationKey.ShimmerSlideAnimationKey)
            }
        }
    }
    
    // MARK: CALayerDelegate
    
    public override func actionForLayer(layer: CALayer!, forKey event: String!) -> CAAction! {
        return nil
    }
    
    // MARK: CAAnimationDelegate
    
    public override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        if flag && anim.valueForKey(AnimationKey.FadeAnimationKey)?.boolValue == true {
            clearMask()
        }
    }
}