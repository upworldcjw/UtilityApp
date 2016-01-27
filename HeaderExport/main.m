//
//  main.m
//  HeaderExport
//
//  Created by jianwei.chen on 16/1/27.
//  Copyright © 2016年 jianwei.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString* runScript(NSString* scriptName);
NSString* writeDir();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
//        NSLog(@"Hello, World!");
//        if (argc != 2) {
//            NSLog(@"params invaild error");
//        }
//        system("find . -iname *.h >> PPUtilities.h");
        
        NSString *result = runScript(@"find . -iname *.h");// >> PPUtilities.h
        NSArray *lines = [result componentsSeparatedByString:@"/n"];
        NSMutableString *mutStr = [NSMutableString string];
        for (NSString *line in lines) {
            NSArray *items = [line componentsSeparatedByString:@"/"];
            if ([items count]) {
                NSString *headName = [items lastObject];
                [mutStr stringByAppendingFormat:@"#import \"%@.h\"\n",headName];
            }
        }
        [mutStr writeToFile:[writeDir() stringByAppendingPathComponent:@"PPUtilities.h"] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
        
        

    }
    return 0;
}


NSString* writeDir(){
    NSString *homeDir;
//    homeDir = [[NSBundle mainBundle] executablePath];
//    NSLog(@"executablePath %@",homeDir);
    homeDir = [[NSBundle mainBundle] bundlePath];
    NSLog(@"bundlePath dir %@",homeDir);
    return homeDir;
}

NSString* runScript(NSString* scriptName){
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    
    NSArray *arguments;
    NSString* newpath = [NSString stringWithFormat:@"%@/%@",writeDir(), scriptName];
    NSLog(@"shell script path: %@",newpath);
    arguments = [NSArray arrayWithObjects:newpath, nil];
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *string;
    string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
//    NSLog (@"script returned:\n%@", string);
    return string;
}