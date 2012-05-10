//
//  CurveUnit.m
//  SmartGeometry
//
//  Created by kwan terry on 12-1-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "CurveUnit.h"

@implementation CurveUnit

@synthesize aFactor,bFactor,cFactor,dFactor,eFactor,fFactor;
@synthesize alpha,originalAlpha;
@synthesize majorAxis,minorAxis,originalMajor,originalMinor;
@synthesize startAngle,endAngle;
@synthesize isAntiClockCurve,isEllipse,isCompleteCurve,isHalfCurve,isArcGroup,isSplineGroup;
@synthesize isXDecrease,isXIncrease,isYDecrease,isYIncrease,hasSecondJudge;
@synthesize curveType;
@synthesize center,move,f1,f2,testE,testS;
@synthesize curveTrack,newDrawPointList,newSpecialPointList,arcIndexArray,arcUnitArray,artBoolArray;
@synthesize px,py,ph,psx;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        isAntiClockCurve = YES;
        isArcGroup = NO;
        isSplineGroup = NO;
        isXIncrease = NO;
        isXDecrease = NO;
        isYIncrease = NO;
        isYDecrease = NO;
        
        center = [[SCPoint alloc]init];
        move   = [[SCPoint alloc]init];
//        self.start  = [[SCPoint alloc]init];
//        self.end    = [[SCPoint alloc]init];
        f1     = [[SCPoint alloc]init];
        f2     = [[SCPoint alloc]init];
        testS  = [[SCPoint alloc]init];
        testE  = [[SCPoint alloc]init];
        curveTrack = [[NSMutableArray alloc]init];
        newDrawPointList = [[NSMutableArray alloc]init];
        newSpecialPointList = [[NSMutableArray alloc]init];
        arcIndexArray = [[NSMutableArray alloc]init];
        arcUnitArray = [[NSMutableArray alloc]init];
        arcBoolArray = [[NSMutableArray alloc]init];
    }
    
    return self;
}

-(id)initWithSPoint:(SCPoint *)startPoint EPoint:(SCPoint *)endPoint
{
    [self init];
    [self initWithStartPoint:startPoint endPoint:endPoint];
    
    curveType       = 1;
    self.type            = 2;
    
    isHalfCurve     = NO;
    isCompleteCurve = NO;
    hasSecondJudge  = NO;
    self.isSelected = NO;
    
    return self;
}

-(id)initWithAFactor:(float)a BFactor:(float)b CFactor:(float)c DFactor:(float)d EFactor:(float)e FFactor:(float)f
{
    [self init];
    
    curveType   = 1;//椭圆或圆形类型
    self.type        = 2;//二次曲线类型
    
    aFactor     = a;
    bFactor     = b;
    cFactor     = c;
    dFactor     = d;
    eFactor     = e;
    fFactor     = f;
    
    isHalfCurve     = NO;
    isCompleteCurve = NO;
    hasSecondJudge  = NO;
    self.isSelected = NO;
    
    return self;
}

-(id)initWithPointArray:(NSMutableArray *)pointList ID:(int)idNum
{
    [self init];
    
    self.type = 2;       //二次曲线类型
    curveType = 1;  //椭圆或圆形类型
    
    SCPoint* tempStart = [pointList objectAtIndex:0];
    self.start.x = tempStart.x;
    self.start.y = tempStart.y;
    
    SCPoint* tempEnd = [pointList lastObject];
    self.end.x = tempEnd.x;
    self.end.y = tempEnd.y;
    
    isHalfCurve = NO;
    isCompleteCurve = NO;
    self.isSelected = NO;
    
    float xArray[6] = {0};
    [self identifyWithPointArray:pointList XArray:xArray];
    [self judgeCurveWithPointArray:pointList];
    
    hasSecondJudge = NO;
    
    curveTrack = pointList;
    
    return self;
}

-(id)initWithPointArray:(NSMutableArray *)pointList
{
    [self init];
    
    self.type = 2;       //二次曲线类型
    curveType = 1;  //椭圆或圆形类型
    
    SCPoint* tempPoint = [[SCPoint alloc]init];
    if(pointList.count != 0)
    {
        tempPoint = [pointList objectAtIndex:0];
        self.start.x = tempPoint.x;
        self.start.y = tempPoint.y;
        tempPoint = [pointList objectAtIndex:pointList.count-1];
        self.end.x   = tempPoint.x;
        self.end.y   = tempPoint.y;
        
        isHalfCurve     = NO;
        isCompleteCurve = NO;
        hasSecondJudge  = NO;
        self.isSelected = NO;
        
        float xArray[6];
        [self identifyWithPointArray:pointList XArray:xArray];
        
        curveTrack = pointList;
        
        testS.x = self.start.x;
        testS.y = self.start.y;
        testE.x = self.end.x;
        testE.y = self.end.y;
        
    }
    
    return self;
}

-(void)judgeCurveWithPointArray:(NSMutableArray *)pointList
{
    if([self isSecondDegreeCurveWithPointArray:pointList])
    {
        //是二次曲线
        [self convertToStandardCurve];      //化简为标准方程
        float totalLength = 0.0f;
        int count = pointList.count;
        for(int i=1; i<count; i++)
        {
            totalLength += [self calculateDistanceWithPoint1:[pointList objectAtIndex:i] Point2:[pointList objectAtIndex:i-1]];
        }
        if([self calculateDistanceWithPoint1:[pointList objectAtIndex:0] Point2:[pointList objectAtIndex:count-1]] < totalLength*0.1)
        {
            self.end.x = self.start.x;
            self.end.y = self.start.y;
        }
        [self setStartTOEndAntiClockWithPointArray:pointList];
        [self calculateStartAndEndAngle];
        [self calculateNewDrawSecCurveTrack];
    }
    else
    {
        //非二次曲线
        self.type        = 3;
        curveTrack  = pointList;
        [self calculateCubicSplineWithPointList:pointList];
        [self calculateNewDrawPointList];
        [self calculateStartAndEndAngle];
    }
}

-(void)setOriginalAlpha
{
    originalAlpha = alpha;
}

-(void)setOriginalMajorAndOriginalMinor
{
    originalMajor = majorAxis;
    originalMinor = minorAxis;
}

-(void)identifyWithPointArray:(NSMutableArray *)pointList XArray:(float[6])xArray
{
    //--------------------------------------
    //二次曲线识别判断
    //--------------------------------------
    //
    //  先构造矩阵
    //  | x(4)y(0) x(3)y(1) x(2)y(2) x(3)y(0) x(2)y(1) x(2)y(0) |
    //  | x(3)y(1) x(2)y(2) x(1)y(3) x(2)y(1) x(1)y(2) x(1)y(1) |
    //  | x(2)y(2) x(1)y(3) x(0)y(4) x(1)y(2) x(0)y(3) x(0)y(2) |
    //  | x(3)y(0) x(2)y(1) x(1)y(2) x(2)y(0) x(1)y(1) x(1)y(0) |
    //  | x(2)y(1) x(1)y(2) x(0)y(3) x(1)y(1) x(0)y(2) x(0)y(1) |
    //
    //  aX^2+bXY+cY^2+dX+eY+f = 0;//椭圆方程
    //  aX^2+bXY+cY^2+dX+eY   = -f;//椭圆方程
    //  x(2)    xy  y(2)    x   y
    
    int count = pointList.count;
    float f = 1000000;
    
    float aArray[5][6];
    float bArray[5][2];
    
    for(int i=0; i<5; i++)
    {
        for(int j=0; j<6; j++)
            aArray[i][j] = 0.0f;
    }
    bArray[0][0]=2;bArray[0][1]=0;
    bArray[1][0]=1;bArray[1][1]=1;
    bArray[2][0]=0;bArray[2][1]=2;
    bArray[3][0]=1;bArray[3][1]=0;
    bArray[4][0]=0;bArray[4][1]=1;
    
    for(int i=0; i<count; i++)      //对于每个点
    {
        SCPoint* pointTemp = [pointList objectAtIndex:i];
        for(int j=0; j<5; j++)      //行
        {
            for(int k=0; k<5; k++)  //列
            {
                aArray[j][k] += powf(pointTemp.x, bArray[j][0]+bArray[k][0]) * powf(pointTemp.y, bArray[j][1]+bArray[k][1]);
            }
        }
    }
    for(int i=0; i<count; i++)
    {
        SCPoint* pointTemp = [pointList objectAtIndex:i];
        for(int j=0; j<5; j++)
        {
            aArray[j][5] -= powf(pointTemp.x, bArray[j][0]) * powf(pointTemp.y, bArray[j][1]) * f;
        }
    }
    
    float xAnswerArray[5] = {0};
    [self gaussianEliminationWithRow:5 Column:5 Matrix:aArray Answer:xAnswerArray];
    for(int i=0; i<5; i++)
    {
        xArray[i] = xAnswerArray[i];
    }
    xArray[5] = f;
    aFactor = xArray[0];
    bFactor = xArray[1];
    cFactor = xArray[2];
    dFactor = xArray[3];
    eFactor = xArray[4];
    fFactor = xArray[5];
    
}

