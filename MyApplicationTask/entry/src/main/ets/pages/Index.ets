//导入依赖
import { media } from '@kit.MediaKit'
import { avSession } from '@kit.AVSessionKit'
import { common, Want, WantAgent, wantAgent } from '@kit.AbilityKit'
import backgroundTaskManager from '@ohos.resourceschedule.backgroundTaskManager'
import { BusinessError } from '@kit.BasicServicesKit'
import { notificationManager } from '@kit.NotificationKit'


@Entry
@Component
struct Index {
  private html:string = 'https://atstudy-1253850831.cos.ap-shanghai.myqcloud.com/lab-d3/harmonyOS/music/15.m4a'

  //属性
  avPlayer:media.AVPlayer = {} as media.AVPlayer            //媒体播放器控制
  session:avSession.AVSession = {} as avSession.AVSession   //播放器的实体类对象

  //创建一个媒体控制器器:只有功能,没有布局
  async createSession(){
    //控制器的类型
    const type:avSession.AVSessionType = 'audio'
    //异步：控制器实例
    this.session =await avSession.createAVSession(
      getContext(this),
      'SESSION_MUSIC',
      type)
    //播放器激活聚焦
    await this.session.activate()
  }

  //生命周期
  async aboutToAppear(){
    //申请权限
    let isOpen = await notificationManager.isNotificationEnabled()
    if (!isOpen) {
      //弹窗申请
      notificationManager.requestEnableNotification(
        getContext(this) as common.UIAbilityContext
      )
    }


    //创建播放器
    this.avPlayer = await media.createAVPlayer()
    //设置播放器的音频地址(src: media.MediaSource, strategy?: media.PlaybackStrategy | undefined)
    this.avPlayer.url = this.html
    //设置播放器的状态监听
    this.avPlayer.on('stateChange',(state: string, reason: media.StateChangeReason)=>{
      //判断状态
      switch (state){
        case 'initialized':
        case 'stopped':
          console.log('停止播放')
          this.avPlayer.prepare()             //准备播放
          break
        case 'paused':
          console.log('暂停播放')
          this.avPlayer.pause()              //暂停
          break
        case 'playing':
          console.log('正在播放')
          this.avPlayer.play()               //播放
          break
        case 'error':
          console.log('播放出错'+JSON.stringify(reason))
          break
      }
    })
  }

  //播放,本身就要执行音乐播放，只是切换到后台要继续
  //因此，播放操作放入长时任务，支持拉起应用返回回来
  async play(){
    const want:WantAgent =await wantAgent.getWantAgent({
      wants:[{
        bundleName: 'com.test.myapplication',
        abilityName: 'EntryAbility'
      }],
      requestCode:0,
      //响应：启动应用
      actionType:wantAgent.OperationType.START_ABILITY,
      //启动模式：更新
      actionFlags:[wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    })

    //启动长时任务
    //后台工作管理器，启动后台运行
    backgroundTaskManager.startBackgroundRunning(
      getContext(this),                                     //上下文
      backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK,  //后台模式:音乐播放
      want                                                  //启动意图
    )
      .then(()=>{
        this.createSession()     //创建播放器
        this.avPlayer!.play()     //播放
      })
      .catch((err:BusinessError)=>{
      console.log('启动长时任务失败'+JSON.stringify(err))
    })

    //启动通知
    notificationManager.publish({
      id:1,
      content:{
        notificationContentType:notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal:{
          title:'音乐播放',
          text:'正在后台播放音乐',
          additionalText:'点击查看详情'
        }
      },
      wantAgent:want,
      notificationSlotType:notificationManager.SlotType.SOCIAL_COMMUNICATION,
      groupName:'QQMusic',
      deliveryTime:new Date().getTime() + 1000,                //通知延迟1s
    }).then(()=>{
      console.log('通知发布成功')
    }).catch((err:BusinessError)=>{
      console.log('通知发布失败'+JSON.stringify(err))
    })
  }

  //停止
  async stop(){
    backgroundTaskManager.stopBackgroundRunning(
      getContext(this)).then(()=>{
        this.session!.deactivate()
        this.avPlayer!.stop()
    }).catch((err:BusinessError)=>{
      console.log('停止长时任务失败'+JSON.stringify(err))
    })
  }

  //暂停
  async pause(){
    backgroundTaskManager.stopBackgroundRunning(
      getContext(this)).then(()=>{
      this.avPlayer!.pause()
    }).catch((err:BusinessError)=>{
      console.log('停止长时任务失败'+JSON.stringify(err))
    })
  }



  @State isPlaying:boolean = false //播放状态

  build() {
    Column({space:20}) {
      Text('后台长时任务').fontSize(30)

      Row(){
        Image($r('app.media.109951165796417308'))
          .width(200)
          .height(200)
          .margin({top:20})
          .borderRadius(10)
      }

      Column({space:10}){
        Text('海阔天空')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
        Text('Boundless Oceans, Vast Skies')
          .fontSize(12)
          .fontColor('#999')
        Text(){
          Span('歌手：')
          .fontWeight(FontWeight.Bold)
          .fontColor('#888')
          .fontSize(10)
          Span('Beyond')
          .fontColor('#ff04b0fc')
            .fontSize(10)
        }
        Text(){
          Span('所属专辑：')
            .fontWeight(FontWeight.Bold)
            .fontColor('#888')
            .fontSize(10)
          Span('Beyond 25th Anniversary')
            .fontColor('#ff04b0fc')
            .fontSize(10)
        }
      }

      Row({space:20}){
        if(this.isPlaying) {
          Image($r('app.media.stop'))
            .backgroundColor('#ccc')
            .borderRadius(100)
            .width(50)
            .onClick(() => {
              this.isPlaying = !this.isPlaying
              this.pause()
            })
        } else {
          //申请长时任务
          Image($r('app.media.play'))
            .backgroundColor('#ccc')
            .borderRadius(100)
            .width(50)
            .onClick(() => {
              this.isPlaying = !this.isPlaying
              this.play()
            })
        }

        Image($r('app.media.stop01'))
          .width(50)
          .onClick(()=>{
            this.isPlaying = false
            this.stop()
            notificationManager.cancelAll()  //取消所有通知
          })
      }
      .margin({top:50})
      .width('100%')
      .justifyContent(FlexAlign.Center)




    }
    .backgroundColor('#f1f3f5')
    .width('100%')
    .height('100%')


  }
}