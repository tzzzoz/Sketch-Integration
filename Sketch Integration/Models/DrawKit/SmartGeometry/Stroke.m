//
//  Stroke.m
//  Dudel
//
//  Created by tzzzoz on 11-12-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Stroke.h"

@implementation Stroke
@synthesize pList;
@synthesize gList;
@synthesize specialList;

-(id)initWithPoints:(NSMutableArray *)x 
{
    self = [super init];
    
    pList = [[NSMutableArray alloc] init];
    gList = [[NSMutableArray alloc] init];
    specialList = [[NSMutableArray alloc] init];
    pList = x;
    
    as = 0.0;
    ad = 0.0;
    ac = 0.0;
    
    return  self;
}

-(void)findSpecialPoints 
{
    [self speed];
    [self direction];
    [self curvity];
    [self space];
    
    SCPoint *point = [[SCPoint alloc]init];
    [specialList addObject:[[NSNumber alloc]initWithInt:0]];
    for (int i = 1; i < [pList count]-1; i++)
    {
        point = [pList objectAtIndex:i];
        if (point.total>=4)      // 过 滤 掉 权 重 小 于 4 的 点
        {
            [specialList addObject:[[NSNumber alloc]initWithInt:i]];
        }
    }
    [specialList addObject:[[NSNumber alloc]initWithInt:[pList count]-1]];
}

-(void)speed 
{
    int pointNum = [pList count];
    float average = 0.0;
    
    // 首 尾 点 的 速 度 为 0
    SCPoint *start;
    SCPoint *end;
    SCPoint *point;
    SCPoint *nextPoint;
    SCPoint *prePoint;
    
    start = [pList objectAtIndex:0];
    start.s = 0.0;                   //pList[i].s 表 示 i 点 的 速 度
    end = [pList lastObject];
    end.s = 0.0;
    
    for (int i = 1; i + 1 < pointNum; i++)
    {
        point = [pList objectAtIndex:i];
        nextPoint = [pList objectAtIndex:i+1];
        prePoint  = [pList objectAtIndex:i-1];
        float dx  = [Threshold Distance:prePoint :point];
        float dx1 = [Threshold Distance:point :nextPoint];
        point.s   = dx + dx1;  // 使 用 该 点 的 相 邻 两 点 间 的 距 离 作 为 该 点 的 速 度
        average += point.s;
    }
    average /= pointNum;
    as = average;
    for (int i = 0; i < pointNum; i++)
    {
        point = [pList objectAtIndex:i];
        if (point.s < average * 0.42)   // 阀 值 ，由 i 点 的 速 度 进 行 筛 选
        {
                point.total++;          //pList[i].total 表 示 i 点 的 权 重
        }
    }
}

-(void)curvity 
{
    //一：将五个点平移，使得i点在原点
    //二：将五个点绕原点旋转[0,180)，记录五个点|y|的绝对值的和
    //三：使得绝对值和最小的角度为i点切线与x轴的夹角
    //旋转矩阵：cosA   -sinA
    //         sinA    cosA
    //原来坐标(x,y),旋转后(xcosA+ysinA,-xsinA+ycosA);
    //所以只需枚举[0,180)，计算所有-xsinA+ycosA的和，就是切线与x轴夹角
    //求出夹角后，求曲率：
    //double rate = System.Math.Sin(30*pi/180.0);
    
    int pointNum = [pList count];
    SCPoint *tempPoint;
    SCPoint *point;
    SCPoint *prePoint;
    SCPoint *nextPoint;
    
    NSMutableArray *sita = [[NSMutableArray alloc] init];
    for(int k=0; k<pointNum; k++)
        [sita addObject:[[NSNumber alloc] initWithFloat:-0.0f]];
    
    for (int i = 2; i + 2 < pointNum; i++)
    {
        point = [pList objectAtIndex:i];
        float mint = 0.0;    // 保 存 绝 对 值 之 和 的 最 小 值
        for (int k = 0; k <=4; k++)
        {
            tempPoint = [pList objectAtIndex:i-2+k];
            mint += abs(tempPoint.y - point.y);
        }
        [sita replaceObjectAtIndex:i withObject:[[NSNumber alloc] initWithFloat:0.0]];
        for (int j = 1; j < 180; j++)
        {
            float tmp = 0.0;
            for (int k = 0; k <= 4; k++)
            {
                tempPoint = [pList objectAtIndex:i-2+k];
                tmp+=abs((tempPoint.y-point.y)*cos(j*3.141/180.0)-(tempPoint.x-point.x)*sin(j*3.141/180.0));
            }
            if (tmp < mint)     // 求 绝 对 值 之 和 的 最 小 值
            {
                mint = tmp;
                [sita replaceObjectAtIndex:i withObject:[[NSNumber alloc] initWithFloat:j]];
            }
        }
    }
    for (int i = 2; i + 2 < pointNum; i++)
    {
        point = [pList objectAtIndex:i];
        prePoint = [pList objectAtIndex:i-2];
        nextPoint = [pList objectAtIndex:i+2];
        float tmp = 0.0;
        for (int k = 1; k < 4; k++)
        {
            NSNumber *tempNumber;
            NSNumber *nextNumber;
            tempNumber = [sita objectAtIndex:i - 2 + k];
            nextNumber = [sita objectAtIndex:i - 3 + k];
            tmp+= abs([tempNumber floatValue] - [nextNumber floatValue]);
        }
        point.c = tmp / [Threshold Distance:prePoint :nextPoint];
        if(abs(point.c)>100)// 处 理 可 能 为 异 常 抖 动 的 点
        {
            point.c=0.0;
            point.total--;
            if(point.d<170.0&&point.s<as*0.42)  // 由 i 点 速 度 s 和 方 向 d 进 行 筛 选
            {
                point.total += 2;
            }
        }
    }
    float average = 0.0;
    for (int i = 0; i < pointNum; i++)
    {
        point = [pList objectAtIndex:i];
        average += point.c;
    }
    average /= pointNum;
    for (int i = 1; i < pointNum-1; i++)
    {
        point = [pList objectAtIndex:i];
        if (point.c > average*1.0)
        {
            point.total += 2;
        }
        else if(point.d<170.0&&point.s<as*0.42)
        {
            point.total += 2;
        }
    }
    ac = average;
    
    SCPoint *s;
    SCPoint *e;
    s = [pList objectAtIndex:0];
    e = [pList lastObject];
    s.total++;
    e.total++;
    [sita release];
}