-(void)gaussianEliminationWithRow:(int)row Column:(int)col Matrix:(float [5][6])matrix Answer:(float [5])answer
{
    float aArray[row][col+1];
    //将matrix的值赋值给aArray
    for(int i=0; i<row; i++)
    {
        for(int j=0; j<col+1; j++)
        {
            aArray[i][j] = matrix[i][j];
        }
    }
    //行列式变化，得到阶梯矩阵
    for(int j=0; j<row-1; j++)
    {
        for(int i=j+1; i<row; i++)
        {
            float t = aArray[i][j]/aArray[j][j];
            for(int k=j; k<=col; k++)
            {
                aArray[i][k] -= t*aArray[j][k];
            }
        }
    }
    
    //解阶梯型矩阵
    for(int i=col-1; i>=0; i--)
    {
        float sum = 0;
        for(int j=i+1; j<col; j++)
        {
            sum += answer[j]*aArray[i][j];
        }
        answer[i] = (aArray[i][col] - sum)/aArray[i][i];
    }    

    return;
}

-(void)convertToStandardCurve
{
    //平移标准化
    float y0 = (2*aFactor*eFactor - bFactor*dFactor)/(bFactor*bFactor - 4*aFactor*cFactor);
    float x0 = -(dFactor + bFactor*y0)/(2*aFactor);
    
    center.x = x0;  //二次曲线中心
    center.y = y0;  //二次曲线中心
    move.x = x0;
    move.y = y0;
    
    fFactor = aFactor*x0*x0 + bFactor*x0*y0 + cFactor*y0*y0 + dFactor*x0 + eFactor*y0 + fFactor;
    dFactor = eFactor = 0.0f;
    
    self.start.x -= center.x;
    self.start.y -= center.y;
    self.end.x   -= center.x;
    self.end.y   -= center.y;
    
    //旋转标准化逆时针旋转
    //  |               |
    //  |   cos     sin |
    //  |   -sin    cos |
    //  |               |
    alpha = atanf((bFactor + 0.00000000001) / (aFactor - cFactor + 0.00000000001));
    alpha /= 2.0f;
    originalAlpha = alpha;
    
    float tempA = aFactor;
    float tempB = bFactor;
    float tempC = cFactor;
    
    float cos = cosf(alpha);
    float sin = sinf(alpha);
    aFactor = tempA*cos*cos + tempB*sin*cos + tempC*sin*sin;
    bFactor = (tempC - tempA)*sin*cos + (tempB/2.0)*(cos*cos - sin*sin);
    cFactor = tempA*sin*sin - tempB*sin*cos + tempC*cos*cos;
    
    SCPoint* tempPoint = [[SCPoint alloc]initWithX:self.start.x andY:self.start.y];
    self.start.x = tempPoint.x*cos + tempPoint.y*sin;
    self.start.y = tempPoint.x*(-sin) + tempPoint.y*cos;
    tempPoint.x = self.end.x;
    tempPoint.y = self.end.y;
    self.end.x = tempPoint.x*cos + tempPoint.y*sin;
    self.end.y = tempPoint.x*(-sin) + tempPoint.y*cos;
    
    if(curveType == 1)//圆形或者椭圆
    {
        if(fFactor/aFactor > 0) 
            aFactor = -aFactor;
        if(fFactor/aFactor > 0)
            cFactor = -cFactor;
        //圆形或者椭圆标准化
        float k = aFactor/cFactor;
        if(k > 1.0/circle_jude && k<circle_jude)
        {
            k = (aFactor + cFactor)/2.0;
            aFactor = cFactor = k;
            isEllipse = false;
        }
        else
        {
            isEllipse = true;
        }
        
        //将起点和终点缩放到椭圆上
        k = sqrtf(-fFactor / (aFactor*self.start.x*self.start.x + cFactor*self.start.y*self.start.y));
        self.start.x = self.start.x*k;
        self.start.y = self.start.y*k;
        k = sqrtf(-fFactor / (aFactor*self.end.x*self.end.x + cFactor*self.end.y*self.end.y));
        self.end.x = self.end.x*k;
        self.end.y = self.end.y*k;
            
        majorAxis = sqrt(-fFactor/aFactor);
        minorAxis = sqrtf(-fFactor/cFactor);
    }
    else if(curveType == 2)//双曲线
    {
        if((fFactor/aFactor)<0 && (fFactor/cFactor)>0)
        {
            //x轴方向为虚轴,majorAxis为负
            majorAxis = -sqrtf(-fFactor/aFactor);
            minorAxis = sqrtf(fFactor/cFactor);
            if(self.start.y >= 0)
            {
                self.start.y = sqrtf((majorAxis*majorAxis*minorAxis*minorAxis + minorAxis*minorAxis*self.start.x*self.start.x)/
                                (majorAxis*majorAxis));
            }
            else
            {
                self.start.y = -sqrtf((majorAxis*majorAxis*minorAxis*minorAxis + minorAxis*minorAxis*self.start.x*self.start.x)/
                                 (majorAxis*majorAxis));
            }
            if(self.end.y >= 0)
            {
                self.end.y = sqrtf((majorAxis*majorAxis*minorAxis*minorAxis + minorAxis*minorAxis*self.end.x*self.end.x)/
                              (majorAxis*majorAxis));
            }
            else
            {
                self.end.y = -sqrtf((majorAxis*majorAxis*minorAxis*minorAxis + minorAxis*minorAxis*self.end.x*self.end.x)/
                              (majorAxis*majorAxis));
            }
        }
        if((fFactor/cFactor)<0 && (fFactor/aFactor)>0)
        {
            //y轴方向为虚轴,minorAxis为负
            alpha += PI/2;
            majorAxis = -sqrtf(-fFactor/cFactor);
            minorAxis = sqrtf(fFactor/aFactor);
            
            float tempA = aFactor;
            float tempB = bFactor;
            float tempC = cFactor;
            float cos   = cosf(PI/2);
            float sin   = sinf(PI/2);
            aFactor = tempA*cos*cos + tempB*sin*cos + tempC*sin*sin;
            bFactor = (tempC-tempA)*sin*cos + (tempB/2.0)*(cos*cos-sin*sin);
            cFactor = tempA*sin*sin - tempB*sin*cos + tempC*cos*cos;
            
            SCPoint* tempPoint = [[SCPoint alloc]initWithX:self.start.x andY:self.start.y];
            self.start.x = tempPoint.x*cos + tempPoint.y*sin;
            self.start.y = tempPoint.x*(-sin) + tempPoint.y*cos;
            tempPoint.x = self.end.x;
            tempPoint.y = self.end.y;
            self.end.x = tempPoint.x*cos + tempPoint.y*sin;
            self.end.y = tempPoint.x*(-sin) + tempPoint.y*cos;
            
            [tempPoint release];
            tempPoint = NULL;
            
            if(self.start.y >= 0)
            {
                self.start.y = sqrtf((majorAxis*majorAxis*minorAxis*minorAxis + minorAxis*minorAxis*self.start.x*self.start.x)/
                                (majorAxis*majorAxis));
            }
            else
            {
                self.start.y = -sqrtf((majorAxis*majorAxis*minorAxis*minorAxis + minorAxis*minorAxis*self.start.x*self.start.x)/(majorAxis*majorAxis));
            }
            if(self.end.y >= 0)
            {
                self.end.y = sqrtf((majorAxis*majorAxis*minorAxis*minorAxis + minorAxis*minorAxis*self.end.x*self.end.x)/
                              (majorAxis*majorAxis));
            }
            else
            {
                self.end.y = -sqrtf((majorAxis*majorAxis*minorAxis*minorAxis + minorAxis*minorAxis*self.end.x*self.end.x)/
                               (majorAxis*majorAxis));
            }
            
        }
    }
    [self setOriginalMajorAndOriginalMinor];
}

