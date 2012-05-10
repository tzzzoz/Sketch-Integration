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
#import "AFOpenFlowView.h"
#import "AFOpenFlowConstants.h"
#import "AFUIImageReflection.h"
//#import <stdlib.h>

//倒影用的
const static CGFloat kReflectionFraction = 0.85;


@interface AFOpenFlowView (hidden)

- (void)setUpInitialState;
- (AFItemView *)coverForIndex:(int)coverIndex;
- (void)layoutCovers:(int)selected fromCover:(int)lowerBound toCover:(int)upperBound;
- (void)layoutCover:(AFItemView *)aCover selectedCover:(int)selectedIndex animated:(Boolean)animated;
- (AFItemView *)findCoverOnscreen:(CALayer *)targetLayer;
- (void)setSelectedCover:(int)newSelectedCover;
- (void)centerOnSelectedCover:(BOOL)animated;

@end

@implementation AFOpenFlowView (hidden)

//初始化
- (void)setUpInitialState {
	
	// Create data holders for onscreen & offscreen covers & UIImage objects.
	coverImages = [[NSMutableDictionary alloc] init];
	coverImageHeights = [[NSMutableDictionary alloc] init];
	onscreenCovers = [[NSMutableDictionary alloc] init];
	
	scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
	scrollView.userInteractionEnabled = NO;
	scrollView.multipleTouchEnabled = NO;
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self addSubview:scrollView];
	
	self.multipleTouchEnabled = NO;
	self.userInteractionEnabled = YES;
	self.autoresizesSubviews = YES;
	
	// Initialize the visible and selected cover range.
	lowerVisibleCover = upperVisibleCover = -1;
	selectedCoverView = nil;
	
	// 左右卡片的翻转矩阵
	leftTransform = CATransform3DIdentity;
	leftTransform = CATransform3DRotate(leftTransform, SIDE_COVER_ANGLE, 0.0f, 1.0f, 0.0f);
	rightTransform = CATransform3DIdentity;
	rightTransform = CATransform3DRotate(rightTransform, SIDE_COVER_ANGLE, 0.0f, -1.0f, 0.0f);
	
	//搞点透视效果？
	CATransform3D sublayerTransform = CATransform3DIdentity;
	sublayerTransform.m34 = -0.01;
	[scrollView.layer setSublayerTransform:sublayerTransform];
	
	[super setBounds:self.frame];
	halfScreenWidth = self.bounds.size.width / 2;
	halfScreenHeight = self.bounds.size.height / 2;
	
}

//根据一个index 或者创建一个卡片
- (AFItemView *)coverForIndex:(int)coverIndex 
{
	
	AFItemView * coverView = [[[AFItemView alloc] initWithFrame:CGRectZero] autorelease];
	coverView.number = coverIndex;
	
	//重点在这里
	if (coverIndex>=0) 
	{
		coverIndex=coverIndex % numberOfImages;
	}
	else 
	{
		if(abs(coverIndex) % numberOfImages)
			coverIndex = numberOfImages - (abs(coverIndex) % numberOfImages);
		else 
			coverIndex = abs(coverIndex) % numberOfImages;
		
	}
	
	NSNumber *coverNumber = [NSNumber numberWithInt:coverIndex];
	UIImage *coverImage = (UIImage *)[coverImages objectForKey:coverNumber];
	
	if (coverImage)
	{
		NSNumber *coverImageHeightNumber = (NSNumber *)[coverImageHeights objectForKey:coverNumber];
		if (coverImageHeightNumber)
			[coverView setImage:coverImage originalImageHeight:[coverImageHeightNumber floatValue] reflectionFraction:kReflectionFraction];
	} 
	
	else 
	{
		[coverView setImage:defaultImage originalImageHeight:defaultImageHeight reflectionFraction:kReflectionFraction];
	}
	
	
	return coverView;

}

