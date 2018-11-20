/**
 * Copyright 2018 Alibaba Group
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "EBWXOldModule.h"
#import <WeexSDK/WeexSDK.h>
#import "EBExpressionHandler.h"
#import <pthread/pthread.h>
#import <WeexPluginLoader/WeexPluginLoader.h>
#import "EBBindData.h"
#import "EBUtility+WX.h"
#import "EBWXUtils.h"

WX_PlUGIN_EXPORT_MODULE(expressionBinding, EBWXOldModule)

@interface EBWXOldModule ()

@property (nonatomic, strong) EBBindData *bindData;

@end

@implementation EBWXOldModule {
    pthread_mutex_t mutex;
    pthread_mutexattr_t mutexAttr;
}

@synthesize weexInstance;

WX_EXPORT_METHOD_SYNC(@selector(enableBinding:eventType:))
WX_EXPORT_METHOD_SYNC(@selector(createBinding:eventType:exitExpression:targetExpression:callback:))
WX_EXPORT_METHOD_SYNC(@selector(disableBinding:eventType:))
WX_EXPORT_METHOD_SYNC(@selector(disableAll))
WX_EXPORT_METHOD_SYNC(@selector(supportFeatures))
WX_EXPORT_METHOD_SYNC(@selector(getComputedStyle:))

- (instancetype)init {
    if (self = [super init]) {
        pthread_mutexattr_init(&mutexAttr);
        pthread_mutexattr_settype(&mutexAttr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&mutex, &mutexAttr);
        _bindData = [EBBindData new];
    }
    return self;
}

- (void)dealloc {
    [self disableAll];
    pthread_mutex_destroy(&mutex);
    pthread_mutexattr_destroy(&mutexAttr);
}

- (void)enableBinding:(NSString *)sourceRef
            eventType:(NSString *)eventType {
    if ([WXUtility isBlankString:sourceRef] || [WXUtility isBlankString:eventType]) {
        WX_LOG(WXLogFlagWarning, @"enableBinding params error");
        return;
    }
    
    if (![EBEventHandlerFactory containsEvent:eventType]) {
        WX_LOG(WXLogFlagWarning, @"enableBinding params error");
        return;
    }
    
    __weak typeof(self) welf = self;
    WXPerformBlockOnComponentThread(^{
        // find sourceRef & targetRef
        WXComponent *sourceComponent = [weexInstance componentForRef:sourceRef];
        if (!sourceComponent) {
            WX_LOG(WXLogFlagWarning, @"enableBinding can't find component");
            return;
        }
        
        pthread_mutex_lock(&mutex);
        
        EBExpressionHandler *handler = [welf.bindData handlerForToken:sourceRef eventType:eventType];
        if (!handler) {
            // create handler for key
            handler = [EBEventHandlerFactory createHandlerWithEvent:eventType source:sourceComponent];
            [welf.bindData putHandler:handler forToken:sourceRef eventType:eventType];
        }
        
        pthread_mutex_unlock(&mutex);
    });
}

- (void)createBinding:(NSString *)sourceRef
            eventType:(NSString *)eventType
       exitExpression:(NSString *)exitExpression
     targetExpression:(NSArray *)targetExpression
             callback:(WXKeepAliveCallback)callback {
    if ([WXUtility isBlankString:sourceRef] || [WXUtility isBlankString:eventType] || !targetExpression || targetExpression.count == 0) {
        WX_LOG(WXLogFlagWarning, @"createBinding params error");
        callback(@{@"state":@"error",@"msg":@"createBinding params error"}, NO);
        return;
    }
    
    if (![EBEventHandlerFactory containsEvent:eventType]) {
        WX_LOG(WXLogFlagWarning, @"createBinding params handler error");
        callback(@{@"state":@"error",@"msg":@"createBinding params handler error"}, NO);
        return;
    }
    
    __weak typeof(self) welf = self;
    WXPerformBlockOnComponentThread(^{
        // find sourceRef & targetRef
        WXComponent *sourceComponent = [weexInstance componentForRef:sourceRef];
        if (!sourceComponent) {
            WX_LOG(WXLogFlagWarning, @"createBinding can't find source component");
            callback(@{@"state":@"error",@"msg":@"createBinding can't find source component"}, NO);
            return;
        }

        NSMapTable<id, NSDictionary *> *targetExpressionMap = [NSMapTable weakToStrongObjectsMapTable];
        for (NSDictionary *targetDic in targetExpression) {
            NSString *targetRef = targetDic[@"element"];
            NSString *property = targetDic[@"property"];
            NSString *expression = targetDic[@"expression"];
            
            WXComponent *targetComponent = [weexInstance componentForRef:targetRef];
            if (targetComponent) {
                
                if ([targetComponent isViewLoaded]) {
                    WXPerformBlockOnMainThread(^{
                        [targetComponent.view.layer removeAllAnimations];
                    });
                }

                NSMutableDictionary *propertyDic = [[targetExpressionMap objectForKey:targetComponent] mutableCopy];
                if (!propertyDic) {
                    propertyDic = [NSMutableDictionary dictionary];
                }
                NSMutableDictionary *expDict = [NSMutableDictionary dictionary];
                expDict[@"expression"] = [EBBindData parseExpression:expression];
                
                if( targetDic[@"config"] )
                {
                    expDict[@"config"] = targetDic[@"config"];
                }
                propertyDic[property] = expDict;
                [targetExpressionMap setObject:propertyDic forKey:targetComponent];
            }
        }
        
        // find handler for key
        pthread_mutex_lock(&mutex);
        
        EBExpressionHandler *handler = [welf.bindData handlerForToken:sourceRef eventType:eventType];
        if (!handler) {
            // create handler for key
            handler = [EBEventHandlerFactory createHandlerWithEvent:eventType source:sourceComponent];
            [welf.bindData putHandler:handler forToken:sourceRef eventType:eventType];
        }

        [handler updateTargetExpression:targetExpressionMap
                                options:nil
                         exitExpression:[EBBindData parseExpression:exitExpression]
                               callback:^(id  _Nonnull source, id  _Nonnull result, BOOL keepAlive) {
                                   callback(result,keepAlive);
                               }];

        pthread_mutex_unlock(&mutex);
    });
}

- (void)disableBinding:(NSString *)sourceRef
             eventType:(NSString *)eventType {
    if ([WXUtility isBlankString:sourceRef] || [WXUtility isBlankString:eventType]) {
        WX_LOG(WXLogFlagWarning, @"disableBinding params error");
        return;
    }
    
    if (![EBEventHandlerFactory containsEvent:eventType]) {
        WX_LOG(WXLogFlagWarning, @"disableBinding params handler error");
        return;
    }
    
    pthread_mutex_lock(&mutex);
    
    EBExpressionHandler *handler = [self.bindData handlerForToken:sourceRef eventType:eventType];
    if (!handler) {
        WX_LOG(WXLogFlagWarning, @"disableBinding can't find handler handler");
        pthread_mutex_unlock(&mutex);
        return;
    }
    
    [handler removeExpressionBinding];
    [self.bindData removeHandler:handler forToken:sourceRef eventType:eventType];
    
    pthread_mutex_unlock(&mutex);
}

- (void)disableAll {
    pthread_mutex_lock(&mutex);
    
    [self.bindData unbindAll];
    
    pthread_mutex_unlock(&mutex);
}

- (NSArray *)supportFeatures {
    return EBsupportFeatures;
}

- (NSDictionary *)getComputedStyle:(NSString *)sourceRef {
    if (![sourceRef isKindOfClass:NSString.class] || [WXUtility isBlankString:sourceRef]) {
        WX_LOG(WXLogFlagWarning, @"getComputedStyle params error");
        return nil;
    }
    
    __block NSMutableDictionary *styles = [NSMutableDictionary new];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    WXPerformBlockOnComponentThread(^{
        // find sourceRef & targetRef
        WXComponent *sourceComponent = [weexInstance componentForRef:sourceRef];
        if (!sourceComponent) {
            WX_LOG(WXLogFlagWarning, @"getComputedStyle can't find source component");
            return;
        }
        NSDictionary* mapping = [EBWXUtils cssPropertyMapping];
        for (NSString* key in mapping) {
            id value = sourceComponent.styles[key];
            if (value) {
                if ([value isKindOfClass:NSString.class]) {
                    NSString *string = (NSString *)value;
                    if ([string hasSuffix:@"px"]) {
                        NSString *number = [string substringToIndex:(string.length-2)];
                        [styles setValue:@([number floatValue]) forKey:mapping[key]];
                    } else {
                        [styles setValue:string forKey:mapping[key]];
                    }
                } else if([value isKindOfClass:NSNumber.class]) {
                    [styles setValue:value forKey:mapping[key]];
                }
            }
        }
        if (sourceComponent.styles[@"borderRadius"]) {
            [styles setValue:sourceComponent.styles[@"borderRadius"] forKey:@"border-top-left-radius"];
            [styles setValue:sourceComponent.styles[@"borderRadius"] forKey:@"border-top-right-radius"];
            [styles setValue:sourceComponent.styles[@"borderRadius"] forKey:@"border-bottom-left-radius"];
            [styles setValue:sourceComponent.styles[@"borderRadius"] forKey:@"border-bottom-right-radius"];
        }
        WXPerformBlockOnMainThread(^{
            CALayer *layer = sourceComponent.view.layer;
            styles[@"translateX"] = [EBUtility transformFactor:@"transform.translation.x" layer:layer];
            styles[@"translateY"] = [EBUtility transformFactor:@"transform.translation.y" layer:layer];
            styles[@"scaleX"] = [layer valueForKeyPath:@"transform.scale.x"];
            styles[@"scaleY"] = [layer valueForKeyPath:@"transform.scale.y"];
            styles[@"rotateX"] = [layer valueForKeyPath:@"transform.rotation.x"];
            styles[@"rotateY"] = [layer valueForKeyPath:@"transform.rotation.y"];
            styles[@"rotateZ"] = [layer valueForKeyPath:@"transform.rotation.z"];
            styles[@"opacity"] = [layer valueForKeyPath:@"opacity"];
            
            dispatch_semaphore_signal(semaphore);
        });
    });
    
    dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)));
    return styles;
}

@end
