//
//  Lib.m
//  TripLog
//
//  Created by Administrator on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Lib.h"
#import <CommonCrypto/CommonHMAC.h>
#import "THBReachability.h"
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIView+Toast.h"
#define AppNameTitle @"ExpensesEntry"

@implementation UIImage (Crop)


+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)crop:(CGRect)rect {
    if (self.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * self.scale,
                          rect.origin.y * self.scale,
                          rect.size.width * self.scale,
                          rect.size.height * self.scale);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}
@end

const NSString *emailRegEx =
@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
const NSString *numberRegEx = @"[0-9]+";


@implementation UIView(Extended)
- (UIImage *) imageByRenderingView {
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end


@implementation NSString (Utilities)
- (BOOL) isEmail {
	NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
	return [regExPredicate evaluateWithObject:self];
}
- (NSString*)trim {
    return [self stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end


static NSMutableDictionary* settings;
static NSString* _dbFilePath = nil; 
@implementation Lib


+ (NSArray*)sortListData:(NSArray*)dataSource sortWithKey:(NSString*)myKey isAsc:(BOOL)isAsc
{
	NSArray * result = nil;
	
	if(dataSource.count >0){
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:myKey ascending:isAsc];
		NSArray * tmpListEpisodeSorted = [dataSource sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
		result = tmpListEpisodeSorted;
	}
	return result;
}

+ (NSArray*)sortListDataDictionary:(NSMutableDictionary*)dataSource isAsc:(BOOL)isAsc
{
	NSArray * result = nil;
	NSArray *keys = [dataSource allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray *sortedValues = [[NSMutableArray alloc] init];
    
    for(id key in sortedKeys) {
        id object = [dataSource objectForKey:key];
        [sortedValues addObject:object];
    }
    result = [NSArray arrayWithArray:sortedValues];
	return result;
}
+(BOOL)object:(id)object classNamed:(NSString*)name {
    return [[[object class] description] isEqualToString:name];
}


//+(NSString*)imageBase64:(UIImage*)image {
//    NSString* retStr = nil;
//    NSData* data = UIImageJPEGRepresentation(image, 1.0);
//    if (data) {
//        retStr = [data base64EncodedString];
//    }
//    return retStr;
//}
//+(NSString*)randomID {
//    return [NSString stringWithFormat:@"%i%00i",[[NSDate date] timeIntervalSince1970],arc4random() % 999];
//}
//



+(NSString *)getUUID
{
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    NSString * uuidString = ( NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, newUniqueId));
    CFRelease(newUniqueId);
    
    return [uuidString lowercaseString];
}

+(NSString*)docDirPath {
    return [NSHomeDirectory() stringByAppendingString:@"/Documents"];
}

+(void)showConfirmAlert:(NSString*)title withMessage:(NSString*)msg delegate:(UIViewController*)delegate{
    if (!title || [title isEqual: @""]) {
        title = AppNameTitle;
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:delegate
                                              cancelButtonTitle:NSLocalizedString(@"STR_BTN_OK", nil)
                                              otherButtonTitles:NSLocalizedString(@"STR_BTN_CANCEL", nil),nil];
    [alertView show];
    alertView = nil;
}


+(void)showAlert:(NSString*)title withMessage:(NSString*)msg {
    if (!title || [title isEqual: @""]) {
        title = AppNameTitle;
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg 
                                                       delegate:nil 
                                              cancelButtonTitle:NSLocalizedString(@"OK_TITLE", nil)
                                              otherButtonTitles:nil,nil];
    [alertView show];
    alertView = nil;
}

+(void) showToast:(NSString *) message onview:(UIView *) view andduration:(int ) duration
{
    [view makeToast:message duration:duration position:@"CENTER"];
}



+(BOOL)NSStringIsValidEmail:(NSString *)checkString{

        BOOL stricterFilter = NO;
        NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
        NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
        NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:checkString];
}
+(id)getValueOfKey:(NSString*)key {	
	if (!settings) {
		settings = [[NSUserDefaults standardUserDefaults] objectForKey:@"Mileage.settings"];
		if (!settings) {
			settings = [[NSMutableDictionary alloc] init];
		}
	}
	if ([settings objectForKey:key]) {
		return [settings objectForKey:key];
	}
	
	return nil;
}
+(void)setValue:(id)value ofKey:(NSString*)key {
	if (!settings) {
		settings = [[NSUserDefaults standardUserDefaults] objectForKey:@"Mileage.settings"];
		if (!settings) {
			settings = [[NSMutableDictionary alloc] init];
		}
	}
    if (value) {
        [settings setObject:value forKey:key];        
    } else {
        [settings removeObjectForKey:key];
    }
    
	[[NSUserDefaults standardUserDefaults] setObject:settings forKey:@"Mileage.settings"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)showLoadingViewOn2:(UIView *)aView withAlert:(NSString *)text{
	
	UIView *loadingView = [[[UIView alloc] init] autorelease];
	loadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|
	UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
	loadingView.frame = ([Lib isIphone])?CGRectMake(0, 0, aView.frame.size.width, aView.frame.size.height):CGRectMake(0, 0, aView.frame.size.width, aView.frame.size.height-80);
	loadingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
	loadingView.tag = 1011;
	
	
	UIView* roundedView = [[[UIView alloc] init] autorelease];
    if (text && ![text isEqualToString:@""]) {
        roundedView.frame = CGRectMake(0, 0, 200, 80);
    }else{
        roundedView.frame = CGRectMake(0, 0, 140, 70);
    }
    
	roundedView.center = CGPointMake(loadingView.frame.size.width/2, loadingView.frame.size.height/2);
	roundedView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
	roundedView.layer.borderColor = [UIColor clearColor].CGColor;
	roundedView.layer.borderWidth = 1.0;
	roundedView.layer.cornerRadius = 10.0;
	[loadingView addSubview:roundedView];
    
	roundedView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    if (text && ![text isEqualToString:@""]) {
        UILabel *loadingLabel = [[[UILabel alloc ] init] autorelease];
        loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        loadingLabel.text = text;
        loadingLabel.frame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y + 50, 200, 30);
        //loadingLabel.adjustsFontSizeToFitWidth = YES;
        loadingLabel.textAlignment = NSTextAlignmentCenter;
        loadingLabel.font = [UIFont boldSystemFontOfSize:14];
        loadingLabel.backgroundColor = [UIColor clearColor];
        loadingLabel.textColor = [UIColor whiteColor];
        [loadingView addSubview:loadingLabel];
    }
	
	UIActivityIndicatorView *activityIndication = [[[UIActivityIndicatorView alloc] init] autorelease];
	activityIndication.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    if (text && ![text isEqualToString:@""]) {
        activityIndication.frame = CGRectMake(roundedView.frame.size.width/2 - 15, 15,
                                              30,
                                              30);
    }else{
        activityIndication.frame = CGRectMake(roundedView.frame.size.width/2 - 15,
                                              roundedView.frame.size.height/2 - 15,
                                              30,
                                              30);
    }
	
	
	[activityIndication startAnimating];	
	[roundedView addSubview:activityIndication];
	activityIndication.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;

	[aView addSubview:loadingView];
}

+ (void)removeLoadingViewOn:(UIView *)superView{
	for (UIView *aView in superView.subviews) {
		if ((aView.tag == 1011)  && [aView isKindOfClass:[UIView class]]) {
			[aView removeFromSuperview];
		}
	}
}

+ (void)showIndicatorViewOn2:(UIView *)aView{
	
	UIActivityIndicatorView *activityIndication = [[[UIActivityIndicatorView alloc] init] autorelease];
	activityIndication.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	int width = [Lib isIphone]?20:30;
	activityIndication.frame = CGRectMake((aView.frame.size.width - width)/2,
										  (aView.frame.size.height-width)/2,
										  width,
										  width);
	
	activityIndication.tag = 1012;
	[activityIndication startAnimating];	
	activityIndication.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
	
	
	[aView addSubview:activityIndication];
}

+ (void)removeIndcatorViewOn:(UIView *)superView {
	for (UIView *aView in superView.subviews) {
		if ((aView.tag == 1012)  && [aView isKindOfClass:[UIActivityIndicatorView class]]) {
			[aView removeFromSuperview];
		}
	}
}
+ (NSString*) cacheDirectoryName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"FreePPFolder"];
    BOOL isDir = NO;
    NSError *error;
    if (! [[NSFileManager defaultManager] fileExistsAtPath:cacheDirectoryName isDirectory:&isDir] && isDir == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectoryName withIntermediateDirectories:NO attributes:nil error:&error];
    }
    return cacheDirectoryName;
}
+(NSDate*)getThisWeek {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents* components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] - 1))]; 
    NSDate *thisWeek  = [cal dateFromComponents:components];
    