-(void)setStartTOEndAntiClockWithPointArray:(NSMutableArray *)pointList
{
    //进行判断，使得Start到End为逆时针方向
    int number = pointList.count;
    int countForNoAnti=0,countForAnti=0;
    SCPoint* firstPoint = [pointList objectAtIndex:0];
    SCPoint* lastPoint  = [pointList objectAtIndex:number-1];
    
    int deltaX = lastPoint.x - firstPoint.x;
    int deltaY = lastPoint.y - firstPoint.y;
    int varyDeltaX,varyDeltaY;
    
    SCPoint* tempPoint;
    float compare10,compareLast;
    
    if(number > 10)
    {
        tempPoint   = [pointList objectAtIndex:0];
        float lineK = (tempPoint.y - center.y)/(tempPoint.x - center.x);
        float lineB = (tempPoint.y - lineK*tempPoint.x);
        
        tempPoint = [pointList objectAtIndex:10];
        compare10 = lineK*tempPoint.x - lineB - tempPoint.y;
        tempPoint = [pointList objectAtIndex:number-1];
        compareLast = lineK*tempPoint.x - lineB - tempPoint.y;
    }
    SCPoint* tempPointAt0 = [pointList objectAtIndex:0];
    for(int i=1; i<number-1; i++)
    {
        tempPoint  = [pointList objectAtIndex:i];
        varyDeltaX = tempPoint.x - tempPointAt0.x;
        varyDeltaY = tempPoint.y - tempPointAt0.y;
        if(deltaX*varyDeltaY > deltaY*varyDeltaX)
        {
            countForNoAnti++;
        }
        else
        {
            countForAnti++;
        }
    }
    if(countForNoAnti > countForAnti)
    {
        SCPoint* tempPoint = [[SCPoint alloc]initWithX:self.start.x andY:self.start.y];
        self.start.x = self.end.x;
        self.start.y = self.end.y;
        
        self.end.x = tempPoint.x;
        self.end.y = tempPoint.y;
        
        isAntiClockCurve = NO;
    }
    
    if(![self hasSecondJudge])
        [self secondJudgeIsCompleteCurveWithPointArray:pointList];
    
}

-(void)recalculateSecCurveTrackWithPointList:(NSMutableArray *)pointList
{
    if(self.type == 2 && self.curveType == 1)
    {
        int count = pointList.count;
        float f = 1000000;
        
        float aArray[5][6];
        float bArray[5][2];
        
        for(int i=0; i<5; i++)
        {
            for(int j=0; j<6; j++)
                aArray[i][j] = 0.0f;
        }
        bArray[0][0]=2;bArray[0][1]=0;
        bArray[1][0]=1;bArray[1][1]=1;
        bArray[2][0]=0;bArray[2][1]=2;
        bArray[3][0]=1;bArray[3][1]=0;
        bArray[4][0]=0;bArray[4][1]=1;
        
        for(int i=0; i<count; i++)      //对于每个点
        {
            SCPoint* pointTemp = [pointList objectAtIndex:i];
            for(int j=0; j<5; j++)      //行
            {
                for(int k=0; k<5; k++)  //列
                {
                    aArray[j][k] += powf(pointTemp.x, bArray[j][0]+bArray[k][0]) * powf(pointTemp.y, bArray[j][1]+bArray[k][1]);
                }
            }
        }
        for(int i=0; i<count; i++)
        {
            SCPoint* pointTemp = [pointList objectAtIndex:i];
            for(int j=0; j<5; j++)
            {
                aArray[j][5] -= powf(pointTemp.x, bArray[j][0]) * powf(pointTemp.y, bArray[j][1]) * f;
            }
        }
        
        float xArray[6] = {0};
        float xAnswerArray[5] = {0};
        [self gaussianEliminationWithRow:5 Column:5 Matrix:aArray Answer:xAnswerArray];
        for(int i=0; i<5; i++)
        {
            xArray[i] = xAnswerArray[i];
        }
        xArray[5] = f;
        aFactor = xArray[0];
        bFactor = xArray[1];
        cFactor = xArray[2];
        dFactor = xArray[3];
        eFactor = xArray[4];
        fFactor = xArray[5];
        
//        SCPoint* point  = [pointList objectAtIndex:0];
//        float k1 = aFactor*point.x*point.x + bFactor*point.x*point.y + cFactor*point.y*point.y + dFactor*point.x + eFactor*point.y + fFactor;
//        SCPoint* point1 = [pointList objectAtIndex:1];
//        float k2 = aFactor*point1.x*point1.x + bFactor*point1.x*point1.y + cFactor*point1.y*point1.y + dFactor*point1.x + eFactor*point1.y + fFactor;
//        SCPoint* point2 = [pointList objectAtIndex:2];
//        float k3 = aFactor*point2.x*point2.x + bFactor*point2.x*point2.y + cFactor*point2.y*point2.y + dFactor*point2.x + eFactor*point2.y + fFactor;
//        SCPoint* point3 = [pointList objectAtIndex:3];
//        float k4 = aFactor*point3.x*point3.x + bFactor*point3.x*point3.y + cFactor*point3.y*point3.y + dFactor*point3.x + eFactor*point3.y + fFactor;
//        SCPoint* point4 = [pointList objectAtIndex:3];
//        float k5 = aFactor*point4.x*point4.x + bFactor*point4.x*point4.y + cFactor*point4.y*point4.y + dFactor*point4.x + eFactor*point4.y + fFactor;
        
        [self recalculateDrawSecCurveTrack:pointList];
    }
}

-(void)recalculateDrawSecCurveTrack:(NSMutableArray *)pointList
{
    NSMutableArray* newDrawTrack = [[NSMutableArray alloc]init];
    SCPoint* tempPoint = [pointList objectAtIndex:0];
    SCPoint* lastPoint = tempPoint;
    [newDrawTrack addObject:tempPoint];
    for(int i=1; i<[newDrawPointList count]-1; i++)
    {
        tempPoint = [newDrawPointList objectAtIndex:i];
        SCPoint* newPoint = [self recalculateNewPointWithTempPoint:tempPoint LastPoint:lastPoint];
        lastPoint = tempPoint;
        [newDrawTrack addObject:newPoint];
    }
    tempPoint = [pointList lastObject];
    [newDrawTrack addObject:tempPoint];
    [newDrawPointList removeAllObjects];
    newDrawPointList = newDrawTrack;
}

-(SCPoint*)recalculateNewPointWithTempPoint:(SCPoint *)tempPoint LastPoint:(SCPoint *)lastPoint
{
    float a = self.cFactor;
    float b = self.eFactor + bFactor*tempPoint.x;
    float c = self.aFactor*tempPoint.x*tempPoint.x + dFactor*tempPoint.x + fFactor;
    
    if((b*b - 4*a*c) <= 0)
    {
        return tempPoint;
    }
    
    float y1 = ((-b) + sqrtf(b*b-4*a*c))/(2*a);
    float y2 = ((-b) - sqrtf(b*b-4*a*c))/(2*a);
    
    float d1 = [Threshold Distance:lastPoint :[[SCPoint alloc]initWithX:tempPoint.x andY:y1]];
    float d2 = [Threshold Distance:lastPoint :[[SCPoint alloc]initWithX:tempPoint.x andY:y2]];
    
    if(d1 < d2)
    {
        return [[SCPoint alloc]initWithX:tempPoint.x andY:y1];
    }
    else if(d1 > d2)
    {
        return [[SCPoint alloc]initWithX:tempPoint.x andY:y2];
    }
    else
    {
        return NULL;
    }
    
}

