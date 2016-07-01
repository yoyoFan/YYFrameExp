//
//  TagView.m
//  FlowExp
//
//  Created by pan chow on 14-4-30.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "TagView.h"
#import "TagItemView.h"

#define x_Margin 10.0f
#define y_Margin 5.0f

#define time_inteval .4f
@interface TagView ()<TagItemViewDelegate>
{
    BOOL _isAddBtn;
    BOOL _isPermitLongPress;
}
@property (nonatomic,strong)NSMutableArray *tagTitles;
@property (nonatomic,strong)NSMutableArray *tagItems;
@end
@implementation TagView

- (void)reset
{
    [_tagItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_tagItems removeAllObjects];
    [_tagTitles removeAllObjects];
    
    if(_isAddBtn)
    {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame=CGRectMake(x_Margin, y_Margin, 73, 27);
        [btn setImage:[UIImage imageNamed:@"tagedit.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tageditc.png"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.tagItems addObject:btn];
    }

}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.tagItems=[NSMutableArray array];
        self.tagTitles=[NSMutableArray array];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled=YES;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame colors:(NSArray *)colors addBtn:(BOOL)isAdd longPress:(BOOL)isPermit
{
    self=[self initWithFrame:frame];
    if(self)
    {
        self.colors=colors;
        _isAddBtn=isAdd;
        _isPermitLongPress=isPermit;
        if(_isAddBtn)
        {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.frame=CGRectMake(x_Margin, y_Margin, 73, 27);
            [btn setImage:[UIImage imageNamed:@"tagedit.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"tageditc.png"] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.tagItems addObject:btn];
        }
    }
    return self;
}
- (void)setTagItem:(NSString *)title animated:(BOOL)animated
{
    if(!title && _tagItems.count==1)
    {
        UIView *view=[_tagItems lastObject];
        
        view.frame=CGRectMake(x_Margin, y_Margin, view.width, view.height);
        self.frame=CGRectMake(self.left, self.top, self.width, view.bottom+y_Margin);
        [self addSubview:view];
    }
    else
    {
        if([self.tagTitles containsObject:title])
        {
            return;
        }
        if(title)
        {
            [_tagTitles addObject:title];
        }
        
        TagItemView *view=nil;
        
        TagItemView *tagView=[[TagItemView alloc] initWithFrame:CGRectMake(0, 0, 50, 27)];
        tagView.delegate=self;
        tagView.permitLongPress=_isPermitLongPress;
        NSInteger index=0;
        if(_isAddBtn)
        {
            index=(_tagItems.count-1)%_colors.count;
        }
        else
        {
            index=(_tagItems.count>0)?(_tagItems.count%_colors.count):0;
        }
        
        NSDictionary *color=_colors[index];
        
        [tagView setTitle:title colors:color];
        if(_isAddBtn)
        {
            if(_tagItems.count>1)
            {
                view=[_tagItems objectAtIndex:_tagItems.count-2];
                
                if(view.right+x_Margin+tagView.width>self.width)
                {
                    tagView.frame=CGRectMake(x_Margin, view.bottom+y_Margin, tagView.width, tagView.height);
                }
                else
                {
                    tagView.frame=CGRectMake(x_Margin+view.right, view.top, tagView.width, tagView.height);
                }
            }
            else
            {
                tagView.frame=CGRectMake(x_Margin, y_Margin, tagView.width, tagView.height);
            }
            if(![_tagItems containsObject:tagView])
            {
                [_tagItems insertObject:tagView atIndex:_tagItems.count-1];
            }
            
            if(animated)
            {
                tagView.alpha=.0f;
                [self addSubview:tagView];
                [UIView animateWithDuration:time_inteval animations:^{
                    tagView.alpha=1.0f;
                }];
            }
            else
            {
                [self addSubview:tagView];
            }
            
            UIButton *btn=[_tagItems lastObject];
            [btn removeFromSuperview];
            if(tagView.right+x_Margin+btn.width>self.width)
            {
                btn.frame=CGRectMake(x_Margin, tagView.bottom+y_Margin, btn.width, btn.height);
            }
            else
            {
                btn.frame=CGRectMake(x_Margin+tagView.right, tagView.top, btn.width, btn.height);
            }
            [self addSubview:btn];
            
            self.frame=CGRectMake(self.left, self.top, self.width, btn.bottom+y_Margin);
        }
        else
        {
            if(_tagItems.count>0)
            {
                view=[_tagItems lastObject];
                
                if(view.right+x_Margin+tagView.width>self.width)
                {
                    tagView.frame=CGRectMake(x_Margin, view.bottom+y_Margin, tagView.width, tagView.height);
                }
                else
                {
                    tagView.frame=CGRectMake(x_Margin+view.right, view.top, tagView.width, tagView.height);
                }
            }
            else
            {
                tagView.frame=CGRectMake(x_Margin, y_Margin, tagView.width, tagView.height);
            }
            if(![_tagItems containsObject:tagView])
            {
                [self.tagItems addObject:tagView];
            }
            
            if(animated)
            {
                tagView.alpha=.0f;
                [self addSubview:tagView];
                [UIView animateWithDuration:time_inteval animations:^{
                    tagView.alpha=1.0f;
                }];
            }
            else
            {
                [self addSubview:tagView];
            }
            self.frame=CGRectMake(self.left, self.top, self.width, tagView.bottom+y_Margin);
        }

    }
}
- (void)setTagItems:(NSArray *)titles animated:(BOOL)animated
{
    if((!titles || titles.count==0) && _isAddBtn)
    {
        [self setTagItem:nil animated:YES];
        return;
    }
    [titles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *title=obj;
        
        [self setTagItem:title animated:animated];
    }];
}
- (void)addBtn:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(tagViewAddPressed)])
    {
        [_delegate tagViewAddPressed];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)tap:(UITapGestureRecognizer *)tap
{
    [_tagItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TagItemView *view=obj;
        if([view respondsToSelector:@selector(stopShake)])
        {
            [view stopShake];
        }
    }];
}
#pragma mark --- tagItemView delegate ---
- (void)tagItemViewLongPressed:(TagItemView *)tagView toShake:(BOOL)shake
{
    [_tagItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TagItemView *view=obj;
        if(shake)
        {
            if([view respondsToSelector:@selector(shake)])
            {
                [view shake];
            }
        }
        else
        {
            if([view respondsToSelector:@selector(stopShake)])
            {
                [view stopShake];
            }
        }
        
    }];
}
- (void)tagItemViewDeleteBtnPressed:(TagItemView *)tagView
{
    [tagView removeFromSuperview];
    NSInteger index=[_tagItems indexOfObject:tagView];
    [_tagItems removeObject:tagView];
    
    [_tagTitles removeObjectAtIndex:index];
    if([self.delegate respondsToSelector:@selector(TagViewDelegateFinishedbyIndex:)])
    {
        [_delegate TagViewDelegateFinishedbyIndex:index];
    }
     for(int i=index;i<_tagItems.count;i++)
    {
        [self changeTagLayoutByIndex:i];
    }
}
- (void)tagItemViewAddBtnPressed:(TagItemView *)tagView
{
    
}
- (void)tagItemViewPressed:(TagItemView *)tagView
{
    NSInteger index=[_tagItems indexOfObject:tagView];
    if(index>=0)
    {
        if([self.delegate respondsToSelector:@selector(tagItemPressedInTagView:index:)])
        {
            [_delegate tagItemPressedInTagView:self index:index];
        }
    }
}
- (void)changeTagLayoutByIndex:(NSInteger)index
{
    TagItemView *preItemView=nil;
    if(index>0)
    {
        preItemView=_tagItems[index-1];
    }
    UIView *curretView=_tagItems[index];
    if(preItemView)
    {
        if(preItemView.right+x_Margin+curretView.width>self.width)
        {
            curretView.frame=CGRectMake(x_Margin, preItemView.bottom+y_Margin, curretView.width, curretView.height);
            curretView.center=CGPointMake(curretView.centerX, preItemView.bottom+2*y_Margin+preItemView.height*.5);
        }
        else
        {
            curretView.frame=CGRectMake(x_Margin+preItemView.right, preItemView.top, curretView.width, curretView.height);
            curretView.center=CGPointMake(curretView.centerX, preItemView.centerY);
        }
    }
    else
    {
        curretView.frame=CGRectMake(x_Margin,y_Margin, curretView.width, curretView.height);
    }
    if(index==_tagItems.count-1)
    {
        UIView *vw=[_tagItems lastObject];
        self.frame=CGRectMake(self.left, self.top, self.width, vw.bottom+y_Margin);
        
        if([self.delegate respondsToSelector:@selector(TagViewDelegateFinished)])
        {
            [_delegate TagViewDelegateFinished];
        }
    }
}
@end
