//
//  BroadView.m
//  SmartGeometry
//
//  Created by kwan terry on 11-12-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BroadView.h"
#import "SCPoint.h"
#import "PenInfo.h"
#import "Threshold.h"
#import "UnitFactory.h"

@implementation BroadView

@synthesize arrayAbandonedStrokes,arrayStrokes;
@synthesize currentColor,currentSize;
@synthesize owner;
@synthesize unitList,graphList,newGraphList,pointGraphList,saveGraphList;
@synthesize context;
@synthesize factory;
@synthesize hasDrawed;
@synthesize graphImageView;
@synthesize graphListSize;
@synthesize currentImage,lastImage;

-(BOOL)isMultipleTouchEnabled 
{
	return NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        
        arrayStrokes = [[NSMutableArray alloc]init];
        arrayAbandonedStrokes = [[NSMutableArray alloc]init];
        
        self.currentSize = 5.0f;
        self.currentColor= [UIColor blackColor];
        
        graphListSize = 0;
        
        factory = [[UnitFactory alloc]init];
        hasDrawed = NO;
        
        undoRedoSolver = [[UndoRedoSolver alloc]init];
        
        unitList = [[NSMutableArray alloc]init];
        graphList = [[NSMutableArray alloc]init];
        newGraphList = [[NSMutableArray alloc]init];
        pointGraphList = [[NSMutableArray alloc]init];
        saveGraphList = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void) viewJustLoaded 
{
    //NSLog(@"%d",111);
    [self setFrame:CGRectMake(0, 0, 1024, 768)];
    
//    UIImage* undoImg = [UIImage imageNamed:@"undo.png"];
//    undoButton = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 648.0f, 100.0f, 100.0f)];
//    [undoButton setImage:undoImg forState:UIControlStateNormal];
//    [undoButton addTarget:self action:@selector(undoFunc:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:undoButton];
//    
//    UIImage* redoImg = [UIImage imageNamed:@"redo.png"];
//    redoButton = [[UIButton alloc]initWithFrame:CGRectMake(100.0f, 648.0f, 100.0f, 100.0f)];
//    [redoButton setImage:redoImg forState:UIControlStateNormal];
//    [redoButton addTarget:self action:@selector(redoFunc:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:redoButton];
//    
//    UIImage* deleteImg = [UIImage imageNamed:@"delete.png"];
//    deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(200.0f, 648.0f, 100.0f, 100.0f)];
//    [deleteButton setImage:deleteImg forState:UIControlStateNormal];
//    [deleteButton addTarget:self action:@selector(deleteFunc:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:deleteButton];
    
//    [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:0 waitUntilDone:YES];
}

-(void)undoFunc
{
    if ([arrayStrokes count]>0)
    {
		NSMutableDictionary* dictAbandonedStroke = [arrayStrokes lastObject];
		[self.arrayAbandonedStrokes addObject:dictAbandonedStroke];
		[self.arrayStrokes removeLastObject];
		[self setNeedsDisplay];
    }
    
    self.currentImage = nil;
    hasDrawed = YES;
    [undoRedoSolver undoWithGraphList:graphList];
    
    [self setNeedsDisplay];
    
}