-(void)direction {
    // 对 于 点 i ； 边<i-1,i> 和 边<i,i+1> 之 间 的 夹 角 来 判 断 是 否 平 滑 过 渡
    // 夹 角 大 于 175 度 时 ，平 滑 过 渡 ， 否 则 ， 点 i 为 一 个 转 折 点
    // 运 用 余 弦 定 理 求 解 角 度
    int pointNum = [pList count];
    SCPoint *point;
    SCPoint *prePoint;
    SCPoint *nextPoint;
    for (int i = 1; i + 1 < pointNum; i++)
    {
        nextPoint = [pList objectAtIndex:i+1];
        prePoint = [pList objectAtIndex:i-1];
        point = [pList objectAtIndex:i];
        float A = [Threshold Distance:prePoint :nextPoint];
        float B = [Threshold Distance:nextPoint :point];
        float C = [Threshold Distance:prePoint :point];

        double tmp = (B * B + C * C - A * A);
        tmp = tmp / (2 * B * C + 0.00001);
        float test=acos(tmp);
        point.d=test*180.0/3.141;
    }
    SCPoint *s;
    SCPoint *e;
    s = [pList objectAtIndex:0];
    e = [pList lastObject];
    s.total+=2;
    e.total+=2;
    for (int i = 1; i + 1 < pointNum; i++)
    {
        point = [pList objectAtIndex:i];
        prePoint = [pList objectAtIndex:i-1];
        if (point.d <= 170.0)
        {
            if(prePoint.d>170.0)// 考 察 前 一 个 点 的 d ， 若 前 一 个 点 的 d 不 符 合 条 件 ， 则 要 考 察 i 点 的 s
            {
                if(point.s<as*0.42)// 即 i 点 的 S 已 经 符 合 条 件 了
                {
                    prePoint.total-=4;
                    point.total+=4;
                }
            }
            else// 若 前 一 个 点 的 d 也 符 合 条 件 ， 则 考 察 前 一 个 点 的 s
            {
                if (prePoint.s<as*0.42)// 表 明 前 一 个 点 的 s 符 合 条 件 ， 则 比 较 则 两 个 点 的 角 度 大 小 ， 取 较 小 的 那 个 点
                {
                    if(prePoint.d>point.d)
                    {
                        prePoint.total-=4;
                        point.total+=4;
                    }
                }
                else if(point.s<as*0.42)// 前 一 个 点 的 s 不 符 合 条 件 ， 但 当 前 点 符 合 ， 则 当 前 点 加 2
                {
                    prePoint.total-=4;
                    point.total+=4;
                }
            }
        }
    }
}

