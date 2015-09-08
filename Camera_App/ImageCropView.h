//
//  Created by Ming Yang on 7/7/12.
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/FXBlurView
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//


#import <UIKit/UIKit.h>
#import "FXBlurView.h"

#pragma mark ControlPointView interface

@interface ControlPointView : UIView {
    CGFloat red, green, blue, alpha;
}

@property (nonatomic, retain) UIColor* color;

@end

#pragma mark ShadeView interface

@interface ShadeView : UIView {
    CGFloat cropBorderRed, cropBorderGreen, cropBorderBlue, cropBorderAlpha;
    CGRect cropArea;
    CGFloat shadeAlpha;
}

@property (nonatomic, retain) UIColor* cropBorderColor;
@property (nonatomic) CGRect cropArea;
@property (nonatomic) CGFloat shadeAlpha;
@property (nonatomic, strong) UIImageView *blurredImageView;

@end

CGRect SquareCGRectAtCenter(CGFloat centerX, CGFloat centerY, CGFloat size);

UIView* dragView;
typedef struct {
    CGPoint dragStart;
    CGPoint topLeftCenter;
    CGPoint bottomLeftCenter;
    CGPoint bottomRightCenter;
    CGPoint topRightCenter;
    CGPoint clearAreaCenter;
} DragPoint;

// Used when working with multiple dragPoints
typedef struct {
    DragPoint mainPoint;
    DragPoint optionalPoint;
    NSUInteger lastCount;
} MultiDragPoint;

#pragma mark ImageCropView interface

@interface ImageCropView : UIView {
    UIImageView* imageView;
    CGRect imageFrameInView;
    CGFloat imageScale;
    
    CGFloat controlPointSize;
    ControlPointView* topLeftPoint;
    ControlPointView* bottomLeftPoint;
    ControlPointView* bottomRightPoint;
    ControlPointView* topRightPoint;
    NSArray *PointsArray;
    UIColor* controlColor;

    UIView* cropAreaView;
    DragPoint dragPoint;
    MultiDragPoint multiDragPoint;
    
    UIView* dragViewOne;
    UIView* dragViewTwo;
}
- (id)initWithFrame:(CGRect)frame blurOn:(BOOL)blurOn;
- (void)setImage:(UIImage*)image;

@property (nonatomic) CGFloat controlPointSize;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic) CGRect cropAreaInView;
@property (nonatomic) CGRect cropAreaInImage;
@property (nonatomic, readonly) CGFloat imageScale;
@property (nonatomic) CGFloat maskAlpha;
@property (nonatomic, retain) UIColor* controlColor;
@property (nonatomic, strong) ShadeView* shadeView;
@property (nonatomic) BOOL blurred;

@end

@interface UIImage (fixOrientation)

- (UIImage *)fixOrientation;

@end