-(NSMutableArray*)findCalculatePoints:(NSMutableArray *)pointList
{
    NSMutableArray* returnPList = [[NSMutableArray alloc]init];
    //寻找拐点
    for(int i=1; i<[pointList count]-1; i++)
    {
        SCPoint* lastPoint = [pointList objectAtIndex:i-1];
        SCPoint* currentPoint = [pointList objectAtIndex:i];
        SCPoint* nextPoint = [pointList objectAtIndex:i+1];
        
        if((currentPoint.x < lastPoint.x && currentPoint.x < nextPoint.x) || (currentPoint.x > lastPoint.x && currentPoint.x > nextPoint.x))
        {
            [returnPList addObject:currentPoint];
        }
        
        if((currentPoint.y < lastPoint.y && currentPoint.y < nextPoint.y) || (currentPoint.y > lastPoint.y && currentPoint.y > nextPoint.y))
        {
            [returnPList addObject:currentPoint];
        }
    }
    return returnPList;
}

-(void)calculateNewDrawSecCurveTrack
{
    if(self.type == 2 && self.curveType == 1)
    {
        [self.newDrawPointList removeAllObjects];
        
        int leftFocusX=0,leftFocusY=0;          //左焦点
        int rightFocusX=0,rightFocusY=0;        //右焦点
        bool ellipseBool = YES;                 //默认是椭圆
        float focusLength = sqrtf(abs(majorAxis*majorAxis - minorAxis*minorAxis));
        if(majorAxis > minorAxis)
        {
            leftFocusX  = (int)focusLength;
            rightFocusX = -(int)focusLength;
        }
        else if(minorAxis == majorAxis)
        {
            ellipseBool = NO;
        }
        else if(majorAxis < minorAxis)
        {
            leftFocusY  = (int)focusLength;
            rightFocusY = -(int)focusLength;
        }
        
        float startAngleLocal,endAngleLocal;
        [self calculateStartAndEndAngleWithStartAngle:startAngleLocal EndAngle:endAngleLocal];
        
        float a = fabsf(majorAxis);
        float b = fabsf(minorAxis);
        
        //计算起始点和终止点后先画出椭圆曲线
        float add = 2*PI/draw_circle_increment;
        float x,y;
        x = (a*cosf(startAngle));
        y = (b*sinf(startAngle));
        [self translateAndRotationWithX:&x Y:&y Theta:alpha Point:[[SCPoint alloc]initWithX:move.x andY:move.y]];
        NSLog(@"识别出来的点！！！！！%f,%f",x,y);
        [self.newDrawPointList addObject:[[SCPoint alloc]initWithX:x andY:y]];
        
        for(float i=startAngle; i<=endAngle; i+=add)
        {
            x = a*cosf(i);
            y = b*sinf(i);
            [self translateAndRotationWithX:&x Y:&y Theta:alpha Point:[[SCPoint alloc]initWithX:move.x andY:move.y]];
            [self.newDrawPointList addObject:[[SCPoint alloc]initWithX:x andY:y]];
        }
    }
    else if(self.type == 2 && self.curveType == 2)
    {
        float a = fabsf(majorAxis);
        float b = fabsf(minorAxis);
        float c = sqrtf(a*a+b*b);
        //计算出起始角度和终止角度
        startAngle = atanf(self.start.y/b);
        endAngle   = atanf(self.end.y/b);
        if(minorAxis < 0)
        {
            if(self.start.x < 0)
            {
                startAngle = PI - startAngle;
            }
            if(self.end.x < 0)
            {
                endAngle = PI - endAngle;
            }
            f1.x = 0;
            f1.y = c;
            f2.x = 0;
            f2.y = -c;
        }
        else if(majorAxis < 0)
        {
            if(self.start.x < 0)
            {
                startAngle = PI - startAngle;
            }
            if(self.end.x < 0)
            {
                endAngle = PI - endAngle;
            }
            f1.x = c;
            f1.y = 0;
            f2.x = -c;
            f2.y = 0;
        }
        //计算出起始点和终止点后画出二次曲线（双曲线的一半）
        float add = 2*PI/draw_circle_increment;
        float x,y;
        x = (a/cosf(startAngle));
        y = (b*tanf(startAngle));
        [self translateAndRotationWithX:&x Y:&y Theta:alpha Point:move];
        [self.newDrawPointList addObject:[[SCPoint alloc]initWithX:x andY:y]];
        for(float i=startAngle; i>=endAngle; i-=add)
        {
            x = a/cosf(i);
            y = b*tanf(i);
            [self translateAndRotationWithX:&x Y:&y Theta:alpha Point:move];
            [self.newDrawPointList addObject:[[SCPoint alloc]initWithX:x andY:y]];
        }
    }
}

-(void)makeCurveSmoothToLastCurve:(CurveUnit *)lastCurve
{
    if(lastCurve != NULL)
    {
        //旋转部分先不实现
//        float aimAngle;
//        float originAngle;
//        float lastStartAngle = lastCurve.startAngle;
//        float lastEndAngle   = lastCurve.endAngle;
//        float nowStartAngle  = self.startAngle;
//        float nowEndAngle    = self.endAngle;
//        
//        if(lastCurve.isAntiClockCurve)  //上条曲线是顺时针
//        {
//            aimAngle = lastEndAngle;
//        }
//        else
//        {
//            aimAngle = lastStartAngle;
//        }
//        if(isAntiClockCurve)    //这条曲线是顺时针
//        {
//            originAngle = nowStartAngle;
//        }
//        else
//        {
//            originAngle = nowEndAngle;
//        }
//        float rotateAngle = (aimAngle+lastCurve.alpha) - (originAngle+alpha);
//        for(int i=0; i<[newDrawSecCurveTrack count]; i++)
//        {
//            SCPoint* tempPoint = [newDrawSecCurveTrack objectAtIndex:i];
//            [self rotationWithPoint:tempPoint Theta:rotateAngle];
//        }
        
        
        SCPoint* aimPoint    = [[SCPoint alloc]init];
        SCPoint* originPoint = [[SCPoint alloc]init];
        SCPoint* lastStart   = [lastCurve.newDrawPointList objectAtIndex:0];
        SCPoint* lastEnd     = [lastCurve.newDrawPointList lastObject];
        SCPoint* nowStart    = [newDrawPointList objectAtIndex:0];
        SCPoint* nowEnd      = [newDrawPointList lastObject];
        
        if(lastCurve.isAntiClockCurve)  //上条曲线是顺时针
        {
            aimPoint.x = lastEnd.x;
            aimPoint.y = lastEnd.y;
        }
        else
        {
            aimPoint.x = lastStart.x;
            aimPoint.y = lastStart.y;
        }
        if(isAntiClockCurve)    //这条曲线是顺时针
        {
            originPoint.x = nowStart.x;
            originPoint.y = nowStart.y;
        }
        else
        {
            originPoint.x = nowEnd.x;
            originPoint.y = nowEnd.y;
        }
        SCPoint* vector = [[SCPoint alloc]initWithX:aimPoint.x-originPoint.x andY:aimPoint.y-originPoint.y];
        [self translateAndRotationWithPoint:center Theta:0 Point:vector];
        [self setMove:center];
        for(int i=0; i<[newDrawPointList count]; i++)
        {
            SCPoint* tempPoint = [newDrawPointList objectAtIndex:i];
            tempPoint = [self translateWithPoint:tempPoint Vector:vector];
        }
    }
}

