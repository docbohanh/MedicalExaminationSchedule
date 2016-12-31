//
//  Lib.h
//  TripLog
//
//  Created by Administrator on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface NSString (Utilities)
- (BOOL) isEmail;
- (NSString*)trim;
@end

@interface UIImage (Crop)
+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
- (UIImage *)crop:(CGRect)rect;
@end

@interface UIView(Extended)
- (UIImage *) imageByRenderingView;
@end

@interface Lib : NSObject<UIAlertViewDelegate> {
    
}
+(NSString *)cacheDirectoryName;
+(NSString *) getAudioDirectory;
+(NSString*) getErrorStringWithErrorCode:(int) errorCode;
+(BOOL) NSStringIsValidEmail:(NSString *)checkString;
+ (NSArray*)sortListData:(NSArray*)dataSource sortWithKey:(NSString*)myKey isAsc:(BOOL)isAsc;
+ (NSArray*)sortListDataDictionary:(NSMutableDictionary*)dataSource isAsc:(BOOL)isAsc;
+(BOOL)object:(id)object classNamed:(NSString*)name;
+(void)addMod:(UIViewController*)controller;
+(NSString*)randomID;
+(NSString*)imageBase64:(UIImage*)image;
+(NSString *)getUUID;
+ (NSString *) encodeWithHmacsha1:(NSString *)secret andContent:(NSString*)content;
+(BOOL)isIphone;
+ (BOOL)isPhone5;
+(NSString*)dbFilePath;
+(NSString*)docDirPath;
+(void)showAlert:(NSString*)title withMessage:(NSString*)msg;
+(id)getValueOfKey:(NSString*)key;
+(void)setValue:(id)value ofKey:(NSString*)key;

+(void)showLoadingViewOn2:(UIView *)aView withAlert:(NSString *)text;
+(void)removeLoadingViewOn:(UIView *)superView;
+(NSDate*)getThisWeek;
+(NSDate*)getThisMonth;
+(NSDate*)getLastMonth;
+(void)customWebview : (UIWebView *)aWebView;
+(void)showIndicatorViewOn2:(UIView *)aView;
+(void)removeIndcatorViewOn:(UIView *)superView;

+(void) showToast:(NSString *) message onview:(UIView *) view andduration:(int ) duration;
+(void)saveString:(NSString*)_str forKey:(NSString*)_key;
+(NSString*)getStringForKey:(NSString*)_key;

//+(NSString*)getCountryNameISO3166:(NSString*)countryCode;

+(UIImage*)captureMainScreen;

+(void)saveImage:(UIImage*)image withPath:(NSString*)imagePath;

+ (BOOL) checkRetina;
+ (NSString *)getModel;

+(UIImage*)scaleAndRotateImage:(UIImage *)image;
+ (NSMutableArray *)decodePolyLine:(NSString *)encodedStr;
+ (UIColor *)randomColor;
+ (void)showAlertNoInternetConnection;
+(void)showConfirmAlert:(NSString*)title withMessage:(NSString*)msg delegate:(UIViewController*)delegate;
+ (void)showAlertOfflineMode;
+ (NSArray *)fetchObjectsWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext forEntityName:(NSString *)name
                                    withPredicate:(NSPredicate *)predicate;

+ (NSString *)getFahrenheitFromCelsius:(NSString*)temp;
+ (NSString *)getKelvinFromCelsius:(NSString*)temp;

+(BOOL)isNoInternetConnectionOrOffLine;
+(BOOL)isNoInternetConnection;
+(BOOL)isOfflineMode;
+ (NSString *)getCurrency;
+ (NSString *)timeFromSeconds:(double)totalSeconds showSeconds:(BOOL)show;
+ (BOOL)internetConnected;
+ (NSString *)filterStr:(NSString *)str withCharacters:(NSString *)charSet;

+ (BOOL) displayImageAssetPhotoPath:(NSString *)path with:(UIImageView *)imageView;
+ (NSString *)getFileNameFromURL:(NSString *)url;
+ (NSString *)getFormattedTimeStringFromDate:(NSDate *)date withPartern:(NSString *)parternString;
+ (NSDate *)dateFromDateString:(NSString *)dateString withPartern:(NSString *)parrternString;

+ (NSNumber *)getCompanyId;

+ (NSDate *)entryDateFromUnixTimeStampString:(NSString *)unixTimeString;
+ (NSString *)timeFormatted:(int)totalSeconds;
+ (NSString *) saveImagetoDocument:(UIImage *) image;

@end
