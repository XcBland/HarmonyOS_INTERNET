/**
 * @Auhtor DLY
 *
 */
import Want from '@ohos.app.ability.Want'
import common from '@ohos.app.ability.common'

@Entry
@Component
struct Index {
  @State text: string = '你好'
  @State message: string = ''
  @State files: number[] = [1, 2, 3, 4, 5] //表示文件

  build() {
    Column({ space: 20 }) {
      Text(this.text)
      //  指定实例启动案例
      //  利用数组添加元素的方式,提供遍历循环,为后面生成多个按钮
      Button('创建新文件')
        .onClick(() => {
          this.files.push(this.files.length + 1)
        })
      ForEach(this.files, (item: number, index) => {
        Button(`打开文件${item}`)
          .onClick(() => {
            const context = getContext(this) as common.UIAbilityContext

            const want: Want = {
              bundleName: 'com.test.test',
              abilityName: 'Docability',
              moduleName: 'entry',
              // 携带参数,json格式,可以携带到新的UIAbility
              parameters: {
                key: 'id_' + item
              }
            }
            context.startAbility(want).catch((error: Error) => {
              console.error('hmlog error39:' + JSON.stringify(error))
            })
            console.log(`打开文件${item}`)
          })
      })

      //[拉起新的模块]
      Button('拉起新的模块')
        .onClick(() => {
          const want: Want = {
            bundleName: 'com.test.test',
            moduleName: 'hmpay',
            abilityName: 'HmpayAbility',
            parameters: {
              //传一个订单号
              orderId: Date.now()
            }
          }
          const context = getContext(this) as common.UIAbilityContext
          context.startAbilityForResult(want)
            .then((result: common.AbilityResult) => {
              console.log('hmlog result:' + JSON.stringify(result))
              //根据参数判断是否支付成功
              const resultCode:number = result.resultCode              //获取结果码
              const isPay: boolean = (result.want?.parameters as Record<string, boolean>).isPay //获取参数
              console.log('hmlog isPay:' + isPay+'resultCode:'+resultCode)
              //TODO:优化提示信息
              isPay ? this.message = '支付成功' : this.message = '支付失败'
            }).catch((error: Error) => {
            console.error('hmlog error61:' + JSON.stringify(error))
          })
        })
      Text(this.message).fontSize(40)

      Button('唤起新的UIAbility-隐式')
        .onClick(() => {
          const wt:Want ={
            action:'ohos.want.action.search',      //表示调用的方面要执行的通用操作,比如:查看、分享、应用
            entities:["entity.system.browsable"],       //页面浏览器
            uri:'',
            type:''
          }
        })


      Blank()

      Button('唤起新的UIAbility')
        .onClick(() => {
          //第一步:
          //   定义一个Want对象
          //   当启动一个UIAbility的时候,要执行 onCreate()方法
          //   方法中,需要的第一个参数,就是want
          //   作用是提供一个通讯对象,包括设置
          //   系统就是通过want,才知道去找哪一个UIAbility执行
          //   同时,Wang还可以携带参数进行传递

          const want: Want = {

            //want.deviceId = ''                      //设备标识,缺省标识的话是当前设备,如果写别的就可以唤醒别的设备的UIAbility
            bundleName: 'com.test.test', //UIAbility的应用包的名称:app.json5中有的
            moduleName: 'entry', //UIAbility的模块名称:在对应模块的module.json5中
            abilityName: 'Docability'           //UIAbility的名称

          } //定义一个Want对象(也可以 = {括号里面可以写参数})

          //第二步:
          //   基于应用上下文,通过转换,提取出UIAbility实例的上下文对象
          //   要它的作用是为了调用应用中,UIAbility的能力
          //   唤起一个全新的UIAbility的方法
          const context = getContext(this) as common.UIAbilityContext

          //第三步:
          //   调用方法,唤起指定应用的UIAbility
          context.startAbility(want)


        })
    }
    .width('100%')
    .height('100%')

  }
}