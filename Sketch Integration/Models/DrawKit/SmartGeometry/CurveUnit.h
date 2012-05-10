//
//  CurveUnit.h
//  SmartGeometry
//
//  Created by kwan terry on 12-1-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Gunit.h"
#import "SCPoint.h"
#import "Stroke.h"
#import "Threshold.h"

@interface CurveUnit : Gunit
{
    float aFactor,bFactor,cFactor,dFactor,eFactor,fFactor;              
    //为二次曲线的标准最简式：a*x^2 + b*xy + c*y^2 + d*x + e*y + f = 0 的系数
    
    SCPoint* center;                //中心坐标
    SCPoint* move;                  //移动向量坐标
    SCPoint* f1;                    //焦点
    SCPoint* f2;
    
    float alpha;
    float majorAxis,minorAxis;      //长轴，短轴；major_axis是x方向上的轴长，minor_axis是y方向上的轴长
    
    float originalAlpha;
    float originalMajor,originalMinor;
    
    float startAngle,endAngle;      //画弧线时的起始角和终止角（并非是起始点，终点和原点的连线与坐标轴的夹角）在画二次曲线时有作用
    
    bool isAntiClockCurve;          //表示这段曲线为逆时针曲线
    bool isEllipse;                 //椭圆为yes,圆形为no
    bool isHalfCurve;               //如果是半个以上的二次弧线则为yes，默认值为no
    bool isCompleteCurve;           //是圆满的圆形和椭圆形为yes
    bool hasSecondJudge;
    int curveType;                  //曲线的类型
    
    //判断哪个轴递增或者递减
    bool isXIncrease;
    bool isXDecrease;
    bool isYIncrease;
    bool isYDecrease;
    
    SCPoint* testS;
    SCPoint* testE;
    
    NSMutableArray* curveTrack;             //曲线原始轨迹
    NSMutableArray* newDrawPointList;       //用于绘画的曲线轨迹
    NSMutableArray* newSpecialPointList;
    
    //圆弧混合拟合
    NSMutableArray* arcIndexArray;
    NSMutableArray* arcUnitArray;
    NSMutableArray* arcBoolArray;
    bool isArcGroup;
    bool isSplineGroup;
    
    //用于三次样条插值曲线拟合的特征变量
    float* px;
    float* py;
    float* ph;
    float* psx;
    
}

@property (readwrite) float aFactor;
@property (readwrite) float bFactor;
@property (readwrite) float cFactor;
@property (readwrite) float dFactor;
@property (readwrite) float eFactor;
@property (readwrite) float fFactor;
@property (readwrite) float alpha;
@property (readwrite) float majorAxis;
@property (readwrite) float minorAxis;
@property (readwrite) float originalAlpha;
@property (readwrite) float originalMajor;
@property (readwrite) float originalMinor;
@property (readwrite) float startAngle;
@property (readwrite) float endAngle;
@property (readwrite) bool  isAntiClockCurve;
@property (readwrite) bool  isEllipse;
@property (readwrite) bool  isHalfCurve;
@property (readwrite) bool  isCompleteCurve;
@property (readwrite) bool  isArcGroup;
@property (readwrite) bool  isSplineGroup;
@property (readwrite) bool  hasSecondJudge;
@property (readwrite) bool  isXIncrease;
@property (readwrite) bool  isXDecrease;
@property (readwrite) bool  isYIncrease;
@property (readwrite) bool  isYDecrease;
@property (readwrite) int   curveType;

@property (readwrite) float* px;
@property (readwrite) float* py;
@property (readwrite) float* ph;
@property (readwrite) float* psx;

@property (retain) SCPoint* center;
@property (retain) SCPoint* move;
@property (retain) SCPoint* f1;
@property (retain) SCPoint* f2;
@property (retain) SCPoint* testS;
@property (retain) SCPoint* testE;
@property (retain) NSMutableArray* curveTrack;
@property (retain) NSMutableArray* newDrawPointList;
@property (retain) NSMutableArray* newSpecialPointList;
@property (retain) NSMutableArray* arcIndexArray;
@property (retain) NSMutableArray* arcUnitArray;
@property (retain) NSMutableArray* artBoolArray;

//构造函数
-(id)initWithSPoint:(SCPoint*)startPoint EPoint:(SCPoint*)endPoint;
-(id)initWithAFactor:(float)a BFactor:(float)b CFactor:(float)c DFactor:(float)d EFactor:(float)e FFactor:(float)f;
-(id)initWithPointArray:(NSMutableArray*)pointList ID:(int)idNum;       //有整个曲线识别流程操作，h可以为任意的整形值
-(id)initWithPointArray:(NSMutableArray *)pointList;                    //只有identity的操作，并未判断是否为二次曲线和标准化

//进行三次样条插值的计算
-(NSMutableArray*)calculateCubicNewDrawPointList:(NSMutableArray*)newPointList;
-(void)calculateCubicSplineWithPointList:(NSMutableArray*)pointList;
-(NSMutableArray*)findSpecialPointWithPointList:(NSMutableArray*)pointListTemp;