//    [components setDay:([components day] - 7)];
//    NSDate *lastWeek  = [cal dateFromComponents:components];
//    
//    [components setDay:([components day] - ([components day] -1))]; 
//    NSDate *thisMonth = [cal dateFromComponents:components];
//    
//    [components setMonth:([components month] - 1)]; 
//    NSDate *lastMonth = [cal dateFromComponents:components];
//    
//    NSLog(@"today=%@",today);
//    NSLog(@"yesterday=%@",yesterday);
//    NSLog(@"%@",thisWeek);  
    //    NSLog(@"lastWeek=%@",lastWeek);
//    NSLog(@"thisMonth=%@",thisMonth);
//    NSLog(@"lastMonth=%@",lastMonth);
    return thisWeek;
}

+(NSDate*)getThisMonth {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents* components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components day] -1))]; 
    NSDate *thisMonth = [cal dateFromComponents:components];
        
    //    [components setMonth:([components month] - 1)]; 
    //    NSDate *lastMonth = [cal dateFromComponents:components];
    //    
    //    NSLog(@"today=%@",today);
    //    NSLog(@"yesterday=%@",yesterday);
    //    NSLog(@"lastWeek=%@",lastWeek);
//    NSLog(@"thisMonth=%@",thisMonth);
    //    NSLog(@"lastMonth=%@",lastMonth);
    return thisMonth;
}

