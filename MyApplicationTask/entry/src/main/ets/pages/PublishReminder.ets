/**
 * @Auhtor DLY
 *
 */
import { reminderAgentManager } from '@kit.BackgroundTasksKit'
import { notificationManager } from '@kit.NotificationKit'
import { common } from '@kit.AbilityKit'
import { BusinessError } from '@kit.BasicServicesKit'

@Entry
@Component
struct PublishReminder {
  //生命周期
  async aboutToAppear() {
    //申请通知权限
    let isOpen = await notificationManager.isNotificationEnabled()
    if (!isOpen) {
      //弹窗申请
      await notificationManager.requestEnableNotification(
        getContext(this) as common.UIAbilityContext
      )
    }
  }

  @State reminderId: number[] = []

  build() {
    Column({space:20}) {
      Button('发布-倒计时-代理提醒').onClick(() => {
        //创建倒计时请求对象
        const countDownRequest: reminderAgentManager.ReminderRequestTimer = {
          //请求类型:定时器(倒计时)
          reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_TIMER,
          //触发时间(单位:秒)
          triggerTimeInSeconds: 5,
          //响应按钮设置
          actionButton: [
            {
              title: '关闭',
              type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_CLOSE //关闭按钮||0
            }
          ],
          //点击提醒通知,拉起应用程序
          wantAgent: {
            pkgName: 'com.test.myapplication',
            abilityName: 'EntryAbility'
          },
          title: '发红包提醒',
          content: '距离红包发放还有5秒',
          expiredContent: '红包已过期',
          notificationId: 1000, //通知ID
          slotType: notificationManager.SlotType.SOCIAL_COMMUNICATION //通知栏显示位置
        }

        reminderAgentManager.publishReminder(countDownRequest)
          .then((reminderId: number) => {
            this.reminderId.push(reminderId)
            console.log('publishReminder success:', reminderId)
          })
          .catch((error: Error) => {
            console.log('publishReminder error:', JSON.stringify(error))
          })


      })

      Button('发布-日历-代理提醒').onClick(() => {
        let targetReminderAgent: reminderAgentManager.ReminderRequestCalendar = {
          reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_CALENDAR, // 提醒类型为日历类型
          dateTime: {
            // 指明提醒的目标时间
            year: 2023,
            month: 1,
            day: 1,
            hour: 11,
            minute: 14,
            second: 30
          },
          repeatMonths: [1], // 指明重复提醒的月份
          repeatDays: [1], // 指明重复提醒的日期
          actionButton: [// 设置弹出的提醒通知信息上显示的按钮类型和标题
            {
              title: 'close',
              type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_CLOSE
            },
            {
              title: 'snooze',
              type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_SNOOZE
            },
          ],
          wantAgent: {
            // 点击提醒通知后跳转的目标UIAbility信息
            pkgName: 'com.example.myapplication',
            abilityName: 'EntryAbility'
          },
          maxScreenWantAgent: {
            // 全屏显示提醒到达时自动拉起的目标UIAbility信息
            pkgName: 'com.test.myapplication',
            abilityName: 'EntryAbility'
          },
          ringDuration: 5, // 指明响铃时长（单位：秒）
          snoozeTimes: 2, // 指明延迟提醒次数
          timeInterval: 5 * 60, // 执行延迟提醒间隔（单位：秒）
          title: 'this is title', // 指明提醒标题
          content: 'this is content', // 指明提醒内容
          expiredContent: 'this reminder has expired', // 指明提醒过期后需要显示的内容
          snoozeContent: 'remind later', // 指明延迟提醒时需要显示的内容
          notificationId: 100, // 指明提醒使用的通知的ID号，相同ID号的提醒会覆盖
          slotType: notificationManager.SlotType.SOCIAL_COMMUNICATION // 指明提醒的Slot类型
        }
        reminderAgentManager.publishReminder(targetReminderAgent)
          .then((reminderId: number) => {
            this.reminderId.push(reminderId)
            console.log('publishReminder success:', reminderId)
          })
          .catch((error: BusinessError) => {
            console.log('publishReminder error:', JSON.stringify(error))
          })


      })

      Button('发布-闹钟-代理提醒').onClick(() => {
        const alarm: reminderAgentManager.ReminderRequestAlarm = {
          reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_ALARM,
          hour: 12,
          minute: 43,
          daysOfWeek: [1, 2, 3, 4, 5],
          actionButton: [// 设置弹出的提醒通知信息上显示的按钮类型和标题
            {
              title: 'close',
              type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_CLOSE
            },
            {
              title: 'snooze',
              type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_SNOOZE
            },
          ],
          wantAgent: {
            // 点击提醒通知后跳转的目标UIAbility信息
            pkgName: 'com.test.myapplication',
            abilityName: 'EntryAbility'
          },
          ringDuration: 5, // 指明响铃时长（单位：秒）
          snoozeTimes: 2, // 指明延迟提醒次数
          timeInterval: 5 * 60, // 执行延迟提醒间隔（单位：秒）
          title: 'this is title', // 指明提醒标题
          content: 'this is content', // 指明提醒内容
          expiredContent: 'this reminder has expired', // 指明提醒过期后需要显示的内容
          snoozeContent: 'remind later', // 指明延迟提醒时需要显示的内容
          notificationId: 99, // 指明提醒使用的通知的ID号，相同ID号的提醒会覆盖
          slotType: notificationManager.SlotType.SOCIAL_COMMUNICATION // 指明提醒的Slot类型
        }
        reminderAgentManager.publishReminder(alarm)
          .then((reminderId: number) => {
            this.reminderId.push(reminderId)
            console.log('publishReminder success:', reminderId)
          })
          .catch((error: BusinessError) => {
            console.log('publishReminder error:', JSON.stringify(error))
          })
      })

      Button('删除提醒任务').onClick(()=>{
        // reminderId的值从发布提醒代理成功之后的回调中获得
        reminderAgentManager.cancelAllReminders().then(() => {
          console.log('Succeeded in canceling reminder.');
        }).catch((err: BusinessError) => {
          console.error(`Failed to cancel reminder. Code: ${err.code}, message: ${err.message}`);
        });
      })

      Button('取消 - 闹钟代理').onClick(async ()=>{
        //获取所有可用的代理提醒
        //从系统中获取到的
        const res:reminderAgentManager.ReminderRequest[] =
          await reminderAgentManager.getValidReminders()
        //通过遍历循环,可以知道系统中有哪些代理
        for(let i=0;i<res.length;i++){
          console.log(JSON.stringify(res[i].reminderType))
        }

        //删除某个提醒任务
        //reminderAgentManager.cancelReminder(this.reminderId[0])

        //循环或者指定
        //id在数组中,所以需要在数组中循环删除
        reminderAgentManager.cancelReminder(this.reminderId[this.reminderId.length-1])
      })


    }
    .width('100%')
    .height('100%')

  }
}