-(NSMutableArray*)findSpecialPointWithPointList:(NSMutableArray*)pointListTemp
{
//    newSpecialPointList = [[NSMutableArray alloc]init];
    isXIncrease = NO;
    isXDecrease = NO;
    isYIncrease = NO;
    isYDecrease = NO;
    [arcUnitArray removeAllObjects];
    [arcBoolArray removeAllObjects];
    [arcIndexArray removeAllObjects];
    [newSpecialPointList removeAllObjects];
    
    NSMutableArray* pointList = [[NSMutableArray alloc]init];
    [pointList addObject:[pointListTemp objectAtIndex:0]];
    for(int i=1; i<[pointListTemp count]-1; i++)
    {
        SCPoint* lastPoint = [pointListTemp objectAtIndex:i-1];
        SCPoint* currentPoint = [pointListTemp objectAtIndex:i];
        if(fabs(lastPoint.x - currentPoint.x) > 2.0f && fabs(lastPoint.y - currentPoint.y) > 2.0f)
        {
            [pointList addObject:currentPoint];
        }
    }
    [pointList addObject:[pointListTemp lastObject]];
    
    for(int i=0; i<[pointList count]-1; i++)
    {
        SCPoint* currentPoint = [pointList objectAtIndex:i];
        SCPoint* nextPoint = [pointList objectAtIndex:i+1];
        if(currentPoint.x < nextPoint.x)
        {
            if(!isXDecrease)
            {
                isXIncrease = YES;
            }
            else
            {
                isXIncrease = NO;
                isXDecrease = NO;
                break;
            }
        }
        if(currentPoint.x > nextPoint.x)
        {
            if(!isXIncrease)
            {
                isXDecrease = YES;
            }
            else
            {
                isXIncrease = NO;
                isXDecrease = NO;
                break;
            }
        }
    }
    
    for(int i=0; i<[pointList count]-1; i++)
    {
        SCPoint* currentPoint = [pointList objectAtIndex:i];
        SCPoint* nextPoint = [pointList objectAtIndex:i+1];
        if(currentPoint.y < nextPoint.y)
        {
            if(!isYDecrease)
            {
                isYIncrease = YES;
            }
            else
            {
                isYIncrease = NO;
                isYDecrease = NO;
                break;
            }
        }
        if(currentPoint.y > nextPoint.y)
        {
            if(!isYIncrease)
            {
                isYDecrease = YES;
            }
            else
            {
                isYIncrease = NO;
                isYDecrease = NO;
                break;
            }
        }
    }
    
    if(isXDecrease || isXIncrease)
    {
        [newSpecialPointList addObject:[pointList objectAtIndex:0]];
        //寻找拐点
        for(int i=1; i<[pointList count]-1; i++)
        {
            SCPoint* lastPoint = [pointList objectAtIndex:i-1];
            SCPoint* currentPoint = [pointList objectAtIndex:i];
            SCPoint* nextPoint = [pointList objectAtIndex:i+1];
            
            if((currentPoint.y < lastPoint.y && currentPoint.y < nextPoint.y) || (currentPoint.y > lastPoint.y && currentPoint.y > nextPoint.y))
            {
                [newSpecialPointList addObject:currentPoint];
            }
        }
        [newSpecialPointList addObject:[pointList lastObject]];
    }
    else if(isYDecrease || isYIncrease)
    {
        [newSpecialPointList addObject:[pointList objectAtIndex:0]];
        //寻找拐点
        for(int i=1; i<[pointList count]-1; i++)
        {
            SCPoint* lastPoint = [pointList objectAtIndex:i-1];
            SCPoint* currentPoint = [pointList objectAtIndex:i];
            SCPoint* nextPoint = [pointList objectAtIndex:i+1];
            
            if((currentPoint.x < lastPoint.x && currentPoint.x < nextPoint.x) || (currentPoint.x > lastPoint.x && currentPoint.x > nextPoint.x))
            {
                [newSpecialPointList addObject:currentPoint];
            }
        }
        [newSpecialPointList addObject:[pointList lastObject]];
    }
    else
    {
        [newSpecialPointList addObject:[pointList objectAtIndex:0]];
        [arcIndexArray addObject:[[NSNumber alloc]initWithInt:0]];
        [arcBoolArray addObject:[[NSNumber alloc]initWithBool:NO]];
        //寻找拐点
        for(int i=1; i<[pointList count]-1; i++)
        {
            SCPoint* lastPoint = [pointList objectAtIndex:i-1];
            SCPoint* currentPoint = [pointList objectAtIndex:i];
            SCPoint* nextPoint = [pointList objectAtIndex:i+1];
            
            if(!isArcGroup)
            {
                if((currentPoint.y < lastPoint.y && currentPoint.y < nextPoint.y) || (currentPoint.y > lastPoint.y && currentPoint.y > nextPoint.y))
                {
                    [newSpecialPointList addObject:currentPoint];
                    [arcIndexArray addObject:[[NSNumber alloc]initWithInt:i]];
                    [arcBoolArray addObject:[[NSNumber alloc]initWithBool:NO]];
                }
            }
            
            if((currentPoint.x < lastPoint.x && currentPoint.x < nextPoint.x) || (currentPoint.x > lastPoint.x && currentPoint.x > nextPoint.x))
            {
                [newSpecialPointList addObject:currentPoint];
                [arcIndexArray addObject:[[NSNumber alloc]initWithInt:i]];
                [arcBoolArray addObject:[[NSNumber alloc]initWithBool:YES]];
            }
            
        }
        [newSpecialPointList addObject:[pointList lastObject]]; 
        [arcIndexArray addObject:[[NSNumber alloc]initWithInt:[pointList count]-1]];
        [arcBoolArray addObject:[[NSNumber alloc]initWithBool:NO]];
    }
    
    return pointList;
}


-(NSMutableArray*)calculateCubicNewDrawPointList:(NSMutableArray *)newPointList
{
    int segments = 100;
    int num = [newPointList count];
    
    float px, py;
	float tt, _1t, _2t;
	float h00, h10, h01, h11;
	SCPoint* m0;
	SCPoint* m1;
	SCPoint* m2;
	SCPoint* m3;
    
	float rez = 1.0f / segments;
	unsigned int count = 0;
    
	for (int n = 0; n < num; n++) 
    {
        
        SCPoint* latterPoint = NULL;
        SCPoint* nextPoint = NULL;
        SCPoint* currentPoint = NULL;
        SCPoint* lastPoint = NULL;
        SCPoint* formerPoint = NULL;
        
		for (float t = 0.0f; t < 1.0f; t += rez) 
        {
			tt = t * t;
			_1t = 1 - t;
			_2t = 2 * t;
			h00 =  (1 + _2t) * (_1t) * (_1t);
			h10 =  t  * (_1t) * (_1t);
			h01 =  tt * (3 - _2t);
			h11 =  tt * (t - 1);
            
			if (!n)
            {
                latterPoint = [newPointList objectAtIndex:n+2];
                nextPoint = [newPointList objectAtIndex:n+1];
                currentPoint = [newPointList objectAtIndex:n];
                
				m0 = [Threshold tangentOfPoint1:nextPoint Point2:currentPoint];
				m1 = [Threshold tangentOfPoint1:latterPoint Point2:currentPoint];
				px = h00 * currentPoint.x + h10 * m0.x + h01 * nextPoint.x + h11 * m1.x;
				py = h00 * currentPoint.y + h10 * m0.y + h01 * nextPoint.y + h11 * m1.y;
                
                SCPoint* pointTemp = [[SCPoint alloc]initWithX:px andY:py];
                [newDrawPointList addObject:pointTemp];
                
				[pointTemp release];
                [m0 release];
                [m1 release];
			}
			else if (n < num-2)
			{
                latterPoint = [newPointList objectAtIndex:n+2];
                nextPoint = [newPointList objectAtIndex:n+1];
                currentPoint = [newPointList objectAtIndex:n];
                lastPoint = [newPointList objectAtIndex:n-1];
                
				m1 = [Threshold tangentOfPoint1:nextPoint Point2:lastPoint];
				m2 = [Threshold tangentOfPoint1:latterPoint Point2:currentPoint];
				px = h00 * currentPoint.x + h10 * m1.x + h01 * nextPoint.x + h11 * m2.x;
				py = h00 * currentPoint.y + h10 * m1.y + h01 * nextPoint.y + h11 * m2.y;
                
				SCPoint* pointTemp = [[SCPoint alloc]initWithX:px andY:py];
                [newDrawPointList addObject:pointTemp];
                
				[pointTemp release];
                [m1 release];
                [m2 release];
			}
			else if (n == num-1)
			{
                currentPoint = [newPointList objectAtIndex:n];
                lastPoint = [newPointList objectAtIndex:n-1];
                formerPoint = [newPointList objectAtIndex:n-2];
                
				m2 = [Threshold tangentOfPoint1:currentPoint Point2:formerPoint];
				m3 = [Threshold tangentOfPoint1:currentPoint Point2:lastPoint];
				px = h00 * lastPoint.x + h10 * m2.x + h01 * currentPoint.x + h11 * m3.x;
				py = h00 * lastPoint.y + h10 * m2.y + h01 * currentPoint.y + h11 * m3.y;
                
				SCPoint* pointTemp = [[SCPoint alloc]initWithX:px andY:py];
                [newDrawPointList addObject:pointTemp];
            
				[pointTemp release];
                [m2 release];
                [m3 release];
			}
            
		}
        
	}
    
    return newDrawPointList;
}

