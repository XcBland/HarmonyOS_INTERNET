import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
const TAG: string = '[EntryAbility]';
const DOMAIN_NUMBER: number = 0xFF00;
export default class EntryAbility extends UIAbility {
  /*  Create状态为在应用加载过程中，UIAbility实例创建完成时触发，
    系统会调用onCreate()回调。可以在该回调中进行页面初始化操作，
    例如变量定义资源加载等，用于后续的UI展示。
  */
  /*
   Want是对象间信息传递的载体，可以用于应用组件间的信息传递。
  */
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  //[Create状态]
  /*
    UIAbility实例创建完成之后，在进入Foreground之前，系统会创建一个WindowStage。
    WindowStage创建完成后会进入onWindowStageCreate()回调，
    可以在该回调中设置UI加载、设置WindowStage的事件订阅。
  */
  onWindowStageCreate(windowStage: window.WindowStage): void {
    // 创建主窗口，为此功能设置主页
    // 设置WindowStage的事件订阅（获焦/失焦、可见/不可见）
    try {
      windowStage.on('windowStageEvent', (data:window.WindowStageEventType) => {
        switch (data) {
          case window.WindowStageEventType.SHOWN: // 切到前台
            hilog.info(DOMAIN_NUMBER, TAG, 'windowStage foreground.');
            break;
          case window.WindowStageEventType.ACTIVE: // 获焦状态
            hilog.info(DOMAIN_NUMBER, TAG, 'windowStage active.');
            break;
          case window.WindowStageEventType.INACTIVE: // 失焦状态
            hilog.info(DOMAIN_NUMBER, TAG, 'windowStage inactive.');
            break;
          case window.WindowStageEventType.HIDDEN: // 切到后台
            hilog.info(DOMAIN_NUMBER, TAG, 'windowStage background.');
            break;
          default:
            break;
        }
      });
    } catch (exception) {
      hilog.error(DOMAIN_NUMBER, TAG, 'Failed to enable the listener for window stage event changes. Cause:' + JSON.stringify(exception));
    }

    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    //窗口默认加载
    //当窗口创建完成之后，默认需要加载一个页面，这里加载的是pages/Index页面
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(DOMAIN_NUMBER, TAG,'Succeeded in loading the content.');
    });
  }

  // [前台运行]
  onForeground(): void {
    // Ability has brought to foreground
    console.log('应用运行时切换到前台')
  }

  // [后台运行]
  onBackground(): void {
    // Ability has back to background
    console.log('切到后台,没有关闭,还在运行')
  }

  //[窗口即将销毁]
  onWindowStageWillDestroy(windowStage: window.WindowStage): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageWillDestroy');
  }
  //[销毁阶段-销毁窗口]
  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }
  //[销毁阶段-Ability销毁]
  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }



}
