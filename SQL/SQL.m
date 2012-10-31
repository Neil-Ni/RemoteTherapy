//
//  SQL.m
//  SQL
//
//  Created by Tzu-Yang Ni on 6/27/12.
//  Copyright (c) 2012 yoseka. All rights reserved.
//

#import "SQL.h"

#define ROOT @""

@implementation SQL
+ (NSString *)deletelog:(NSString *)Username{
    NSString *strURL = [NSString stringWithFormat:@"%@deletelog.php?name=%@",ROOT,Username];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    
    // to receive the returend value
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    return strResult;
}
+ (NSString *)appendlog:(NSString *)Username andResponse: (int)response andFolder:(NSString *)folder{
    NSString *strURL = [NSString stringWithFormat:@"%@appendlog.php?name=%@&number=%d&FolderName=%@",ROOT,Username, response, folder];
    NSLog(@"%@", strURL);
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    
    // to receive the returend value
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    return strResult;
}

+ (NSArray *) returnlog: (NSString *)Username{
    NSString *strURL = [NSString stringWithFormat:@"%@log.php?name=%@",ROOT,Username];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    // to receive the returend value
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSArray *array = [strResult componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
//    if([[array objectAtIndex:2] isEqualToString:@""]){
//        return 4;
//    };
    NSArray *tmp = [[NSArray alloc] initWithObjects:[array objectAtIndex:2],[array objectAtIndex:3],nil];
    return tmp;
}

+ (NSMutableArray *)returnURL: (NSString *)Username andNumber:(NSString *)number{
    NSString *strURL = [NSString stringWithFormat:@"%@returnimageurl.php?Username=%@&number=%@",ROOT,Username,number];
    NSLog(@"%@",strURL);
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    // to receive the returend value
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSArray *array = [strResult componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableArray *array2 = [[NSMutableArray alloc] init];
    for(NSString *s in array){
        NSLog(@"%@",s);
        if([s rangeOfString:@"http:/"].location!=NSNotFound){
            [array2 addObject:s];
        }
    }    
    return array2;
}

+ (NSString *)returnReceiver: (NSString *)Username{
    NSString *strURL = [NSString stringWithFormat:@"%@returnuser.php?Username=%@&sender=", ROOT,Username];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    
    // to receive the returend value
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSArray *array = [strResult componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableArray *array2 = [[NSMutableArray alloc] init];
    for(NSString *s in array){
//        NSLog(@"%@",s);
        [array2 addObject:s];
    };
    return [array2 objectAtIndex:2];
}
+ (NSString *)returnSender: (NSString *)Username{
    NSString *strURL = [NSString stringWithFormat:@"%@returnuser.php?Username=%@&receiver=", ROOT,Username];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSLog(@"%@", strURL);
    // to receive the returend value
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSArray *array = [strResult componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableArray *array2 = [[NSMutableArray alloc] init];
    for(NSString *s in array){
        NSLog(@"%@",s);
        [array2 addObject:s];
    };
    return [array2 objectAtIndex:3];
}

+ (BOOL) hasReceiver: (NSString *)Username{
    NSString *strURL = [NSString stringWithFormat:@"%@checkuser.php?Username=%@&receiver=", ROOT,Username];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    
    // to receive the returend value
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@", strResult);
    if ([strResult isEqualToString:@"0"]){
        return TRUE;
    }
    return FALSE;
}

+ (BOOL) hasSender: (NSString *)Username{
    NSString *strURL = [NSString stringWithFormat:@"%@checkuser.php?Username=%@&sender=", ROOT,Username];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    
    // to receive the returend value
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@", strResult);
    if ([strResult isEqualToString:@"0"]){
        return TRUE;
    }
    return FALSE;
}

+ (BOOL) LoginWithUserName:(NSString *)Username andPassword:(NSString *)Password{
    NSString *strURL = [NSString stringWithFormat:@"%@Login.php?Username=%@&Password=%@", ROOT,Username, Password];
    
    // to execute php code
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    
    // to receive the returend value
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    if ([strResult isEqualToString:@"1"]){
        return TRUE;
    }
    return FALSE;
}

+ (BOOL) UpdateImageUserName:(NSString *)Username andnumber:(NSString *)number andURL:(NSString *)url{
    
    NSString *strURL = [NSString stringWithFormat:@"%@UpdateImageURL.php?Username=%@&number=%@&url=%@", ROOT,Username, number, url];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    
    // to receive the returend value
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    if ([strResult isEqualToString:@"10"]){
        return TRUE;
    }
    return FALSE;
}


+ (NSString *) SignUpWithUserName:(NSString *)Username andPassword:(NSString *)Password hasReceiver:(NSString *)hasReceiver hasSender:(NSString *)hasSender{
    NSString *strURL = [NSString stringWithFormat:@"%@Signup.php?Username=%@&Password=%@&HasReceiver=%@&HasSender=%@", ROOT,Username, Password, hasReceiver, hasSender];
    // to execute php code
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    
    // to receive the returend value
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    return strResult;
}

+ (NSString *) UploadImageWithData:(NSData *)data andfileName:(NSString *)fileName{
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@Uploadimg.php", ROOT];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *tmp_string = [[NSString alloc] initWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n",fileName];
    [body appendData:[[NSString stringWithString:tmp_string] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:data]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // now lets make the connection to the web
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    return returnString;
}

+ (UIImage*)imageWithImage:(UIImage*)image 
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