+(NSDate*)getLastMonth {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents* components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components day] -1))];
    [components setMonth:([components month] - 1)]; 
    NSDate *lastMonth = [cal dateFromComponents:components];
    //    
    //    NSLog(@"today=%@",today);
    //    NSLog(@"yesterday=%@",yesterday);
    //    NSLog(@"lastWeek=%@",lastWeek);
    //NSLog(@"thisMonth=%@",thisMonth);
//    NSLog(@"lastMonth=%@",lastMonth);
    return lastMonth;
}
+(BOOL)isIphone {
    //NSString *deviceType = [UIDevice currentDevice].model;
    //return [deviceType isEqualToString:@"iPhone"];
    return !(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad);
}

+ (BOOL)isPhone5{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if (IS_HEIGHT_GTE_568) {
            return YES;
        }
        return NO;
    }
    return NO;
}

+ (void)customWebview : (UIWebView *)aWebView {
	// tranparent WebView
	aWebView.opaque = NO;
	aWebView.backgroundColor = [UIColor clearColor];
	// web view
	id scroller = [aWebView.subviews objectAtIndex:0];
	
	for (UIView *subView in [scroller subviews])
		if ([[[subView class] description] isEqualToString:@"UIImageView"])
			subView.hidden = YES;
    
}

+(void)saveString:(NSString*)_str forKey:(NSString*)_key {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:_str forKey:_key];
	[prefs synchronize];
}

+(NSString*)getStringForKey:(NSString*)_key {
	return [[NSUserDefaults standardUserDefaults] stringForKey:_key];
	
}



//+ (NSString *) encodeWithHmacsha1:(NSString *)secret andContent:(NSString*)content{
//    //content =@"{\"params\":[\"password\",\"dsdsds\",\"email\",\"dsdsds@gamil.com\"],\"jsonrpc\":\"2.0\",\"id\":\"5\",\"method\":\"user.login\"}";
//    
//    NSMutableString *newContent = [[NSMutableString alloc] initWithFormat:@"/api/"];
//    [newContent appendString:@"\n"];
//    [newContent appendString:content];
//
//    
//	const char *cKey  = [secret cStringUsingEncoding:NSASCIIStringEncoding];
//	const char *cData = [newContent cStringUsingEncoding:NSASCIIStringEncoding];
//	
//	unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
//	
//	CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
//	//NSLog(@"--- %i",sizeof(cHMAC));
//	NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
//	
//	NSString* hMacStr = [HMAC base64EncodedString];
//
//    int padding = [hMacStr length] % 4;
//    if (padding) hMacStr = [hMacStr stringByAppendingFormat:@"%@",[@"====" substringToIndex:4-padding]];
//    
//    NSLog(@"L: %i %@",[hMacStr length], hMacStr);
//    return hMacStr;
//}