-(void)calculateCubicSplineWithPointList:(NSMutableArray *)pointList
{
    [self calculateCubicNewDrawPointList:pointList];
}

-(void)calculateNewDrawPointList
{
    if(isArcGroup)
    {
        for(int i=0; i<[arcUnitArray count]; i++)
        {
            CurveUnit* curveUnitTemp = [arcUnitArray objectAtIndex:i];
            if(i != 0)
            {
                CurveUnit* lastCurveUnit = [arcUnitArray objectAtIndex:i-1];
                [curveUnitTemp makeCurveSmoothToLastCurve:lastCurveUnit];
            }
            
            if(curveUnitTemp.isAntiClockCurve)
            {
                for(int j=0; j<curveUnitTemp.newDrawPointList.count; j++)
                {
                    [newDrawPointList addObject:[curveUnitTemp.newDrawPointList objectAtIndex:j]];
                }
            }
            else
            {
                for(int j=curveUnitTemp.newDrawPointList.count-1; j>=0; j--)
                {
                    [newDrawPointList addObject:[curveUnitTemp.newDrawPointList objectAtIndex:j]];
                }
            }
        } 
    }
    if(isSplineGroup)
    {
        for(int i=0; i<[arcUnitArray count]; i++)
        {
            CurveUnit* curveUnitTemp = [arcUnitArray objectAtIndex:i];
            for(int j=0; j<curveUnitTemp.newDrawPointList.count; j++)
            {
                [newDrawPointList addObject:[curveUnitTemp.newDrawPointList objectAtIndex:j]];
            }
        }  
    }
}

-(float)calculateDistanceWithPoint1:(SCPoint *)point1 Point2:(SCPoint *)point2
{
    return sqrtf((point1.x-point2.x)*(point1.x-point2.x) + (point1.y-point2.y)*(point1.y-point2.y));
}

-(Boolean)isSecondDegreeCurveWithPointArray:(NSMutableArray *)pointList
{
    //需要在进行了二次曲线的初步拟合得到一个普通的二次曲线方程后进行判断
    //二次曲线中心点为
    // y = (2ae-bd)/(b^2-4ac)
    // x = -d/(2a) - by/(2a)
    // d = f - (ax^2+bxy+cy^2)
    // Q(x,y) = a(x-x0)^2+b(x-x0)(y-y0)+c(y-y0)^2 + d;
    //if(bFactor*bFactor - 4*aFactor*cFactor <= equal_to_zero && bFactor*bFactor - 4*aFactor*cFactor >= equal_to_zero)
    //{
    //    curveType = 3;
    //}
    if(bFactor*bFactor > 4*aFactor*cFactor)
    {
        if (curveType!= 5)
        {
            self.type = 3;
            return NO;
        }
    }
    
    int number = pointList.count;
    float yCenter = (2*aFactor*eFactor - bFactor*dFactor)/(bFactor*bFactor - 4*aFactor*cFactor);
    float xCenter = -(dFactor + bFactor*yCenter)/(2*aFactor);
    float distance = fFactor - (aFactor*xCenter*xCenter + bFactor*yCenter*xCenter + cFactor*yCenter*yCenter);
    float deviation[number];
    
    //标准差
    float sum = 0;
    SCPoint* tempPoint;
    for(int i=0; i<number; i++)
    {
        tempPoint = [pointList objectAtIndex:i];
        deviation[i] = aFactor*(tempPoint.x - xCenter)*(tempPoint.x - xCenter) + bFactor*(tempPoint.x - xCenter)*(tempPoint.y - yCenter) + cFactor*(tempPoint.y - yCenter)*(tempPoint.y - yCenter);
        deviation[i] /= -distance;
        deviation[i] -= 1;
        
        if(deviation[i] < 0)
            sum -= deviation[i];
        else
            sum += deviation[i];
    }
    sum /= number;
    if(sum < stander_deviation)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)calculateStartPointAndEndPoint
{
    self.start.x = (majorAxis*cosf(startAngle));
    self.start.y = (minorAxis*sinf(startAngle));
    self.end.x   = (majorAxis*cosf(endAngle));
    self.end.y   = (minorAxis*sinf(endAngle));
}

-(void)calculateStartAndEndAngle
{
    //计算起始角和终止角
    if(self.start.x == 0)
    {
        //计算起始角
        if(self.start.y > 0)
        {
            startAngle = PI/2;
        }
        else
        {
            startAngle = PI*3/2;
        }
    }
    else
    {
        startAngle = atanf((self.start.y*majorAxis)/(self.start.x*minorAxis));
        if(self.start.x<0)//角在二、三象限
        {
            startAngle += PI;
        }
    }
    if(self.start.x == self.end.x && self.start.y == self.end.y)
    {
        isCompleteCurve = YES;
        endAngle = startAngle + 2*PI;
        return;
    }
    if(self.end.x == 0)
    {
        if(self.end.y > 0)
            endAngle = PI/2;
        if(self.end.y < 0)
            endAngle = PI*3/2;
    }
    else
    {
        endAngle = atanf((self.end.y*majorAxis)/(self.end.x*minorAxis));
        if(self.end.x < 0)//角在二、三象限
            endAngle += PI;
    }
    
    if(endAngle < startAngle)
    {
        endAngle += 2*PI;
    }
    if(endAngle - startAngle >= 1.98*PI)
    {
        isCompleteCurve = YES;
        if(endAngle - startAngle < 2*PI)
        {
            endAngle += 2*PI - (endAngle-startAngle);
        }
    }
    
    //判断是否大于半个弧度
    if(endAngle-startAngle >= PI)
    {
        isHalfCurve = YES;
    }
    
}