//一张卡片离开中心的动画
- (void)layoutCover:(AFItemView *)aCover selectedCover:(int)selectedIndex animated:(Boolean)animated  {
	int coverNumber = aCover.number;
	CATransform3D newTransform;
	CGFloat newZPosition = SIDE_COVER_ZPOSITION;
	CGPoint newPosition;
	
	//?
	newPosition.x = halfScreenWidth + aCover.horizontalPosition;
	newPosition.y = halfScreenHeight + aCover.verticalPosition;
	
	//左移 右移 不变
	if (coverNumber < selectedIndex) {
		newPosition.x -= CENTER_COVER_OFFSET;
		newTransform = leftTransform;
	} else if (coverNumber > selectedIndex) {
		newPosition.x += CENTER_COVER_OFFSET;
		newTransform = rightTransform;
	} else {
		newZPosition = 0;
		newTransform = CATransform3DIdentity;
	}
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationBeginsFromCurrentState:YES];
	}
	
	aCover.layer.transform = newTransform;
	aCover.layer.zPosition = newZPosition;
	aCover.layer.position = newPosition;
	
	if (animated) {
		[UIView commitAnimations];
	}
}

//一个序列分别的动画
- (void)layoutCovers:(int)selected fromCover:(int)lowerBound toCover:(int)upperBound {
	AFItemView *cover;
	NSNumber *coverNumber;
	for (int i = lowerBound; i <= upperBound; i++) {
		coverNumber = [[NSNumber alloc] initWithInt:i];
		cover = (AFItemView *)[onscreenCovers objectForKey:coverNumber];
		[coverNumber release];
		[self layoutCover:cover selectedCover:selected animated:YES];
	}
}

//用layer 去找到一个卡片
- (AFItemView *)findCoverOnscreen:(CALayer *)targetLayer {
	// See if this layer is one of our covers.
	NSEnumerator *coverEnumerator = [onscreenCovers objectEnumerator];
	AFItemView *aCover = nil;
	while (aCover = (AFItemView *)[coverEnumerator nextObject])
		if ([[aCover.imageView layer] isEqual:targetLayer])
			break;
	
	return aCover;
}


//居中选中卡片
- (void)centerOnSelectedCover:(BOOL)animated {
	CGPoint selectedOffset = CGPointMake(COVER_SPACING * selectedCoverView.number, 0);
	[scrollView setContentOffset:selectedOffset animated:animated];
}

//选中中间索引时候的所有操作

