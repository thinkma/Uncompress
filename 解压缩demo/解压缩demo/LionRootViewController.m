//
//  LionRootViewController.m
//  解压缩demo
//
//  Created by Apple on 14-9-10.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "LionRootViewController.h"
#import "ZipArchive.h"

@interface LionRootViewController ()
{

    ZipArchive* zip;
    
}
@end

@implementation LionRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    [self zipFunction];
    
    [self unzip];
    
    // Do any additional setup after loading the view.
}

- (void)zipFunction
{
    zip = [[ZipArchive alloc] init];
    NSString *documentPath = [self documentsPath];
    NSString * zipFile = [documentPath stringByAppendingString:@"/images.zip"] ;
    
    NSString * image1 = [[NSBundle mainBundle] pathForResource:@"aaa" ofType:@"jpg" inDirectory:nil];
    NSString * image2 = [[NSBundle mainBundle] pathForResource:@"aaa" ofType:@"jpg" inDirectory:nil];
    BOOL result = [zip CreateZipFile2:zipFile];
    result = [zip addFileToZip:image1 newname:@"aaa.jpg"];
    result = [zip addFileToZip:image2 newname:@"bbb.jpg"];
    if( ![zip CloseZipFile2] ){
        zipFile = @"";
    }
    [zip release];
    NSLog(@"%@",NSHomeDirectory());
}



- (void)unzip
{
    zip = [[ZipArchive alloc] init];
    NSString *documentPath = [self documentsPath];
    NSString* zipFile = [documentPath stringByAppendingString:@"/images.zip"] ;
    NSString* unZipTo = [documentPath stringByAppendingString:@"/images"] ;
    if( [zip UnzipOpenFile:zipFile] ){
        BOOL result = [zip UnzipFileTo:unZipTo overWrite:YES];
        if( NO==result ){
            //添加代码
        }
        [zip UnzipCloseFile];

        NSString * imageField = [unZipTo stringByAppendingPathComponent:@"aaa.jpg"];
        NSData * imagedata = [NSData dataWithContentsOfFile:imageField];
        UIImage * image = [UIImage imageWithData:imagedata];
        
        UIImageView * iamgePic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        
        [iamgePic setImage:image];
        
        [self.view addSubview:iamgePic];
        /*
         NSString *imageFilePath = [path stringByAppendingPathComponent:@"photo.png"];
         NSString *textFilePath = [path stringByAppendingPathComponent:@"text.txt"];
         NSData *imageData = [NSData dataWithContentsOfFile:imageFilePath options:0 error:nil];
         UIImage *img = [UIImage imageWithData:imageData];
         NSString *textString = [NSString stringWithContentsOfFile:textFilePath encoding:NSASCIIStringEncoding error:nil];
         */

    }
    [zip release];
}


- (void)downInternet
{

    dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:@"http://www.icodeblog.com/wp-content/uploads/2012/08/zipfile.zip"];
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
        
        if(!error)
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            NSString *zipPath = [path stringByAppendingPathComponent:@"zipfile.zip"];
            
            [data writeToFile:zipPath options:0 error:&error];
            
            if(!error)
            {
                ZipArchive *za = [[ZipArchive alloc] init];
                if ([za UnzipOpenFile: zipPath]) {
                    BOOL ret = [za UnzipFileTo: path overWrite: YES];
                    if (NO == ret){} [za UnzipCloseFile];
                    
                    NSString *imageFilePath = [path stringByAppendingPathComponent:@"photo.png"];
                    NSString *textFilePath = [path stringByAppendingPathComponent:@"text.txt"];
                    NSData *imageData = [NSData dataWithContentsOfFile:imageFilePath options:0 error:nil];
                    UIImage *img = [UIImage imageWithData:imageData];
                    NSString *textString = [NSString stringWithContentsOfFile:textFilePath encoding:NSASCIIStringEncoding error:nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
      
                        
                        //  code 写得到的img 和  textString 进行处理
                        
                    });
                }
            }
            else
            {
                NSLog(@"Error saving file %@",error);
            }
        }
        else
        {
            NSLog(@"Error downloading zip file: %@", error);
        }
        
    });



    
}

- (NSString *)documentsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    return documentPath;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
