import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

export default class HmpayAbility extends UIAbility {

  /**
   * 获取参数
   * @param want
   */
  getParams(want:Want){
    //获取参数,如果没有,返回-1
    const orderId = (want.parameters as Record<string, number>).orderId || -1;
    AppStorage.setOrCreate('orderId',orderId)
  }


  // UIAbility生命周期:创建
  //[只能适用于-首次创建]:每次都会新建一个,方法会创建
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.getParams(want)
  }

  //特定:当接收到新的want的时候
  //[适用于-已有实例的时候]
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.getParams(want)
  }






  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index');
  }

}
