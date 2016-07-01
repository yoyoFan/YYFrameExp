#import <Foundation/Foundation.h>

/**
 *	@brief 带有占位字符的自定义UItextView
 */
@interface UIPlaceHolderTextView : UITextView {
    NSString *placeholder;
    UIColor *placeholderColor;
    
@private
    UILabel *placeHolderLabel;
}

/**
 *	@brief	占位文本Label
 */
@property (nonatomic, retain) UILabel *placeHolderLabel;

/**
 *	@brief	占位文本信息
 */
@property (nonatomic, retain) NSString *placeholder;

/**
 *	@brief	占位文本颜色
 */
@property (nonatomic, retain) UIColor *placeholderColor;


/**
 *	@brief	text文本更改监听触发事件
 *
 *	@param 	notification 	监听对象
 */
-(void)textChanged:(NSNotification*)notification;


@end