-(void)calculateStartAndEndAngleWithStartAngle:(float)startAngleLocal EndAngle:(float)endAngleLocal
{
    SCPoint* tempStart = [[SCPoint alloc]initWithX:0 andY:0];
    tempStart.x = self.end.x;
    tempStart.y = self.end.y;
    
    SCPoint* tempEnd = [[SCPoint alloc]initWithX:0 andY:0];
    tempEnd.x = self.start.x;
    tempEnd.y = self.start.y;
    
    //计算起始角
    if(tempStart.x == 0)
    {
        if(tempStart.y > 0)
        {
            startAngleLocal = PI/2;
        }
        else
        {
            startAngleLocal = PI*3/2;
        }
    }
    else
    {
        startAngleLocal = atanf((tempStart.y * majorAxis)/(tempStart.x * minorAxis));
        if(tempStart.x < 0) //角在第二、三象限
        {
            startAngleLocal += PI;
        }
    }
    
    if(tempStart.x == tempEnd.x && tempStart.y == tempEnd.y)
    {
        isCompleteCurve = YES;
        endAngleLocal = startAngleLocal + 2*PI;
        return;
    }
    
    //计算终止角
    if(tempEnd.x == 0)
    {
        if(tempEnd.y > 0)
        {
            endAngleLocal = PI/2;
        }
        if(tempEnd.y < 0)
        {
            endAngleLocal = PI*3/2;
        }
    }
    else
    {
        endAngleLocal = atanf((tempEnd.y * majorAxis)/(tempEnd.x * minorAxis));
        if(tempEnd.x < 0)   //角在第二、三象限
        {
            endAngleLocal += PI;
        }
    }
    
    if(endAngleLocal < startAngleLocal)
    {
        endAngleLocal += 2*PI;
    }
    if(endAngleLocal - startAngleLocal >= 1.98*PI)
    {
        isCompleteCurve = YES;
        if(endAngleLocal - startAngleLocal < 2*PI)
        {
            endAngleLocal += 2*PI - (endAngleLocal-startAngleLocal);
        }
    }
    
    //判断是否大于半个弧度
    if(endAngleLocal - startAngleLocal >= PI)
    {
        isHalfCurve = YES;
    }
}

-(void)calculateStartAndEndAngleWithStartPoint:(SCPoint *)startPoint EndPoint:(SCPoint *)endPoint StartAngle:(float)startAngleLocal EndAngle:(float)endAngleLocal
{
    SCPoint* tempStart = [[SCPoint alloc]initWithX:0 andY:0];
    tempStart.x = endPoint.x;
    tempStart.y = -endPoint.y;
    
    SCPoint* tempEnd = [[SCPoint alloc]initWithX:0 andY:0];
    tempEnd.x = startPoint.x;
    tempEnd.y = -startPoint.y;
    
    //计算起始角
    if(startPoint.x == 0)
    {
        if(startPoint.y > 0)
        {
            startAngleLocal = PI/2;
        }
        else
        {
            startAngleLocal = PI*3/2;
        }
    }
    else
    {
        startAngleLocal = atanf((tempStart.y * majorAxis)/(tempStart.x * minorAxis));
        if(startPoint.x < 0) //角在第二、三象限
        {
            startAngleLocal += PI;
        }
    }
    
    if(startPoint.x == endPoint.x && startPoint.y == endPoint.y)
    {
        isCompleteCurve = YES;
        endAngleLocal = startAngleLocal + 2*PI;
        return;
    }
    
    //计算终止角
    if(endPoint.x == 0)
    {
        if(endPoint.y > 0)
        {
            endAngleLocal = PI/2;
        }
        if(endPoint.y < 0)
        {
            endAngleLocal = PI*3/2;
        }
    }
    else
    {
        endAngleLocal = atanf((tempEnd.y * majorAxis)/(tempEnd.x * minorAxis));
        if(endPoint.x < 0)   //角在第二、三象限
        {
            endAngleLocal += PI;
        }
    }
    
    if(endAngleLocal < startAngleLocal)
    {
        endAngleLocal += 2*PI;
    }
    if(endAngleLocal - startAngleLocal >= 1.98*PI)
    {
        isCompleteCurve = YES;
        if(endAngleLocal - startAngleLocal < 2*PI)
        {
            endAngleLocal += 2*PI - (endAngleLocal-startAngleLocal);
        }
    }
    
//    //判断是否大于半个弧度
//    if(endAngleLocal - startAngleLocal >= PI)
//    {
//        isHalfCurve = YES;
//    }
}

-(float)calculateAngleWithPoint1:(SCPoint *)point1 Point2:(SCPoint *)point2 Center:(SCPoint *)centerPoint PosOrNeg:(float)isPosOrNeg
{
    float tempValue = (point2.x - centerPoint.x)*(point1.x - centerPoint.x) + (point2.y - centerPoint.y)*(point1.y -  centerPoint.y);
    float distance1 = [self calculateDistanceWithPoint1:point1 Point2:centerPoint];
    float distance2 = [self calculateDistanceWithPoint1:point2 Point2:centerPoint];
    float angle     = acosf(tempValue/(distance1*distance2));
    
    isPosOrNeg = (point1.x - centerPoint.x)*(point2.y - centerPoint.y) - (point2.x - centerPoint.x)*(point1.y - centerPoint.y);
    
    return angle;
}

-(float)calculateSlopeWithPoint1:(SCPoint*)point1 Point2:(SCPoint*)point2
{
    return (point2.y-point1.y)/(point2.x-point1.x);
}

-(float)calculateVerticalMiddleLineSlopeWithPoint1:(SCPoint*)point1 Point2:(SCPoint*)point2
{
    return -(point2.x-point1.x)/(point2.y-point1.y);
}

-(SCPoint*)calculateCenterPointWithSlope1:(float)slope1 Slope2:(float)slope2 Point1:(SCPoint*)point1 Point2:(SCPoint*)point2
{
    float x = ((point2.y - slope2*point2.x) - (point1.y-slope1*point1.x))/(slope1 - slope2);
    float y = (point1.y - slope1*point1.x) + slope2*x;
    
    return [[SCPoint alloc]initWithX:x andY:y];
}

-(SCPoint*)calculateMiddlePointWithPoint1:(SCPoint*)point1 Point2:(SCPoint*)point2
{
    return [[SCPoint alloc]initWithX:(point1.x+point2.x)/2 andY:(point1.y+point2.y)/2];
}

-(CurveUnit*)produceArcUnitWithPointList:(NSMutableArray*)pointList LastCenter:(SCPoint*)lastCenterPoint
{
    CurveUnit* curveUnitTemp = [[CurveUnit alloc]initWithPointArray:pointList];
    
    bool isSecondDegreeCurve = [curveUnitTemp isSecondDegreeCurveWithPointArray:pointList];
    
    if(isSecondDegreeCurve && curveUnitTemp.curveType == 1)
    {
        [curveUnitTemp judgeCurveWithPointArray:pointList];
        return curveUnitTemp;
    }
    else
    {
        curveUnitTemp = NULL;
        return curveUnitTemp;
    }
}

-(void)secondJudgeIsCompleteCurveWithPointArray:(NSMutableArray *)pointList
{
    if(pointList.count == 0)
        return;
    SCPoint* listStart = [pointList objectAtIndex:0];
    bool isSecondJudge = NO;
    
    SCPoint* tempPoint;
    
    for(int i=0; i<pointList.count; i++)
    {
        tempPoint = [pointList objectAtIndex:i];
        float tempPosNeg  = 0;
        float angle = [self calculateAngleWithPoint1:listStart Point2:tempPoint Center:center PosOrNeg:tempPosNeg];
        if(angle>170 && !(i>pointList.count-20 && i<pointList.count))
        {
            isSecondJudge = YES;
        }
    }
    
    if(!isSecondJudge)
        return;
    
    SCPoint* listEnd = [pointList objectAtIndex:pointList.count-1];
    
    float isPosOrNeg;
    float angleStartEnd = [self calculateAngleWithPoint1:listStart Point2:listEnd Center:center PosOrNeg:isPosOrNeg];
    float count = 0.0;
    float angle = 0.0;
    float otherIsPosNeg = 0.0;
    
    if(pointList.count < 30)
        return;
    for(int i=1; i<30; i++)
    {
        angle = [self calculateAngleWithPoint1:listStart Point2:listEnd Center:center PosOrNeg:otherIsPosNeg];
        if(otherIsPosNeg*isPosOrNeg > 0 && angle < angleStartEnd)
        {
            count++;
        }
    }
    if(count > 5)
    {
        isCompleteCurve = YES;
        self.end = self.start;
    }
    hasSecondJudge = YES;
    
}

