//
//  BMChartComponent.m
//  BMBaseLibrary
//
//  Created by XHY on 2017/10/18.
//

#import "BMChartComponent.h"
#import <WeexSDK/WXSDKInstance_private.h>
#import <WeexSDK/WXComponent_internal.h>
#import <WebKit/WebKit.h>
#import <WeexSDK/WXUtility.h>
#import <YYModel/YYModel.h>
#import "BMDefine.h"

NSString * const ChartInfo = @"options";

@interface BMChartComponent()<WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *webview;    /**< webView */
@property (nonatomic,copy) NSString *chartInfo;     /**< 图标数据 */
@property (nonatomic, copy) NSString *src; /**< html文件路径 */

/** event */
@property (nonatomic,assign) BOOL finishEvent; /**< 图表加载完毕事件 */

@end

@implementation BMChartComponent

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance
{
    if (self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance]) {
        
        _finishEvent = NO;
        
        if (attributes[ChartInfo]) {
            _chartInfo = [NSString stringWithFormat:@"%@",attributes[ChartInfo]];
        }
        
        if (attributes[@"src"]) {
            self.src = [WXConvert NSString:attributes[@"src"]];
        }
        
        [self createWebView];
        
    }
    return self;
}

- (void)createWebView
{
    WXPerformBlockOnMainThread(^{
        WKWebView *webview = [[WKWebView alloc] init];
        webview.navigationDelegate = self;
        webview.scrollView.scrollEnabled = NO;
        webview.opaque = NO;
        self.webview = webview;
        
        if (self.src) {
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.src]];
            [self.webview loadRequest:request];
        } else {
            [self loadHtmlFormBundle];
        }
    });
}

/** 从工程中加载 html */
- (void)loadHtmlFormBundle
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bm-chart" ofType:@"html"];
    NSString *htmlStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.webview loadHTMLString:htmlStr baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

- (void)fillAttributes:(NSDictionary *)attributes
{
    if (attributes[ChartInfo]) {
        NSString *info = [NSString stringWithFormat:@"%@",attributes[ChartInfo]];;
        
        if (![info isEqualToString:self.chartInfo]) {
            self.chartInfo = info;
            WXPerformBlockOnMainThread(^{
                [self runChatInfo];
            });
        }
        
    }
}

- (void)addEvent:(NSString *)eventName
{
    if ([eventName isEqualToString:@"finish"]) {
        _finishEvent = YES;
    }
}

- (UIView *)loadView
{
    return self.webview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)updateAttributes:(NSDictionary *)attributes
{
    [self fillAttributes:attributes];
}

- (void)_updateAttributesOnComponentThread:(NSDictionary *)attributes
{
    [super _updateAttributesOnComponentThread:attributes];
    
    [self fillAttributes:attributes];
}

- (void)webViewRunScript:(NSString *)script
{
    [self.webview evaluateJavaScript:script completionHandler:^(id _Nullable dict, NSError * _Nullable error) {
        if (error) {
            WXLogError(@"Run script:%@ Error:%@",script,error);
        }
    }];
}

- (void)runChatInfo
{
    NSString *script = [NSString stringWithFormat:@"setOption(%@)",self.chartInfo];
    [self.webview evaluateJavaScript:script completionHandler:^(id _Nullable dict, NSError * _Nullable error) {
        if (error) {
            WXLogError(@"Run script:%@ Error:%@",script,error);
        }
        else if (_finishEvent) {
            [self fireEvent:@"finish" params:nil];
        }
    }];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    WXLogInfo(@"\n【webView】didStartProvisionalNavigation");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    WXLogInfo(@"\n【webView】didFinishNavigation");
    
    if (!self.chartInfo) {
        return;
    }
    
//    NSString *echartJsPath = [[NSBundle mainBundle] pathForResource:@"echarts.min" ofType:@"js"];
//    NSString *echartJsStr = [NSString stringWithContentsOfFile:echartJsPath encoding:NSUTF8StringEncoding error:nil];
//    [self webViewRunScript:echartJsStr];

    //    NSString *script = @"setOption({'tooltip':{'show':true},'legend':{'data':['数量（吨）']},'xAxis':[{'type':'category','data':['桔子','香蕉','苹果','西瓜']}],'yAxis':[{'type':'value'}],'series':[{'name':'数量（吨）','type':'bar','data':[100,200,300,400]}]})";
    
    [self runChatInfo];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if (error) {
        WXLogError(@"%@",error);
    }
}

@end
