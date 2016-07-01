//
//  BubbleView.m
//  Mei
//
//  Created by fwr on 15/12/3.
//  Copyright © 2015年 pan chow. All rights reserved.
//

#import "PaoPaoMovingView.h"
#import "UIColor+RandomColor.h"

#define kRowNumber  5 //每行个数
#define kViewItemWidth  50
#define kViewItemHeight 50

@interface PaoPaoMovingView()
{
    CGFloat ViewHeight;
}
@property (nonatomic,strong)NSMutableArray *btnArray;
@end

@implementation PaoPaoMovingView


+(instancetype)shareInstance
{
    static PaoPaoMovingView *instance;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
       
        instance = [[PaoPaoMovingView alloc] init];
    });
    return instance;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
     }
    return self;
}


-(void)awakeFromNib{
    self.userInteractionEnabled = YES;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self awakeFromNib];

    }
    return self;
}


-(NSMutableArray*) btnArray
{
    if(!_btnArray)
    {
       _btnArray = [[NSMutableArray alloc] init];
    }
    
    return _btnArray;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}


-(NSMutableArray *)GetColorArray
{
    NSArray *hex=[NSArray arrayWithObjects:@"#f29b76", @"#84ccc9",@"#f8b551", @"#88abda", @"#89c997",@"#eb6877", @"#f39800",@"#99CCFF", @"#FFCCCC",@"#CCFFFF",@"#66CCCC",@"#CCFF66",@"#FF99CC",@"#FF9999",@"#FFCC99",@"#FF6666",@"#FFFF66",@"#99CC66",nil];
    NSMutableArray *colorArray=[[NSMutableArray alloc]init];
    for (int i=0; i<hex.count; i++)
    {
        [colorArray addObject:[UIColor colorFromHexString:hex[i]]];
    }
    return colorArray;
}


