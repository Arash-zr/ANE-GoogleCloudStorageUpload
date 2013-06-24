//////////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Freshplanet (http://freshplanet.com | opensource@freshplanet.com)
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//    http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  
//////////////////////////////////////////////////////////////////////////////////////

#import "GoogleCloudStorageUpload.h"

FREContext GoogleCloudStorageUploadCtx = nil;

@implementation GoogleCloudStorageUpload

#pragma mark - Singleton

static GoogleCloudStorageUpload *sharedInstance = nil;

+ (GoogleCloudStorageUpload *)sharedInstance
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return self;
}

#pragma mark - GoogleCloudStorageUpload

+ (void)dispatchEvent:(NSString *)eventName withInfo:(NSString *)info
{
    if (GoogleCloudStorageUploadCtx != nil)
    {
        FREDispatchStatusEventAsync(GoogleCloudStorageUploadCtx, (const uint8_t *)[eventName UTF8String], (const uint8_t *)[info UTF8String]);
    }
}

+ (void)log:(NSString *)message
{
    [GoogleCloudStorageUpload dispatchEvent:@"LOGGING" withInfo:message];
}

@end


#pragma mark - C interface

void GoogleCloudStorageUploadContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
                        uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) 
{
    // Register the links btwn AS3 and ObjC. (dont forget to modify the nbFuntionsToLink integer if you are adding/removing functions)
    NSInteger nbFuntionsToLink = 0;
    *numFunctionsToTest = nbFuntionsToLink;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * nbFuntionsToLink);
    
    *functionsToSet = func;
    
    GoogleCloudStorageUploadCtx = ctx;
}

void GoogleCloudStorageUploadContextFinalizer(FREContext ctx) { }

void GoogleCloudStorageUploadInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
	*extDataToSet = NULL;
	*ctxInitializerToSet = &GoogleCloudStorageUploadContextInitializer;
	*ctxFinalizerToSet = &GoogleCloudStorageUploadContextFinalizer;
}

void GoogleCloudStorageUploadFinalizer(void *extData) { }