-(void)space {
    int pointNum = [pList count];
    SCPoint *point;
    SCPoint *anotherPoint;
    SCPoint *tempPoint;
    if(pointNum>25)
    {
        for (int i=1;i<pointNum-1;i++)
        {
            point = [pList objectAtIndex:i];
            if(i<25)// 去 除 起 始 点 附 近 的 噪 点
            {
                point.total-=2;
            }
            else if(point.total>=4)
            {
                for(int j=i-1;j>=0;j--)       // 去 除 起 始 点 后 第 i 点 周 围 的 噪 点 ， 25 是 估 计 值 ，估 计 以 25 个 点 为 一 个 单 位
                {
                    anotherPoint = [pList objectAtIndex:j];
                    if (anotherPoint.total>=4&&abs(i-j)<=25)
                    {
                        point.total-=1;
                    }
                }
            }
        }
        for(int k=2;k<=25;k++)// 搞 掉 末 尾 点 附 近 点 的 冗 余
        {
            tempPoint = [pList objectAtIndex:pointNum - k];
            tempPoint.total-=1;
        }
    }
}

-(Gunit *)recognize:(NSMutableArray *)tempPoints 
{
    // 首 先 识 别 是 否 为 点 图 元
    //if ((int)pList.size()<=2){
    //	Point_Unit apoint(pList[0]);
    //	//aunit=&apoint;
    //	GUnit* point=new Point_Unit();
    //	return 0;
    //}
    //*********************************************************************************************
    // 若 不 是 点 图 元 ， 再 次 识 别 是 否 为 直 线 图 元
    // 方 法 ： 若 首 末 两 点 的 距 离 比 上 所 有 的 两 两 相 邻 的 点 之 间 的 距 离 之 和 ， 比 之 大 于 阀 值 的 话 ， 则 判 断 为 直 线 图 元
    // 阀 值 暂 定 为 0.95
    Gunit* aunit = [[Gunit alloc]init];// 将 要 返 回 的 那 个GUnit
    double totalLength,tempLength;
    totalLength=0.0;
    SCPoint *s;
    SCPoint *e;
    SCPoint *point;
    SCPoint *prePoint;
    s = [tempPoints objectAtIndex:0];
    e = [tempPoints lastObject];
    tempLength = [Threshold Distance:s :e];

    if(tempPoints.count <= 2)
    {
        PointUnit* aPoint = [[PointUnit alloc]initWithPoint:[tempPoints objectAtIndex:0]];
        return aPoint;
    }
    
    for (int i=1;i<[tempPoints count]-1;i++)
    {
        point = [tempPoints objectAtIndex:i];
        prePoint = [tempPoints objectAtIndex:i-1];
        totalLength += [Threshold Distance:prePoint :point];
    }
    if (tempLength/totalLength>=0.95)
    {
        Gunit* aline = [[LineUnit alloc] initWithPoints:tempPoints];
        return aline;
    }
    else
    {
        CurveUnit* acurve = [[CurveUnit alloc]initWithPointArray:tempPoints];
        if([acurve isSecondDegreeCurveWithPointArray:tempPoints])
        {
            [acurve judgeCurveWithPointArray:tempPoints];
            return acurve;
        }
        else
        {
            acurve = NULL;
            return acurve;
        }
    }
}

-(BOOL)rebuild_line 
{
    [gList removeAllObjects];
    NSNumber *specialPointId;
    NSNumber *nextSpecialPointId;
    
    for (int i=0;i<[specialList count]-1;i++)
    {
        NSMutableArray *temp  = [[NSMutableArray alloc]init] ;//temp 为 临 时 存 放 某 个 图 元 的 所 有 点 的 数 组
        specialPointId = [specialList objectAtIndex:i];
        nextSpecialPointId = [specialList objectAtIndex:i+1];
        for(int j=[specialPointId intValue];j<[nextSpecialPointId intValue];j++)
        {
            [temp addObject:[pList objectAtIndex:j]];
        }
        [gList addObject:[self recognize:temp]];
    }
    
    if ([gList count]==1) {
        Gunit *unit;
        unit = [gList objectAtIndex:0];
        if (unit.type==1) {
            return true;
        }
        else return false;
    }
    else return false;
}