-(void)initWithButtonTitleArray:(NSArray *)arrTitle ButtonDetailArray:(NSArray *)arrDetail delegate:(id /*<PaoPaoMovingViewDelegate>*/)delegate showInView:(UIView *)view
{
    [view addSubview:self];

    [self.btnArray addObjectsFromArray:arrTitle];
     if(delegate)
     {
         self.delegate = delegate;
     }
     else
     {
        self.delegate = nil;
     }
    
    CGFloat btnWidth = kViewItemWidth;
    CGFloat btnHeight = kViewItemHeight;
    NSInteger index = arrTitle.count;
    NSInteger vIndex = index/kRowNumber ;
    NSInteger hIndex = index % kRowNumber;
    CGFloat radWidth = self.width/kRowNumber;

    for (int i = 0; i < vIndex +1; i++)
    {
        if(i == vIndex)
        {
            int num = 0;
            radWidth = self.width / hIndex;
            for (int j = 0; j< hIndex; j++)
            {
                int  w = [self getRandomNumber:num + 30 to:(j + 1)*radWidth - 30];
                int top = [self getRandomNumber:0 to:20];
                UIView *tepView =[[UIView alloc] initWithFrame:CGRectMake(w - 20,  btnHeight*(i + 1)*1.5 + top, btnWidth, btnHeight)];
                tepView.layer.cornerRadius = btnWidth/2;
                tepView.clipsToBounds = YES;
                tepView.layer.masksToBounds = YES;
                tepView.backgroundColor = [UIColor whiteColor];
                [tepView.layer setBorderWidth:2];//设置边界的宽度
                //tepView.layer.borderColor = [[UIColor randomColor] CGColor];
                tepView.layer.borderColor =[[self GetColorArray][j] CGColor];
                [tepView setUserInteractionEnabled:YES];
                tepView.tag =i*kRowNumber+ j; //当前的Tag
                
                UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemBtn:)];
                [tepView addGestureRecognizer:tap];
                
                int time = [self getRandomNumber:2 to:4];
                [self startYunMove:tepView RunTime: time];
                [self addSubview:tepView];
                
                UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 15, 50,15)];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.font = UIFont14;
                titleLabel.text =[arrTitle objectAtIndex: i*kRowNumber+ j];
                titleLabel.textColor = [UIColor blackColor];
                titleLabel.font =[UIFont systemFontOfSize:10];
                [tepView addSubview:titleLabel];
                
                UILabel *detailLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 30, 50,15)];
                detailLabel.textAlignment = NSTextAlignmentCenter;
                
                NSInteger count = [[arrDetail objectAtIndex: i*kRowNumber+ j] integerValue];
                NSString *countStr = [NSString stringWithFormat:@"%@",[CommonHelper getCountStringWith9999_K_W:count]];
                detailLabel.text =countStr;
                
                detailLabel.textColor = [UIColor blackColor];
                detailLabel.font =[UIFont systemFontOfSize:10];
                [tepView addSubview:detailLabel];
                
                num = (j+1)*radWidth;
             }
        }
        else
        {
            int num = 0;
            for(int j =0; j< kRowNumber; j ++)
            {
                int  w = [self getRandomNumber:num + 30 to:(j + 1)*radWidth - 30];
                int top = [self getRandomNumber:0 to:20];
                UIView *tepView =[[UIView alloc] initWithFrame:CGRectMake(w - 20-12,  btnHeight*(i + 1)*1.5 + top-40, btnWidth, btnHeight)];
                 tepView.layer.cornerRadius = btnWidth/2;
                tepView.clipsToBounds = YES;
                tepView.layer.masksToBounds = YES;
                tepView.backgroundColor = [UIColor whiteColor];
                [tepView.layer setBorderWidth:2];//设置边界的宽度
                //tepView.layer.borderColor = [[UIColor randomColor] CGColor];
                
                //int i=arc4random()%18;
                tepView.layer.borderColor = [[self GetColorArray][arc4random()%arc4random()%18] CGColor];
                [tepView setUserInteractionEnabled:YES];
                tepView.tag =i*kRowNumber+ j; //当前的Tag
                UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemBtn:)];
                [tepView   addGestureRecognizer:tap];
                
                int time = [self getRandomNumber:2 to:4];

                [self addSubview:tepView];
                
                UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 15, 50,15)];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.font = UIFont14;
                titleLabel.text =[arrTitle objectAtIndex: i*kRowNumber+ j];
                titleLabel.textColor = [UIColor blackColor];
                titleLabel.font =[UIFont systemFontOfSize:10];
                [tepView addSubview:titleLabel];
                
                titleLabel.tag =i*kRowNumber+ j;
                
                UILabel *detailLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 30, 50,15)];
                detailLabel.textAlignment = NSTextAlignmentCenter;
                
                NSInteger count = [[arrDetail objectAtIndex: i*kRowNumber+ j] integerValue];
                NSString *countStr = [NSString stringWithFormat:@"%@",[CommonHelper getCountStringWith9999_K_W:count]];
                detailLabel.text =countStr;
                detailLabel.textColor = [UIColor blackColor];
                detailLabel.font =[UIFont systemFontOfSize:10];
                [tepView addSubview:detailLabel];
                
                num = (j+1)*radWidth;
                
                [self startYunMove:tepView RunTime: time];
                
             }
        }
    }
}


-(void)startYunMove:(UIView *)btn RunTime:(int) time
{
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        CGRect frame = btn.frame;
        frame.origin.x = btn.frame.origin.x + 15;
        frame.origin.y = btn.frame.origin.y + 15;
        btn.frame = frame;
    } completion:^(BOOL finished) {
        [self endYunMove:btn RunTime:time];
    }];
}

-(void)endYunMove:(UIView *)btn RunTime:(int)time
{
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        CGRect frame = btn.frame;
        frame.origin.x = btn.frame.origin.x - 15;
        frame.origin.y = btn.frame.origin.y - 15;
        btn.frame = frame;
    } completion:^(BOOL finished) {
        [self startYunMove:btn RunTime:time];
    }];
    
}



//从哪到哪的随机数
-(CGFloat)getRandomNumber:(int)from to:(int)to
{
    return (CGFloat)(from + (arc4random() % (to - from + 1)));
}

- (void)itemBtn:(UIGestureRecognizer *)gesture
{
    UIView *tagView =(UIView *)gesture.view;
    NSLog(@"tagView.tag === %ld",(long)tagView.tag);
    
    if([self.delegate respondsToSelector:@selector(PaoPaoMovingView:didDissmissWithButtonIndex:ObjectItem:)])
    {
        [_delegate PaoPaoMovingView:self didDissmissWithButtonIndex:tagView.tag ObjectItem:(NSString *)[self.btnArray objectAtIndex:tagView.tag] ];
    }
}

- (void)dealloc
{
    
}



@end
