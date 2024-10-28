/**
 * @Auhtor DLY
 *
 */
import Want from '@ohos.app.ability.Want'
import common from '@ohos.app.ability.common'

@Entry
@Component
struct Index {
  @State files:number[]=[1,2,3]
  build() {
    Column() {
      Button('创建文件夹')
        .onClick(()=>{
          this.files.push(this.files.length+1)
        })
      ForEach(this.files, (item:number, index) => {
        Button(`文件${item}`)
          .onClick(()=>{
            const want:Want ={
              bundleName:'com.test.myapplication01',
              abilityName:'DoctorAbility',
              moduleName:'entry',
              parameters:{
                key:`id_${item}`
              }
            }
            const context = getContext(this) as common.UIAbilityContext

            context.startAbility(want)
          })
      })
    }
    .width('100%')
    .height('100%')

    
  }
}