//圆弧分解计算相关函数
-(float)calculateSlopeWithPoint1:(SCPoint*)point1 Point2:(SCPoint*)point2;
-(float)calculateVerticalMiddleLineSlopeWithPoint1:(SCPoint*)point1 Point2:(SCPoint*)point2;
-(SCPoint*)calculateCenterPointWithSlope1:(float)slope1 Slope2:(float)slope2 Point1:(SCPoint*)point1 Point2:(SCPoint*)point2;
-(SCPoint*)calculateMiddlePointWithPoint1:(SCPoint*)point1 Point2:(SCPoint*)point2;
-(CurveUnit*)produceArcUnitWithPointList:(NSMutableArray*)pointList LastCenter:(SCPoint*)lastCenterPoint;

//计算绘画函数
-(void)calculateNewDrawPointList;

//重新计算椭圆的轨迹
-(void)recalculateSecCurveTrackWithPointList:(NSMutableArray*)pointList;
-(void)recalculateDrawSecCurveTrack:(NSMutableArray*)pointList;
-(SCPoint*)recalculateNewPointWithTempPoint:(SCPoint*)tempPoint LastPoint:(SCPoint*)lastPoint;
-(NSMutableArray*)findCalculatePoints:(NSMutableArray*)pointList;

//计算画新椭圆曲线的轨迹
-(void)calculateNewDrawSecCurveTrack;
-(void)makeCurveSmoothToLastCurve:(CurveUnit*)lastCurve;

//采用高斯消元法，识别曲线
-(void)identifyWithPointArray:(NSMutableArray*)pointList XArray:(float[6])xArray;

//如果是二次曲线返回yes，如果非二次曲线返回no
-(Boolean)isSecondDegreeCurveWithPointArray:(NSMutableArray*)pointList;

//将二次曲线化为标准的最简式
-(void)convertToStandardCurve;

//高斯消元法函数
-(void)gaussianEliminationWithRow:(int)row Column:(int)col Matrix:(float[5][6])matrix Answer:(float[5])answer;

//判断是何种二次曲线
-(void)judgeCurveWithPointArray:(NSMutableArray*)pointList;

//计算出两点间的距离
-(float)calculateDistanceWithPoint1:(SCPoint*)point1 Point2:(SCPoint*)point2;

//使得从开始点到终止点为逆时针
-(void)setStartTOEndAntiClockWithPointArray:(NSMutableArray*)pointList;

//计算出起始角和终止角
-(void)calculateStartAndEndAngle;
-(void)calculateStartAndEndAngleWithStartAngle:(float)startAngle EndAngle:(float)endAngle;
-(void)calculateStartAndEndAngleWithStartPoint:(SCPoint*)startPoint EndPoint:(SCPoint*)endPoint StartAngle:(float)startAngleLocal EndAngle:(float)endAngleLocal;
-(float)calculateAngleWithPoint1:(SCPoint*)point1 Point2:(SCPoint*)point2 Center:(SCPoint*)centerPoint PosOrNeg:(float)isPosOrNeg;

-(void)secondJudgeIsCompleteCurveWithPointArray:(NSMutableArray*)pointList;

//绘画
-(void)drawWithContext:(CGContextRef)context;
-(void)drawEllipseWithLastCurve:(CurveUnit*)lastCurve Context:(CGContextRef)context;
-(void)drawEllipseArcWithContext:(CGContextRef)context;
-(void)drawCircleArcWithContext:(CGContextRef)context;
-(void)drawHyperbolicWithContext:(CGContextRef)context;
-(void)drawPathWithContext:(CGContextRef)context;
-(void)drawCubicSplineWithPointList:(NSMutableArray*)pointList Context:(CGContextRef)context;
-(void)drawBezierWithPointList:(NSMutableArray*)poitList Context:(CGContextRef)context;

-(void)setCenterWithX:(float)x Y:(float)y;
-(void)setRadiusWithR:(float)r;
-(void)setOriginalAlpha;
-(void)setOriginalMajorAndOriginalMinor;
-(void)setCompletCurve;

//计算曲线的起点和终点
-(void)calculateStartPointAndEndPoint;

//旋转平移操作
-(void)translateAndRotationWithX:(float*)x Y:(float*)y Theta:(float)theta Point:(SCPoint*)vector;
-(SCPoint*)translateAndRotationWithPoint:(SCPoint*)tempPoint Theta:(float)theta Point:(SCPoint*)vector;
-(SCPoint*)rotationWithPoint:(SCPoint*)tempPoint Theta:(float)theta;
-(SCPoint*)translateWithPoint:(SCPoint*)tempPoint Vector:(SCPoint*)vector;
-(void)antiTranslateWithX:(float*)x WithY:(float*)y Theta:(float)theta Point:(SCPoint*)vector;
-(SCPoint*)antiTranslateWith:(SCPoint*)tempPoint Theta:(float)theta Point:(SCPoint*)vector;

-(SCPoint*)rotationWithPoint:(SCPoint*)tempPoint Theta:(float)theta BasePoint:(SCPoint*)basePoint;
-(SCPoint*)scaleWithPoint:(SCPoint*)tempPoint ScaleFactor:(SCPoint*)scaleFactor BasePoint:(SCPoint*)basePoint;
@end