+ (void) setTitle:(NSString*)title forNavigationItem:(UINavigationItem*)navItem{
	CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:20.0]];
	
	CGRect frame = CGRectMake(0, 0, size.width, 40);
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor blackColor];
	label.text = title;	
	
	navItem.titleView = label;
}

+ (void) setTitle:(NSString*)title forNavigationItem:(UINavigationItem*)navItem withFontSize:(CGFloat) fontSize{
	CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:fontSize]];
	
	CGRect frame = CGRectMake(0, 0, size.width, 40);
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:fontSize];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor blackColor];
	label.text = title;	
	
	navItem.titleView = label;
}

//+(NSString*)getCountryNameISO3166:(NSString*)countryCode{
//    NSString *countryName;
//    switch (countryCode) {
//        case @"AR":
//            
//            break;
//            
//        default:
//            break;
//    }
//}

+(void)saveImage:(UIImage*)image withPath:(NSString *)imagePath{
    
    image = [UIImage imageWithImage:image scaledToSize:CGSizeMake(189, 189*image.size.height/image.size.width)];
    
    NSData *imageData = UIImageJPEGRepresentation(image,1.0); //convert image into .png format.
    
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:imagePath]; //add our image to the path
    
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
} 

+ (BOOL) checkRetina{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        // Retina display
        return YES;
    } else {
        // non-Retina display
        return NO;
    }
}

+(UIImage*)scaleAndRotateImage:(UIImage *)image
{
    // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    int kMaxResolution = width;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    CGFloat scaleRatio = 1;
    
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;

    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    scaleRatio=1;
    NSLog(@"ori:%d",orient);
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -1, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //    [self setRotatedImage:imageCopy];
    return imageCopy;
}

+ (UIColor *)randomColor{
    CGFloat red = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat green = ( arc4random() % 256 / 256.0 );  //  0.5 to 1.0, away from white
    CGFloat blue = ( arc4random() % 256 / 256.0 );  //  0.5 to 1.0, away from black
    
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    return color;
}

+ (void)showAlertNoInternetConnection{
    [Lib showAlert:@"No Internet Connection" withMessage:@"You can't create or edit data"];
}

+ (void)showAlertOfflineMode{

    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"STR_MSG_ERROR", nil)
                                                        message:NSLocalizedString(@"STR_MSG_NO_NETWORK", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"STR_BTN_OK", nil)
                                              otherButtonTitles:nil,nil];
    [alertView show];
    alertView = nil;
}



+ (NSString *)getFahrenheitFromCelsius:(NSString*)temp{
    float celsius = [temp floatValue];
    float fahrenheit = (celsius*9/5) + 32;
    return [NSString stringWithFormat:@"%0.1f",fahrenheit];
}

+ (NSString *)getKelvinFromCelsius:(NSString*)temp{
    float celsius = [temp floatValue];
    float kelvin = celsius + 273.15;
    return [NSString stringWithFormat:@"%0.1f",kelvin];
}

+(BOOL)isNoInternetConnectionOrOffLine{
    if ([self isOfflineMode]) {
        return YES;
    }else{
        return [self isNoInternetConnection];
    }
}

+(BOOL)isNoInternetConnection{    
    if ([[THBReachability reachabilityForInternetConnection] currentReachabilityStatus]==NotReachable) {
        [self showAlert:@"No Internet Connection!" withMessage:@"You have no internet connection!"];
        return YES;
    }
    return NO;
}