- (void)setSelectedCover:(int)newSelectedCover 
{
	//没有改变索引  只要居中原来的就行 centerOnSelectedCover
	if (selectedCoverView && (newSelectedCover == selectedCoverView.number))
		return;
	
	//新改变后的最低和最高索引   selected ＝（newLowerBound ＋newUpperBound）／2;
	AFItemView *cover;
	//正常应该是 newSelectedCover - COVER_BUFFER 防止出现小于0的索引
	int newLowerBound = newSelectedCover - COVER_BUFFER;
	//正常应该是 newSelectedCover + COVER_BUFFER 防止出现大于self.numberOfImages - 1的索引
	int newUpperBound = newSelectedCover + COVER_BUFFER;
	
	
	//这个其实是第一次进入初始化第一次看到的页面
	if (!selectedCoverView) 
	{
		//分配加载显示
		for (int i=newLowerBound; i <= newUpperBound; i++) 
		{
			cover = [self coverForIndex:i];
			[onscreenCovers setObject:cover forKey:[NSNumber numberWithInt:i]];
			[scrollView.layer addSublayer:cover.layer];
			[self layoutCover:cover selectedCover:newSelectedCover animated:NO];
		}
		
		lowerVisibleCover = newLowerBound;
		upperVisibleCover = newUpperBound;
		selectedCoverView = (AFItemView *)[onscreenCovers objectForKey:[NSNumber numberWithInt:newSelectedCover]];
		
		return;
	}
	
	// 一次滑动太猛了  新的最小都大于原来最大  or 新的最大都小于原来最小
	if ((newLowerBound > upperVisibleCover) || (newUpperBound < lowerVisibleCover)) 
	{
		//原来的所有的都从在屏变成离屏
		AFItemView *cover;
		for (int i = lowerVisibleCover; i <= upperVisibleCover; i++) 
		{
			cover = (AFItemView *)[onscreenCovers objectForKey:[NSNumber numberWithInt:i]];
			[cover removeFromSuperview];
			[onscreenCovers removeObjectForKey:[NSNumber numberWithInt:cover.number]];
		}
		
		//重新生成所有在屏
		for (int i=newLowerBound; i <= newUpperBound; i++) 
		{
			cover=[self coverForIndex:i];
			
			[onscreenCovers setObject:cover forKey:[NSNumber numberWithInt:i]];
			[scrollView.layer addSublayer:cover.layer];
			
			//对比上面第一次初始化  这里我们没有
			//用这个[self layoutCover:cover selectedCover:newSelectedCover animated:NO];
			//而是在下面统一使用 [self layoutCovers:newSelectedCover fromCover:newLowerBound toCover:newUpperBound];
		}
		
		lowerVisibleCover = newLowerBound;
		upperVisibleCover = newUpperBound;
		selectedCoverView = (AFItemView *)[onscreenCovers objectForKey:[NSNumber numberWithInt:newSelectedCover]];
		
		//移动所有生成卡片
		[self layoutCovers:newSelectedCover fromCover:newLowerBound toCover:newUpperBound];
		
		return;
	} 
	
	//左滑动
	else if (newSelectedCover > selectedCoverView.number) 
	{
		for (int i=lowerVisibleCover; i < newLowerBound; i++) 
		{
			cover = (AFItemView *)[onscreenCovers objectForKey:[NSNumber numberWithInt:i]];
			[cover removeFromSuperview];
			[onscreenCovers removeObjectForKey:[NSNumber numberWithInt:i]];
			
			upperVisibleCover++;
			cover=[self coverForIndex:upperVisibleCover];
			
			[onscreenCovers setObject:cover forKey:[NSNumber numberWithInt:upperVisibleCover]];
			[scrollView.layer addSublayer:cover.layer];
			[self layoutCover:cover selectedCover:newSelectedCover animated:NO];
		}
		
		lowerVisibleCover = newLowerBound;
		
	} 
	
	//右滑动
	else 
	{
		for (int i=upperVisibleCover; i > newUpperBound; i--) 
		{
			cover = (AFItemView *)[onscreenCovers objectForKey:[NSNumber numberWithInt:i]];
			[cover removeFromSuperview];
			[onscreenCovers removeObjectForKey:[NSNumber numberWithInt:i]];
			
			lowerVisibleCover--;
			cover=[self coverForIndex:lowerVisibleCover];
			[onscreenCovers setObject:cover forKey:[NSNumber numberWithInt:lowerVisibleCover]];
			[scrollView.layer addSublayer:cover.layer];
			[self layoutCover:cover selectedCover:newSelectedCover animated:NO];
		}
		
		upperVisibleCover = newUpperBound;
		
	}
	
	//添加完后 给动画效果
	if (selectedCoverView.number > newSelectedCover)
		[self layoutCovers:newSelectedCover fromCover:newSelectedCover toCover:selectedCoverView.number];
	else if (newSelectedCover > selectedCoverView.number)
		[self layoutCovers:newSelectedCover fromCover:selectedCoverView.number toCover:newSelectedCover];
	
	selectedCoverView = (AFItemView *)[onscreenCovers objectForKey:[NSNumber numberWithInt:newSelectedCover]];
}

@end


@implementation AFOpenFlowView
@synthesize  viewDelegate, numberOfImages, defaultImage;


//从IB初始化
- (void)awakeFromNib {
	[self setUpInitialState];
}

//从代码初始化
- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setUpInitialState];
	}
	
	return self;
}