-(void)redoFunc
{
    if ([arrayAbandonedStrokes count]>0) 
    {
		NSMutableDictionary* dictReusedStroke = [arrayAbandonedStrokes lastObject];
		[self.arrayStrokes addObject:dictReusedStroke];
		[self.arrayAbandonedStrokes removeLastObject];
		[self setNeedsDisplay];
	}
    
    self.currentImage = nil;
    hasDrawed = YES;
    [undoRedoSolver redoWithGraphList:graphList];
    
    [self setNeedsDisplay];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableArray*      arrayPointsInStroke = [[NSMutableArray alloc]init];
    NSMutableDictionary* dictStroke          = [[NSMutableDictionary alloc]init];
    [dictStroke setObject:arrayPointsInStroke forKey:@"points"];
    
    UITouch* touch = [touches anyObject];
    previousPoint1 = [touch previousLocationInView:self];
    previousPoint2 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    
    SCPoint* scpoint = [[SCPoint alloc]initWithX:currentPoint.x andY:currentPoint.y];
    [arrayPointsInStroke addObject:scpoint];
    [self.arrayStrokes addObject:dictStroke];
    
    UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.lastImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    previousPoint2 = previousPoint1;
    previousPoint1 = [touch previousLocationInView:self];
    currentPoint   = [touch locationInView:self];

    //计算中点
    CGPoint mid1 = CGPointMake((previousPoint1.x+previousPoint2.x)*0.5, (previousPoint1.y+previousPoint2.y)*0.5);
    CGPoint mid2 = CGPointMake((currentPoint.x+previousPoint1.x)*0.5, (currentPoint.y+previousPoint1.y)*0.5);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(path, NULL, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    CGRect bounds = CGPathGetBoundingBox(path);
    CGPathRelease(path);
    
    CGRect drawBox = bounds;
    
    //Pad our values so the bounding box respects our line width
    drawBox.origin.x        -= self.currentSize * 2;
    drawBox.origin.y        -= self.currentSize * 2;
    drawBox.size.width      += self.currentSize * 4;
    drawBox.size.height     += self.currentSize * 4;
    
    UIGraphicsBeginImageContext(drawBox.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.currentImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    SCPoint* scpoint = [[SCPoint alloc]initWithX:currentPoint.x andY:currentPoint.y];
    
    NSMutableArray* arrayPointsInStroke = [[self.arrayStrokes lastObject]objectForKey:@"points"];
    [arrayPointsInStroke addObject:scpoint];
    
    [self setNeedsDisplayInRect:drawBox];
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    self.currentImage = nil;
    
    [self.arrayAbandonedStrokes removeAllObjects];
    [graphList removeAllObjects];
    NSDictionary* dictStroke = [arrayStrokes lastObject];
    NSMutableArray* arrayPointsInStroke = [dictStroke objectForKey:@"points"];
    
    //获取图形数
    graphListSize = newGraphList.count;
    //识别
    [factory createWithPoint:arrayPointsInStroke Unit:unitList Graph:graphList PointGraph:pointGraphList NewGraph:newGraphList];
    [unitList removeAllObjects];
    //约束
    Constraint* constructor = [[Constraint alloc]initWithPointList:pointGraphList GraphList:graphList SeletedList:newGraphList];
    [constructor setLastGraphSize:graphListSize];
    //构建约束
    [constructor recognizeConstraint];
    
    NSLog(@"delete graph list count: %d",constructor.delete_graph.count);
    
    if(graphListSize >= graphList.count)
    {
        SCGraph* lastGraph = [graphList lastObject];
        lastGraph.strokeSize = currentSize;
        [lastGraph setGraphColorWithColorRef:self.currentColor.CGColor];
    }
    
    for(int i=graphListSize; i<graphList.count; i++)
    {
        SCGraph* graphTemp = [graphList objectAtIndex:i];
        graphTemp.strokeSize = currentSize;
        [graphTemp setGraphColorWithColorRef:self.currentColor.CGColor];
    }
    
    for(SCGraph* graphDel in constructor.delete_graph)
    {
        [newGraphList removeObject:graphDel];
    }
    NSMutableArray* deleteGraph = constructor.delete_graph;
    [constructor.delete_graph removeAllObjects];
    if(deleteGraph.count != 0)
    {
        //更新图形数
        graphListSize -= deleteGraph.count;
    }
    
    SCGraph* lastGraph = [graphList lastObject];
    lastGraph.strokeSize = currentSize;
    [lastGraph setGraphColorWithColorRef:self.currentColor.CGColor];
    
    NSLog(@"graph list count: %d", graphList.count);
    NSLog(@"new graph list count: %d", newGraphList.count);
    
    [arrayStrokes removeLastObject];
    hasDrawed = YES;
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{  
    //计算中点
    CGPoint mid1 = CGPointMake((previousPoint1.x+previousPoint2.x)*0.5, (previousPoint1.y+previousPoint2.y)*0.5);
    CGPoint mid2 = CGPointMake((currentPoint.x+previousPoint1.x)*0.5, (currentPoint.y+previousPoint1.y)*0.5);
    
    context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    
    [self.currentImage drawAtPoint:CGPointMake(0, 0)];
    
    CGContextMoveToPoint(context, mid1.x, mid1.y);
    // Use QuadCurve is the key
    CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y); 
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetMiterLimit(context, 2.0);
    CGContextSetLineWidth(context, self.currentSize);
    CGContextSetStrokeColorWithColor(context, self.currentColor.CGColor);
    CGContextStrokePath(context);
    
    if(hasDrawed)
    {
        CGContextClearRect(context, self.bounds);
        hasDrawed = NO;
    }
    
    for(int i=0; i<graphList.count; i++)
    {
        SCGraph* graph = [graphList objectAtIndex:i];
        if(graph.isDraw)
        {
//            CGContextSetLineWidth(context, graph.strokeSize);
//            CGContextSetStrokeColorWithColor(context, graph.graphColor);
            [graph drawWithContext:context];
        }
    }
    
    [super drawRect:rect];
}

-(void)dealloc
{
    [super dealloc];
    
    [arrayStrokes release];
    [arrayAbandonedStrokes release];
    [unitList release];
    [graphList release];
    [pointGraphList release];
    [saveGraphList release];
    [factory release];
    [undoRedoSolver release];
    [currentImage release];
    [lastImage release];
    [currentColor release];
}

@end