-(void)antiTranslateWithX:(float *)x WithY:(float *)y Theta:(float)theta Point:(SCPoint *)vector
{
    SCPoint* temp = [[SCPoint alloc]init];
    float cos = cosf(theta);
    float sin = sinf(theta);
    //平移变换
    temp.x = *x - vector.x;
    temp.y = *y - vector.y;
    //旋转变换
    *x = (temp.x*cos + temp.y*sin);
    *y = (temp.x*(-sin) + temp.y*cos);
    
    [temp release];
    temp = NULL;
}

-(SCPoint*)antiTranslateWith:(SCPoint *)tempPoint Theta:(float)theta Point:(SCPoint *)vector
{
    SCPoint* temp = [[SCPoint alloc]init];
    float cos = cosf(theta);
    float sin = sinf(theta);
    //平移变换
    temp.x = tempPoint.x - vector.x;
    temp.y = tempPoint.y - vector.y;
    //旋转变换
    tempPoint.x = (temp.x*cos + temp.y*sin);
    tempPoint.y = (temp.x*(-sin) + temp.y*cos);
    
    [temp release];
    temp = NULL;
    
    return tempPoint;
}

-(void)translateAndRotationWithX:(float*)x Y:(float*)y Theta:(float)theta Point:(SCPoint *)vector
{
    SCPoint* temp = [[SCPoint alloc]init];
    float cos = cosf(-theta);
    float sin = sinf(-theta);
    temp.x = *x;
    temp.y = *y;
    //旋转平移变换
    *x = (temp.x*cos + temp.y*sin) + vector.x;
    *y = (temp.x*(-sin) + temp.y*cos) + vector.y;
}

-(SCPoint*)translateAndRotationWithPoint:(SCPoint *)tempPoint Theta:(float)theta Point:(SCPoint *)vector
{
    float cos = cosf(theta);
    float sin = sinf(theta);
    tempPoint.x = ((tempPoint.x-center.x)*cos + (tempPoint.y-center.y)*sin) + center.x + vector.x;
    tempPoint.y = ((tempPoint.x-center.x)*(-sin) + (tempPoint.y-center.y)*cos) + center.y + vector.y;
    return tempPoint;
}

-(SCPoint*)rotationWithPoint:(SCPoint *)tempPoint Theta:(float)theta
{
    float cos = cosf(theta);
    float sin = sinf(theta);
    tempPoint.x = ((tempPoint.x-center.x)*cos + (tempPoint.y-center.y)*sin) + center.x;
    tempPoint.y = ((tempPoint.x-center.x)*(-sin) + (tempPoint.y-center.y)*cos) + center.y;
    return tempPoint;    
}

-(SCPoint*)translateWithPoint:(SCPoint *)tempPoint Vector:(SCPoint *)vector
{
    tempPoint.x = tempPoint.x + vector.x;
    tempPoint.y = tempPoint.y + vector.y;
    return tempPoint;
}

-(SCPoint*)rotationWithPoint:(SCPoint *)tempPoint Theta:(float)theta BasePoint:(SCPoint *)basePoint
{
    float cos = cosf(theta);
    float sin = sinf(theta);
    SCPoint* point = [[SCPoint alloc]initWithX:tempPoint.x andY:tempPoint.y];
    point.x = ((point.x-basePoint.x)*cos + (point.y-basePoint.y)*sin) + basePoint.x;
    point.y = ((point.x-basePoint.x)*(-sin) + (point.y-basePoint.y)*cos) + basePoint.y;
    return point;    
}

-(SCPoint*)scaleWithPoint:(SCPoint *)tempPoint ScaleFactor:(SCPoint *)scaleFactor BasePoint:(SCPoint *)basePoint
{
    SCPoint* point = [[SCPoint alloc]initWithX:tempPoint.x andY:tempPoint.y];
    point.x = (point.x - basePoint.x)*(scaleFactor.x);
    point.y = (point.y - basePoint.y)*(scaleFactor.y);
    point.x += basePoint.x;
    point.y += basePoint.y;
    return point;
}

-(void)setCenterWithX:(float)x Y:(float)y
{
    center.x = x;
    center.y = y;
    move.x   = x;
    move.y   = y;
}

-(void)setRadiusWithR:(float)r
{
    majorAxis = r;
    minorAxis = r;
}

-(void)setCompletCurve
{
    isCompleteCurve = YES;
    endAngle = startAngle+2*PI;
}

-(void)drawEllipseWithLastCurve:(CurveUnit*)lastCurve Context:(CGContextRef)context
{    
    CGContextSaveGState(context);
    
    if(isCompleteCurve)
    {
        CGContextTranslateCTM(context, move.x, move.y);
        CGContextRotateCTM(context, alpha);
        CGContextStrokeEllipseInRect(context, CGRectMake(-majorAxis, -minorAxis, 2*majorAxis, 2*minorAxis));
    }
    else
    {
        SCPoint* pointTempAt0 = [newDrawPointList objectAtIndex:0];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, pointTempAt0.x, pointTempAt0.y);
        
        for(float i=1; i<[newDrawPointList count]; i++)
        {
            SCPoint* pointTemp = [newDrawPointList objectAtIndex:i];
            CGPathAddLineToPoint(path, NULL, pointTemp.x, pointTemp.y);
        }
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
        CGPathRelease(path);
    }
    
    if(isCompleteCurve)
    {
        //省略掉画焦点或圆心
    }
    
    CGContextRestoreGState(context);
    
}

-(void)drawEllipseArcWithContext:(CGContextRef)context
{
    float a = fabsf(majorAxis);
    float b = fabsf(minorAxis);
    
    //计算起始点和终止点后先画出椭圆曲线
    float add = 2*PI/draw_circle_increment;
    float x,y;
    x = (a*cosf(startAngle));
    y = (b*sinf(startAngle));
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, x, y);
    
    
    for(float i=startAngle; i<=endAngle; i+=add)
    {
        x = a*cosf(i);
        y = b*sinf(i);
        CGPathAddLineToPoint(path, NULL, x, y);
    }
    CGContextSetLineWidth(context, 5.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
}

-(void)drawHyperbolicWithContext:(CGContextRef)context
{
    SCPoint* pointTempAt0 = [newDrawPointList objectAtIndex:0];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, pointTempAt0.x, pointTempAt0.y);
    
    for(float i=1; i<[newDrawPointList count]; i++)
    {
        SCPoint* pointTemp = [newDrawPointList objectAtIndex:i];
        CGPathAddLineToPoint(path, NULL, pointTemp.x, pointTemp.y);
    }
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
    
}

-(void)drawCubicSplineWithPointList:(NSMutableArray *)pointList Context:(CGContextRef)context
{

    CGMutablePathRef path = CGPathCreateMutable();
    for(int i=0; i<[newDrawPointList count]; i++)
    {
        SCPoint* tempPoint = [newDrawPointList objectAtIndex:i];
        if (i == 0)
        {
            CGPathMoveToPoint(path, NULL, tempPoint.x, tempPoint.y);
        }
        else
        {
            CGPathAddLineToPoint(path, NULL, tempPoint.x, tempPoint.y);
        }
    }
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
}

-(void)drawCircleArcWithContext:(CGContextRef)context
{
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 5.0f);
    CGContextAddArc(context, center.x, center.y, (majorAxis+minorAxis)/2, startAngle, endAngle, 0);
    CGContextStrokePath(context);
}

-(void)drawPathWithContext:(CGContextRef)context
{
    //如果识别出来是非二次曲线，就按照点轨迹一一画出
}

-(void)drawWithContext:(CGContextRef)context
{
    if(majorAxis<0 && minorAxis<0)
    {
        self.type = 3;           //非二次曲线
        curveType = 3;           //非二次曲线
    }
    
    if(self.type==2 && curveType==2)
    {
        //双曲线
        [self drawHyperbolicWithContext:context];
        NSLog(@"双曲线啊！！！！");
    }
    else if(self.type == 2 && curveType == 1)
    {
        //椭圆
        [self drawEllipseWithLastCurve:NULL Context:context];
        NSLog(@"椭圆啊！！！！");
    }    
    else if(self.type == 3)
    {
        [self drawCubicSplineWithPointList:newDrawPointList Context:context];
    }
    
}

@end
