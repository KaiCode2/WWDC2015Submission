// THIS IS NOT MY CODE - KA
//
// Original from Apple https://developer.apple.com/library/ios/samplecode/UIImageEffects/Listings/UIImageEffects_UIImageEffects_m.html#//apple_ref/doc/uid/DTS40013396-UIImageEffects_UIImageEffects_m
import Accelerate
import UIKit

extension UIImage {
    func applyLightEffect() -> UIImage? {
        return applyBlur(radius: 30, tintColor: UIColor(white: 1, alpha: 0.3))
    }
    
    func applyExtraLightEffect() -> UIImage? {
        return applyBlur(radius: 20, tintColor: UIColor(white: 0.97, alpha: 0.82))
    }
    
    func applyDarkEffect() -> UIImage? {
        return applyBlur(radius: 20, tintColor: UIColor(white: 0.11, alpha: 0.73))
    }
    
    func applyTintEffect(color tintColor: UIColor) -> UIImage? {
        return applyBlur(radius: 10, tintColor: tintColor.colorWithAlphaComponent(0.6), saturationDeltaFactor: -1)
    }
    
    func applyBlur(radius blurRadius: CGFloat, tintColor: UIColor? = nil, saturationDeltaFactor: CGFloat = 1.8, maskImage: UIImage? = nil) -> UIImage? {
        if size.width < 1 || size.height < 1 {
            println(String(format: "*** error: invalid size: %.2f x %.2f. Both dimensions must be >= 1: \(self)", size.width, size.height))
            return nil
        }
        
        if CGImage == nil {
            println("*** error: image must be backed by a CGImage: \(self)")
            return nil
        }
        
        if let maskImage = maskImage where maskImage.CGImage == nil {
            println("*** error: maskImage must be backed by a CGImage: \(maskImage)")
            return nil
        }
        
        let imageRect = CGRect(origin: CGPointZero, size: size)
        var effectImage = self
        
        let hasBlur = Float(blurRadius) > FLT_EPSILON
        let hasSaturationChange = Float(abs(saturationDeltaFactor - 1)) > FLT_EPSILON
        
        if hasBlur || hasSaturationChange {
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
            let effectInContext = UIGraphicsGetCurrentContext()
            CGContextScaleCTM(effectInContext, 1, -1)
            CGContextTranslateCTM(effectInContext, 0, -size.height)
            CGContextDrawImage(effectInContext, imageRect, CGImage)
            var effectInBuffer = vImage_Buffer(data: CGBitmapContextGetData(effectInContext), height: UInt(CGBitmapContextGetHeight(effectInContext)), width: UInt(CGBitmapContextGetWidth(effectInContext)), rowBytes: CGBitmapContextGetBytesPerRow(effectInContext))
            
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
            let effectOutContext = UIGraphicsGetCurrentContext()
            var effectOutBuffer = vImage_Buffer(data: CGBitmapContextGetData(effectOutContext), height: UInt(CGBitmapContextGetHeight(effectOutContext)), width: UInt(CGBitmapContextGetWidth(effectOutContext)), rowBytes: CGBitmapContextGetBytesPerRow(effectOutContext))
            
            if hasBlur {
                let inputRadius = blurRadius * UIScreen.mainScreen().scale
                var radius = UInt32(floor(inputRadius * 3.0 * CGFloat(sqrt(2 * M_PI)) / 4 + 0.5))
                if radius % 2 != 1 {
                    ++radius    // force radius to be odd so that the three box-blur methodology works.
                }
                
                let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
            }
            
            var effectImageBuffersAreSwapped = false
            if hasSaturationChange {
                let s = saturationDeltaFactor
                let floatingPointSaturationMatrix = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,                    1
                ]
                
                let divisor: CGFloat = 256
                let matrixSize = count(floatingPointSaturationMatrix)
                let saturationMatrix = map(floatingPointSaturationMatrix) {
                    return Int16(round($0 * divisor))
                }
                
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                } else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }
            
            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()
            }
            UIGraphicsEndImageContext()
            
            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()
            }
            UIGraphicsEndImageContext()
        }
        
        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        let outputContext = UIGraphicsGetCurrentContext()
        CGContextScaleCTM(outputContext, 1, -1)
        CGContextTranslateCTM(outputContext, 0, -size.height)
        
        // Draw base image.
        CGContextDrawImage(outputContext, imageRect, CGImage)
        
        // Draw effect image.
        if hasBlur {
            CGContextSaveGState(outputContext)
            if let image = maskImage {
                CGContextClipToMask(outputContext, imageRect, image.CGImage)
            }
            CGContextDrawImage(outputContext, imageRect, effectImage.CGImage)
            CGContextRestoreGState(outputContext)
        }
        
        // Add in color tint.
        if let tintColor = tintColor {
            CGContextSaveGState(outputContext)
            CGContextSetFillColorWithColor(outputContext, tintColor.CGColor)
            CGContextFillRect(outputContext, imageRect)
            CGContextRestoreGState(outputContext)
        }
        
        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage
    }
}