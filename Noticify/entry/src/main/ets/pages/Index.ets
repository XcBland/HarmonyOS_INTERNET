/**
 * @Auhtor DLY
 *
 */
import { notificationManager } from '@kit.NotificationKit'
import common from '@ohos.app.ability.common'
import { wantAgent } from '@kit.AbilityKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { image } from '@kit.ImageKit'

@Entry
@Component
struct Index {
  @State isOpen: boolean = false

  //生命周期
  async aboutToAppear() {
    const context = getContext(this) as common.UIAbilityContext

    //判断系统是否对当前应用开启通知
    this.isOpen = await notificationManager.isNotificationEnabled()
    if (!this.isOpen) {
      //请求用户开启通知
      notificationManager.requestEnableNotification(context).then(() => {
        //用户同意开启通知
        this.isOpen = true
        console.log('用户同意开启通知')
      }).catch((err: Error) => {
        //用户拒绝开启通知
        /**
         1600001  内部错误。
         1600002  编组或解组错误。
         1600003  未能连接到服务。
         1600004  通知已禁用。
         1600013  已显示通知对话框。
         */
        console.log('用户拒绝开启通知')
        this.isOpen = false
      })
    }

  }

  @State uid: number = 0

  build() {
    Column({ space: 20 }) {

      //[文本通知]
      Button(
        '[文本通知]'
      )
        .onClick(async () => {
          this.uid++
          notificationManager.setBadgeNumber(this.uid) //设置角标
          //如果要点击通知,拉起应用,这里就配置一下wantAgent
          const want = await wantAgent.getWantAgent({
            //要被拉起的应用的UIAbility
            wants: [{
              bundleName: 'com.test.myapplication',
              abilityName: 'EntryAbility',
            }],
            actionType: wantAgent.OperationType.START_ABILITY, //启动方式
            //请求码
            //目的是为了获取到回调数据
            requestCode: 0,
            //启动模式：
            wantAgentFlags: [wantAgent.WantAgentFlags.CONSTANT_FLAG]
          })
          //定义通知请求对象
          const nr: notificationManager.NotificationRequest = {
            //通知ID
            id: 1,
            //通知内容定义
            content: {
              //普通文本类型
              notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
              //文本内容:基于上面的类型,下面的内容定义不同
              normal: {
                title: '红包提醒',
                text: '请做好准备,还有一分钟,红包即将发出',
                additionalText: '额外发布的,红包不多~~~~'
              },
            },
            //通知类型:普通通知
            notificationSlotType: notificationManager.SlotType.SOCIAL_COMMUNICATION,
          }
          //发送通知
          //发送后,会返回一个promise对象,可以监听通知是否发送成功
          notificationManager.publish(nr).then(() => {
            console.log('通知发送成功')
          }).catch((err: Error) => {
            console.log('通知发送失败')
          })


        })


      Button('[自定义通知]')
        .onClick(() => {
          let notificationRequest: notificationManager.NotificationRequest = {
            id: 5,
            content: {
              notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
              normal: {
                title: 'test_title',
                text: 'test_text',
                additionalText: 'test_additionalText'
              }
            },
            // 构造进度条模板，name字段当前需要固定配置为downloadTemplate
            template: {
              name: 'downloadTemplate',
              data: { title: 'File Title', fileName: 'music.mp4', progressValue: 45 }
            },
            notificationSlotType:notificationManager.SlotType.SOCIAL_COMMUNICATION

          }
          // 发布通知
          notificationManager.publish(notificationRequest, (err: BusinessError) => {
            if (err) {
              console.error(`Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
              return;
            }
            console.info('Succeeded in publishing notification.');
          });
        })

      Button('[多行通知')
        .onClick(async () => {
          let notifi: notificationManager.NotificationRequest = {
            id: 2,
            content: {
              notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE,
              multiLine: {
                title: '这是一个多行通知',
                text: 'this is a long text',
                briefText: '这是一个简短的描述',
                longTitle: '这是第一行的标题',
                lines: ['第一行', '第二行', '第三行']
              },
            },
            notificationSlotType: notificationManager.SlotType.SOCIAL_COMMUNICATION,
          }
          notificationManager.publish(notifi, (err: BusinessError) => {
            if (err) {
              console.error(`Failed to publish notification. Code is ${err.code}, message is ${err.message}`)
              return
            } else {
              console.info('Succeeded in publishing notification.')
            }
          })
        })


      //============================================================
      //[图片通知]
      //支持唤起应用的功能
      //图片被编译项目后,变成项目资源
      Button('[图片通知]')
        .onClick(async () => {
          //[获取图片资源]
          const context = getContext(this).resourceManager //获取上下文
          //通过资源管理器获取媒体图片的Unit8的内容数组
          const imageArr = await context.getMediaContent($r('app.media.app_icon'))

          ///[图片转换为像素数组]
          const imagePixelMap =await image.createImageSource(imageArr.buffer).createPixelMap()

          const want = await wantAgent.getWantAgent({
            wants: [{
              bundleName:'com.test.myapplication',
              abilityName:'EntryAbility'
            }],
            requestCode: 0,
            actionType: wantAgent.OperationType.START_ABILITY,
          })
          //[发送通知]
          notificationManager.publish({
            id: 3,
            content: {
              notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_PICTURE,
              picture: {
                title: '图片通知',
                text: '这是一张图片',
                briefText: '这是一个图片通知',
                expandedTitle:'美丽的黄昏与城市相互映衬', //展开后的标题
                picture: imagePixelMap,
              }
            },
            wantAgent: want,
            notificationSlotType: notificationManager.SlotType.SOCIAL_COMMUNICATION,
            //团队名称
            groupName: 'weChat',
            //发布时间
            deliveryTime: new Date().getTime()+1000*60*60*24,
            //是否显示发布时间
            showDeliveryTime: true
          })


        })


      Button('关闭通知')
        .onClick(() => {
          notificationManager.cancelAll().then(() => {
            console.log('关闭成功')
          }).catch((err: Error) => {
            console.log('关闭失败')
          })
        })


    }
    .width('100%')
    .height('100%')

  }
}