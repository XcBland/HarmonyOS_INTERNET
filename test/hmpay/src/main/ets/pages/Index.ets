/**
 * @Auhtor DLY
 *
 */
import common from '@ohos.app.ability.common'

@Entry
@Component
struct Index {

  //通过状态管理,获取AppStorage中,指定名称的参数值
  @StorageProp('orderId') orderId:number = -1








  build() {
    Column({space:10}) {
      Text('支付模块').fontSize(30).fontWeight(FontWeight.Bold)
      //订单号
      Text(this.orderId.toString())
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Red)

      //模块完成自己的工作
      //之后,这里利用按钮定义代码,实现反馈结果
      Button('支付').onClick(() => {
        //上下文对象
        const context = getContext(this) as common.UIAbilityContext

        const result:common.AbilityResult = {
          resultCode:1, //成功:响应回复编码
          want:{
            bundleName:'com.test.test',
            moduleName:'entry',
            abilityName:'EntryAbility',
            parameters:{
              isPay:true
            }
          }
        }
        //终止当前UIAbility  -  关闭
        //打开另一个Ability,同时返回结果
        //由于:entry模块是单例模式,因此返回的是之前的Ability
        context.terminateSelfWithResult(result)
      })
    }
    .padding(10)
    .width('100%')
    .height('100%')


  }
}