-(BOOL)rebuild_triangle 
{
    [gList removeAllObjects];
    NSNumber *specialPointId;
    NSNumber *nextSpecialPointId;
    
    NSMutableArray* sl = specialList;
    
    NSMutableArray* pl = [[NSMutableArray alloc]init];
    for(int i=0; i< [sl count]; i++)
    {
        NSNumber* num = [sl objectAtIndex:i];
        [pl addObject:[pList objectAtIndex:[num intValue]]];
    }
    
    for (int i=0;i<[specialList count]-1;i++)
    {
        NSMutableArray *temp = [[NSMutableArray alloc]init];//temp 为 临 时 存 放 某 个 图 元 的 所 有 点 的 数 组
        specialPointId = [specialList objectAtIndex:i];
        nextSpecialPointId = [specialList objectAtIndex:i+1];
        for(int j=[specialPointId intValue];j<[nextSpecialPointId intValue];j++)
        {
            [temp addObject:[pList objectAtIndex:j]];
        }
        Gunit* unitTempAfterRecognize = [self recognize:temp];
        if(unitTempAfterRecognize != NULL)
        {
            [gList addObject:unitTempAfterRecognize];
        }
        else
        {
            return NO;
        }
    }
    
    int num = [gList count];
    NSMutableArray* array = gList;
    if([array count]==3)
    {
        int tag=0;
        Gunit *unit;
        for(int i=0;i<3;i++)
        {
            unit = [gList objectAtIndex:i];
            if(unit.type == 1)
            {
                tag++;
            }
        }
        
        SCPoint *startSpecialPoint;
        SCPoint *endSpecialPoint;
        NSNumber *startSpecialPointId;
        NSNumber *endSpecialPointId;
        startSpecialPointId = [specialList objectAtIndex:0];
        endSpecialPointId = [specialList objectAtIndex:3];
        startSpecialPoint = [pList objectAtIndex:[startSpecialPointId intValue]];
        endSpecialPoint = [pList objectAtIndex:[endSpecialPointId intValue]];
        
        if ((tag==3) && [Threshold Distance:startSpecialPoint :endSpecialPoint] < is_closed)// 判 定 为 三 角 形 的 条 件 ， 阀 值 可 调 ，is_closed 标 志 两 个 特 征 点 在 可 误 差 范 围 内 重 合
        {
//            LineUnit* temp1=[gList objectAtIndex:0];
//            LineUnit* temp2=[gList objectAtIndex:1];
//            LineUnit* temp3=[gList objectAtIndex:2];
//            
//            [temp2 setstart:temp1.end];
//            [temp3 setstart:temp2.end];
//            [temp3 setend:temp1.start];
            
            
            return true;
        }
        else return false;
    }
    else return false;
}

-(BOOL)rebuild_rectangle 
{
    [gList removeAllObjects];
    NSNumber *specialPointId;
    NSNumber *nextSpecialPointId;
    
    NSMutableArray* sl = specialList;
    
    for (int i=0;i<[specialList count]-1;i++)
    {
        NSMutableArray *temp = [[NSMutableArray alloc]init];//temp 为 临 时 存 放 某 个 图 元 的 所 有 点 的 数 组
        specialPointId = [specialList objectAtIndex:i];
        nextSpecialPointId = [specialList objectAtIndex:i+1];
        for(int j=[specialPointId intValue];j<[nextSpecialPointId intValue];j++)
        {
            [temp addObject:[pList objectAtIndex:j]];
        }
        Gunit* unitTempAfterRecognize = [self recognize:temp];
        if(unitTempAfterRecognize != NULL)
        {
            [gList addObject:unitTempAfterRecognize];
        }
        else
        {
            return NO;
        }
    }
    if([gList count]==4)
    {
        int tag=0;
        Gunit *unit;
        for(int i=0;i<4;i++)
        {
            unit = [gList objectAtIndex:i];
            if(unit.type==1)
            {
                tag++;
            }
        }
        
        SCPoint *startSpecialPoint;
        SCPoint *endSpecialPoint;
        NSNumber *startSpecialPointId;
        NSNumber *endSpecialPointId;
        startSpecialPointId = [specialList objectAtIndex:0];
        endSpecialPointId = [specialList objectAtIndex:4];
        startSpecialPoint = [pList objectAtIndex:[startSpecialPointId intValue]];
        endSpecialPoint = [pList objectAtIndex:[endSpecialPointId intValue]];
        if ((tag==4) && [Threshold Distance:startSpecialPoint :endSpecialPoint] < is_closed) {
            return true;
        }
        else return false;
    }
    else return false;
}

-(BOOL)rebuild_hybridunit
{
    [gList removeAllObjects];
    NSNumber *specialPointId;
    NSNumber *nextSpecialPointId;
    bool isHybirdUnit = YES;
    
    NSMutableArray* sl = specialList;
    
    for (int i=0;i<[specialList count]-1;i++)
    {
        NSMutableArray *temp = [[NSMutableArray alloc]init];//temp 为 临 时 存 放 某 个 图 元 的 所 有 点 的 数 组
        specialPointId = [specialList objectAtIndex:i];
        nextSpecialPointId = [specialList objectAtIndex:i+1];
        for(int j=[specialPointId intValue];j<[nextSpecialPointId intValue];j++)
        {
            [temp addObject:[pList objectAtIndex:j]];
        }
        Gunit* unitTempAfterRecognize = [self recognize:temp];
        if(unitTempAfterRecognize != NULL || unitTempAfterRecognize.type == 2 || unitTempAfterRecognize.type == 3)
        {
            [gList addObject:unitTempAfterRecognize];
        }
        else
        {
            isHybirdUnit = NO;
            break;
        }
    }
    
    if(isHybirdUnit)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
