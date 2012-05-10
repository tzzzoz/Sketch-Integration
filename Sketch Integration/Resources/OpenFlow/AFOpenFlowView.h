/**
 * Copyright (c) 2009 Alex Fajkowski, Apparent Logic LLC
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */
#import <UIKit/UIKit.h>
#import "AFItemView.h"
#import <QuartzCore/QuartzCore.h>


@protocol AFOpenFlowViewDelegate;

@interface AFOpenFlowView : UIView {
	id <AFOpenFlowViewDelegate>	    viewDelegate;
	NSMutableDictionary				*onscreenCovers;   //当前显示的卡片集合 按照次序索引
	NSMutableDictionary				*coverImages;      //所有卡片用的图片  按照次序索引
	NSMutableDictionary				*coverImageHeights; //记录每个卡片图片的高度  按照次序索引
	UIImage							*defaultImage;       //默认没有图片资源时候的图片
	CGFloat							defaultImageHeight;

	UIScrollView					*scrollView;        //展示的superView
	int								lowerVisibleCover;  //selectedIndex-左右两边分别看到的个数
	int								upperVisibleCover;
	int								numberOfImages;     //总共有多少个图片
	int								beginningCover;     //用手拖动时候记录 拖动前的 选中索引
	
	AFItemView						*selectedCoverView;

	CATransform3D leftTransform, rightTransform;
	
	CGFloat halfScreenHeight;
	CGFloat halfScreenWidth;
	
	Boolean isSingleTap;
	Boolean isDoubleTap;
	Boolean isDraggingACover;    //标志你点中了一张卡片了么
	CGFloat startPosition;
}

@property (nonatomic, assign) id <AFOpenFlowViewDelegate> viewDelegate;
@property (nonatomic, retain) UIImage *defaultImage;
@property int numberOfImages;

- (void)setImage:(UIImage *)image forIndex:(int)index;
- (void)dataSourceDefaultImage:(UIImage *)defaultS;

@end

@protocol AFOpenFlowViewDelegate <NSObject>
@optional
- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index;
- (void)openFlowView:(AFOpenFlowView *)openFlowView singleTaped:(int)index;
@end