- (void)dealloc {
	[defaultImage release];
	[scrollView release];
	
	[coverImages release];
	[coverImageHeights release];
	
	[onscreenCovers removeAllObjects];
	[onscreenCovers release];
	
	[super dealloc];
}

//添加完图片 填充scrollView
- (void)setNumberOfImages:(int)newNumberOfImages {
	numberOfImages = newNumberOfImages;
	
	scrollView.contentSize = CGSizeMake(newNumberOfImages * COVER_SPACING + self.bounds.size.width, self.bounds.size.height);
	
	[self setSelectedCover:CENTER_INDEX];
	
	[self centerOnSelectedCover:NO];
}

- (void)dataSourceDefaultImage:(UIImage *)newDefaultImage
{
	[defaultImage release];
	defaultImageHeight = newDefaultImage.size.height;
	defaultImage = [[newDefaultImage addImageReflection:kReflectionFraction] retain];
}

//添加图片了
- (void)setImage:(UIImage *)image forIndex:(int)index {
	
	UIImage *imageWithReflection = [image addImageReflection:kReflectionFraction];
	NSNumber *coverNumber = [NSNumber numberWithInt:index];
	[coverImages setObject:imageWithReflection forKey:coverNumber];
	[coverImageHeights setObject:[NSNumber numberWithFloat:image.size.height] forKey:coverNumber];
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint startPoint = [[touches anyObject] locationInView:self];
	isDraggingACover = NO;
	
	//点中了哪张卡片
	CALayer *targetLayer = (CALayer *)[scrollView.layer hitTest:startPoint];
	AFItemView *targetCover = [self findCoverOnscreen:targetLayer];
	isDraggingACover = (targetCover != nil);

	beginningCover = selectedCoverView.number;
	startPosition = (startPoint.x / 1.5) + scrollView.contentOffset.x;
	
	if (isSingleTap)
		isDoubleTap = YES;
		
	isSingleTap = ([touches count] == 1);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	isSingleTap = NO;
	isDoubleTap = NO;
	
	// Only scroll if the user started on a cover.
	if (!isDraggingACover)
		return;
	
	CGPoint movedPoint = [[touches anyObject] locationInView:self];
	CGFloat offset = startPosition - (movedPoint.x / 1.5);
	CGPoint newPoint = CGPointMake(offset, 0);
	scrollView.contentOffset = newPoint;
	
	int newCover = offset / COVER_SPACING;
	if (newCover != selectedCoverView.number) 
		
		[self setSelectedCover:newCover];
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (isSingleTap) {
		// Which cover did the user tap?
		CGPoint targetPoint = [[touches anyObject] locationInView:self];
		CALayer *targetLayer = (CALayer *)[scrollView.layer hitTest:targetPoint];
		AFItemView *targetCover = [self findCoverOnscreen:targetLayer];
//		if (targetCover && (targetCover.number != selectedCoverView.number))
//			[self setSelectedCover:targetCover.number];
        
        if (targetCover) {
            if(targetCover.number != selectedCoverView.number) {
                [self setSelectedCover:targetCover.number];
            } else {
                if([self.viewDelegate respondsToSelector:@selector(openFlowView:singleTaped:)]) {
                    [self.viewDelegate openFlowView:self singleTaped:selectedCoverView.number];
                    return;
                }
            }
        }
	}
	
	//居中动画
	[self centerOnSelectedCover:YES];
	
	// And send the delegate the newly selected cover message.
	if (beginningCover != selectedCoverView.number)
	{
		int selectNum=selectedCoverView.number;
		
		if (selectNum>=0) 
		{
			selectNum=selectNum % numberOfImages;
		}
		else 
		{
			if(abs(selectNum) % numberOfImages)
				selectNum = numberOfImages - (abs(selectNum) % numberOfImages);
			else 
				selectNum = abs(selectNum) % numberOfImages;
		}
		
		if ([self.viewDelegate respondsToSelector:@selector(openFlowView:selectionDidChange:)])
			[self.viewDelegate openFlowView:self selectionDidChange:selectNum];
	}
}


@end