+ (NSString *)timeFromSeconds:(double)totalSeconds showSeconds:(BOOL)show
{
    int seconds = (int)totalSeconds % 60;
    int minutes = (int)(totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    if (show) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    }else{
        return [NSString stringWithFormat:@"%02d:%02d",hours, minutes];
    }
    
//    NSString *timeStr = @"";
//    if (hours > 0) {
//        timeStr  = [timeStr stringByAppendingFormat:@"%d:", hours];
//    }
//    
//    if (minutes > 0) {
//        timeStr = [timeStr stringByAppendingFormat:@"%d", minutes];
//    }
//    
//    if (show) {
//        timeStr = [timeStr stringByAppendingFormat:@"%d", seconds];
//    }
    
}

+ (BOOL)internetConnected{
    NetworkStatus status = [[THBReachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (status != NotReachable) {
        return TRUE;
    }
    return FALSE;
}

+ (NSString *)filterStr:(NSString *)str withCharacters:(NSString *)charSet{
//    NSString *inputStr = [str lowercaseString];
    NSString *inputStr = str;
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:inputStr.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:inputStr];
    NSCharacterSet *filter = [NSCharacterSet
                              characterSetWithCharactersInString:charSet];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:filter intoString:&buffer]) {
            [strippedString appendString:buffer];
            
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    return strippedString;
}
+ (BOOL)displayImageAssetPhotoPath:(NSString *)path with:(UIImageView *)imageView{
    __block BOOL success;
    [Lib showIndicatorViewOn2:imageView];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        UIImage *image;
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        if (iref) {
            image = [UIImage imageWithCGImage:iref];
            imageView.image = image;
            success = YES;
            [Lib removeIndcatorViewOn:imageView];
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"assets failed");
        success = NO;
        [Lib removeIndcatorViewOn:imageView];
    };
    
    if(path)
    {
        NSURL *asseturl = [NSURL URLWithString:path];
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:asseturl
                       resultBlock:resultblock
                      failureBlock:failureblock];
    }
    return  success;
}

+ (NSString *)getFileNameFromURL:(NSString *)url{
    NSArray *parts = [url componentsSeparatedByString:@"/"];
    NSString *filename = [parts objectAtIndex:[parts count]-1];
    return filename;
}

+ (NSString *)getFormattedTimeStringFromDate:(NSDate *)date withPartern:(NSString *)parternString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:parternString];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromDateString:(NSString *)dateString withPartern:(NSString *)parternString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:parternString];
    return [dateFormatter dateFromString:dateString];
}

+ (NSNumber *)getCompanyId{
    return [Lib getValueOfKey:[NSString stringWithFormat:@"CompanyId_%@", [Lib getValueOfKey:@"USER_ID"]]];
}

+ (NSDate *)entryDateFromUnixTimeStampString:(NSString *)unixTimeString{
    NSInteger startIndex = [unixTimeString rangeOfString:@"("].location;
    NSInteger endIndex = [unixTimeString rangeOfString:@"-"].location;
    long millis = [[unixTimeString substringWithRange:NSMakeRange(startIndex + 1, endIndex - startIndex - 1)] longLongValue];
    return [NSDate dateWithTimeIntervalSince1970:(millis/1000)];

}
+ (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

+ (NSString *) saveImagetoDocument:(UIImage *) image{
    NSString *filePath = @"";
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyymmdd hhMMss"];
    NSString * mstrCacheName = [self cacheDirectoryName];
    NSString *timeImage = [formater stringFromDate:[NSDate date]];
    NSString *imageName = [NSString stringWithFormat:@"Image_%@.jpg",timeImage];
    NSString *imagePath = [mstrCacheName stringByAppendingPathComponent:imageName];
    filePath = imagePath;
    NSData *pngData = UIImagePNGRepresentation(image);
    [pngData writeToFile:filePath atomically:YES];
    return filePath;
}

+(NSString *) getAudioDirectory{
    NSString *filePath = @"";
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyymmdd hhMMss"];
    NSString * mstrCacheName = [self cacheDirectoryName];
    NSString *timeImage = [formater stringFromDate:[NSDate date]];
    NSString *imageName = [NSString stringWithFormat:@"Audio%@.jpg",timeImage];
    NSString *imagePath = [mstrCacheName stringByAppendingPathComponent:imageName];
    filePath = imagePath;
    return filePath;
}

@end
